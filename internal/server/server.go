// Package server serves the Githeft API: on a Unix socket for the app on
// the same device, or on TCP with gRPC-Web and the web app for browsers.
package server

import (
	"context"
	"crypto/subtle"
	"errors"
	"log"
	"net"
	"net/http"
	"os"
	"path/filepath"
	"strings"
	"time"

	"github.com/kvth/githeft/gen/githeft/v1/githeftv1connect"
	"github.com/kvth/githeft/internal/service"
)

// Options configure Handler.
type Options struct {
	// WebDir is the Flutter web build to serve at /.
	WebDir string
	// Password protects everything with HTTP basic auth (any user name).
	Password string
}

// Handler serves the API (gRPC, gRPC-Web and Connect) and the web app.
func Handler(svc *service.Service, opts Options) http.Handler {
	mux := http.NewServeMux()
	path, api := githeftv1connect.NewGitheftHandler(svc)
	mux.Handle(path, api)
	if opts.WebDir != "" {
		mux.Handle("/", webApp(opts.WebDir))
	}
	var h http.Handler = mux
	if opts.Password != "" {
		h = basicAuth(h, opts.Password)
	}
	return h
}

// webApp serves the Flutter web build; unknown paths get index.html so the
// app's own routes work on reload.
func webApp(dir string) http.Handler {
	files := http.FileServer(http.Dir(dir))
	return http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
		p := filepath.Join(dir, filepath.FromSlash(filepath.Clean("/"+r.URL.Path)))
		if _, err := os.Stat(p); errors.Is(err, os.ErrNotExist) {
			r.URL.Path = "/"
		}
		if r.URL.Path == "/" || strings.HasSuffix(r.URL.Path, ".html") {
			w.Header().Set("Cache-Control", "no-cache")
		}
		files.ServeHTTP(w, r)
	})
}

func basicAuth(next http.Handler, password string) http.Handler {
	return http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
		_, pw, _ := r.BasicAuth()
		if subtle.ConstantTimeCompare([]byte(pw), []byte(password)) != 1 {
			w.Header().Set("WWW-Authenticate", `Basic realm="Githeft"`)
			http.Error(w, "unauthorized", http.StatusUnauthorized)
			return
		}
		next.ServeHTTP(w, r)
	})
}

// Serve answers on l until ctx ends. HTTP/2 without TLS is on for native
// gRPC clients, HTTP/1.1 for browsers.
func Serve(ctx context.Context, l net.Listener, h http.Handler) error {
	var protocols http.Protocols
	protocols.SetHTTP1(true)
	protocols.SetUnencryptedHTTP2(true)
	srv := &http.Server{Handler: h, Protocols: &protocols, ReadHeaderTimeout: 30 * time.Second}
	go func() {
		<-ctx.Done()
		shutdown, cancel := context.WithTimeout(context.Background(), 5*time.Second)
		defer cancel()
		srv.Shutdown(shutdown)
	}()
	err := srv.Serve(l)
	if errors.Is(err, http.ErrServerClosed) {
		return nil
	}
	return err
}

// ListenUnix listens on a Unix socket only the user can connect to,
// replacing a stale socket file.
func ListenUnix(path string) (net.Listener, error) {
	if err := os.MkdirAll(filepath.Dir(path), 0o700); err != nil {
		return nil, err
	}
	os.Remove(path)
	l, err := net.Listen("unix", path)
	if err != nil {
		return nil, err
	}
	if err := os.Chmod(path, 0o600); err != nil {
		l.Close()
		return nil, err
	}
	log.Printf("listening on %s", path)
	return l, nil
}
