// Command githeft runs the Githeft core on its own: as the server of the web
// version, or to sync notebooks from a terminal or a timer.
//
//	githeft serve [-listen :8080] [-web app/build/web] [-password …] [-sync-every 15m]
//	githeft serve -socket /run/user/1000/githeft.sock
//	githeft list
//	githeft sync [notebook…]
//	githeft sync -auto            (notebooks with automatic sync, for a timer)
package main

import (
	"context"
	"flag"
	"fmt"
	"log"
	"net"
	"os"
	"os/signal"
	"path/filepath"
	"syscall"
	"time"

	"connectrpc.com/connect"

	v1 "github.com/kvth/githeft/gen/githeft/v1"
	"github.com/kvth/githeft/internal/server"
	"github.com/kvth/githeft/internal/service"
)

func defaultDataDir() string {
	if d := os.Getenv("XDG_DATA_HOME"); d != "" {
		return filepath.Join(d, "githeft")
	}
	home, _ := os.UserHomeDir()
	return filepath.Join(home, ".local", "share", "githeft")
}

func usage() {
	fmt.Fprintf(os.Stderr, `usage: githeft [-data dir] <command>

commands:
  serve   serve the API and the web app
  list    list the notebooks
  sync    sync all notebooks, or the named ones; -auto: those with automatic sync

`)
	flag.PrintDefaults()
}

func main() {
	data := flag.String("data", defaultDataDir(), "data directory (notebooks, keys, config)")
	flag.Usage = usage
	flag.Parse()
	if flag.NArg() == 0 {
		usage()
		os.Exit(2)
	}
	svc, err := service.New(*data)
	if err != nil {
		log.Fatal(err)
	}
	svc.AllowExistingPaths = true
	ctx, stop := signal.NotifyContext(context.Background(), os.Interrupt, syscall.SIGTERM)
	defer stop()

	switch cmd, args := flag.Arg(0), flag.Args()[1:]; cmd {
	case "serve":
		err = serve(ctx, svc, args)
	case "list":
		err = list(ctx, svc)
	case "sync":
		err = syncNotebooks(ctx, svc, args)
	default:
		usage()
		os.Exit(2)
	}
	if err != nil {
		log.Fatal(err)
	}
}

func serve(ctx context.Context, svc *service.Service, args []string) error {
	fs := flag.NewFlagSet("serve", flag.ExitOnError)
	listen := fs.String("listen", "127.0.0.1:8080", "TCP address for gRPC-Web, gRPC and the web app")
	socket := fs.String("socket", "", "listen on this Unix socket instead")
	web := fs.String("web", "", "Flutter web build to serve at /")
	password := fs.String("password", os.Getenv("GITHEFT_PASSWORD"), "require this password (HTTP basic auth); default $GITHEFT_PASSWORD")
	syncEvery := fs.Duration("sync-every", 0, "sync the notebooks with automatic sync this often, e.g. 15m (0: only when the app asks)")
	fs.Parse(args)
	if *syncEvery > 0 {
		go func() {
			t := time.NewTicker(*syncEvery)
			defer t.Stop()
			for {
				select {
				case <-ctx.Done():
					return
				case <-t.C:
					if _, err := svc.SyncAll(ctx, connect.NewRequest(&v1.SyncAllRequest{})); err != nil {
						log.Printf("background sync: %v", err)
					}
				}
			}
		}()
	}

	var l net.Listener
	var err error
	if *socket != "" {
		l, err = server.ListenUnix(*socket)
	} else {
		if *password == "" {
			if host, _, _ := net.SplitHostPort(*listen); host != "127.0.0.1" && host != "localhost" && host != "::1" {
				log.Printf("warning: serving %s without a password; anyone who reaches it can read and change the notes", *listen)
			}
		}
		l, err = net.Listen("tcp", *listen)
		log.Printf("listening on http://%s", *listen)
	}
	if err != nil {
		return err
	}
	return server.Serve(ctx, l, server.Handler(svc, server.Options{WebDir: *web, Password: *password}))
}

func list(ctx context.Context, svc *service.Service) error {
	res, err := svc.ListNotebooks(ctx, connect.NewRequest(&v1.ListNotebooksRequest{}))
	if err != nil {
		return err
	}
	for _, nb := range res.Msg.Notebooks {
		remote := "local only"
		if nb.Remote != nil {
			remote = nb.Remote.Url
		}
		fmt.Printf("%s\t%s\t%s\t%s\n", nb.Id, nb.Name, nb.Path, remote)
	}
	return nil
}

func syncNotebooks(ctx context.Context, svc *service.Service, args []string) error {
	fs := flag.NewFlagSet("sync", flag.ExitOnError)
	auto := fs.Bool("auto", false, "only notebooks with automatic sync (for the background timer)")
	fs.Parse(args)
	names := fs.Args()
	res, err := svc.ListNotebooks(ctx, connect.NewRequest(&v1.ListNotebooksRequest{}))
	if err != nil {
		return err
	}
	want := map[string]bool{}
	for _, n := range names {
		want[n] = true
	}
	failed := false
	for _, nb := range res.Msg.Notebooks {
		if len(want) > 0 && !want[nb.Id] && !want[nb.Name] {
			continue
		}
		if *auto && (!nb.AutoSync || nb.Remote == nil) {
			continue
		}
		st, err := svc.Sync(ctx, connect.NewRequest(&v1.SyncRequest{NotebookId: nb.Id}))
		switch {
		case err != nil:
			fmt.Printf("%s: %v\n", nb.Name, err)
			failed = true
		case st.Msg.State == v1.SyncState_SYNC_STATE_ERROR:
			fmt.Printf("%s: %s\n", nb.Name, st.Msg.Error)
			failed = true
		default:
			fmt.Printf("%s: synced, %d changed, %d conflicts\n", nb.Name, len(st.Msg.ChangedPaths), len(st.Msg.Conflicts))
		}
	}
	if failed {
		os.Exit(1)
	}
	return nil
}
