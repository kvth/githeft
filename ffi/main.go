// Package main is libgitheft.so, the Go core the Flutter app loads through
// dart:ffi on Android and Linux. It serves the gRPC API on a Unix socket in
// the app's private storage; the app then talks plain gRPC to it.
//
// Build: go build -buildmode=c-shared -o libgitheft.so ./ffi
package main

/*
#include <stdlib.h>
*/
import "C"

import (
	"context"
	"fmt"
	"io"
	"log"
	"os"
	"path/filepath"
	"sync"
	"time"
	"unsafe"

	"connectrpc.com/connect"

	v1 "github.com/kvth/githeft/gen/githeft/v1"
	"github.com/kvth/githeft/internal/server"
	"github.com/kvth/githeft/internal/service"
)

var (
	mu      sync.Mutex
	running context.CancelFunc
	socket  string
	// current is the service the app talks to, which background syncs in
	// the same process share.
	current    *service.Service
	currentDir string
)

// GitheftStart opens the data directory and serves the API on socketPath.
// existingPaths allows notebooks in folders outside dataDir. It
// returns NULL on success or an error message the caller frees with
// GitheftFree. Starting again with the same socket while running is a no-op.
//
//export GitheftStart
func GitheftStart(dataDir, socketPath *C.char, existingPaths C.int) *C.char {
	mu.Lock()
	defer mu.Unlock()
	dir, sock := C.GoString(dataDir), C.GoString(socketPath)
	if running != nil {
		if sock == socket {
			return nil
		}
		running()
		running = nil
	}
	if err := start(dir, sock, existingPaths != 0); err != nil {
		return C.CString(err.Error())
	}
	return nil
}

func start(dir, sock string, existingPaths bool) error {
	if err := os.MkdirAll(dir, 0o700); err != nil {
		return err
	}
	prepare(dir)
	svc, err := service.New(dir)
	if err != nil {
		return err
	}
	svc.AllowExistingPaths = existingPaths
	current, currentDir = svc, dir
	l, err := server.ListenUnix(sock)
	if err != nil {
		return fmt.Errorf("listen on %s: %w", sock, err)
	}
	ctx, cancel := context.WithCancel(context.Background())
	running, socket = cancel, sock
	go func() {
		if err := server.Serve(ctx, l, server.Handler(svc, server.Options{})); err != nil {
			log.Printf("server stopped: %v", err)
		}
	}()
	return nil
}

// prepare sets up logging and the environment go-git expects.
func prepare(dir string) {
	setupLog(dir)
	// Android has no HOME; go-git looks there for the SSH and git config.
	if os.Getenv("HOME") == "" {
		os.Setenv("HOME", dir)
	}
}

// syncAll syncs the notebooks with automatic sync, for the background job.
// It uses the app's service when the app runs in this process, else opens
// the data directory itself. The result is a line for the log.
func syncAll(dir string) string {
	mu.Lock()
	svc := current
	if currentDir != dir {
		svc = nil
	}
	mu.Unlock()
	if svc == nil {
		if err := os.MkdirAll(dir, 0o700); err != nil {
			return "error: " + err.Error()
		}
		prepare(dir)
		var err error
		if svc, err = service.New(dir); err != nil {
			return "error: " + err.Error()
		}
	}
	ctx, cancel := context.WithTimeout(context.Background(), 9*time.Minute)
	defer cancel()
	res, err := svc.SyncAll(ctx, connect.NewRequest(&v1.SyncAllRequest{}))
	if err != nil {
		log.Printf("background sync: %v", err)
		return "error: " + err.Error()
	}
	synced, failed := 0, 0
	for _, st := range res.Msg.Statuses {
		if st.State == v1.SyncState_SYNC_STATE_ERROR {
			failed++
		} else {
			synced++
		}
	}
	msg := fmt.Sprintf("background sync: %d synced, %d failed", synced, failed)
	log.Print(msg)
	return msg
}

// GitheftSyncAll runs syncAll; the caller frees the result with
// GitheftFree.
//
//export GitheftSyncAll
func GitheftSyncAll(dataDir *C.char) *C.char {
	return C.CString(syncAll(C.GoString(dataDir)))
}

// setupLog writes the log to githeft.log in the data directory, since on
// Android nothing reads stderr. The previous log is kept as githeft.log.1.
func setupLog(dir string) {
	p := filepath.Join(dir, "githeft.log")
	if fi, err := os.Stat(p); err == nil && fi.Size() > 1<<20 {
		os.Rename(p, p+".1")
	}
	f, err := os.OpenFile(p, os.O_APPEND|os.O_CREATE|os.O_WRONLY, 0o600)
	if err != nil {
		return
	}
	log.SetOutput(io.MultiWriter(f, os.Stderr))
	log.SetFlags(log.LstdFlags | log.Lmicroseconds)
}

// GitheftStop stops serving.
//
//export GitheftStop
func GitheftStop() {
	mu.Lock()
	defer mu.Unlock()
	if running != nil {
		running()
		running = nil
		os.Remove(socket)
	}
}

// GitheftFree frees a string returned by GitheftStart.
//
//export GitheftFree
func GitheftFree(s *C.char) {
	C.free(unsafe.Pointer(s))
}

func main() {}
