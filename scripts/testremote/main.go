// Command testremote is a throwaway git host for trying Githeft: it serves
// bare repositories over HTTP with basic auth and over SSH, using the git
// binary's http-backend, upload-pack and receive-pack. Every SSH key is
// accepted. Not for real use.
//
//	go run ./scripts/testremote -root /tmp/remote -seed
//
// In the emulator the host is 10.0.2.2:
//
//	http://10.0.2.2:8418/notes.git   user test, password secret
//	ssh://git@10.0.2.2:2222/notes.git
package main

import (
	"crypto/ed25519"
	"crypto/rand"
	"encoding/binary"
	"flag"
	"fmt"
	"log"
	"net"
	"net/http"
	"net/http/cgi"
	"os"
	"os/exec"
	"path/filepath"
	"strings"

	"golang.org/x/crypto/ssh"
)

func main() {
	root := flag.String("root", "/tmp/remote", "folder with the bare repositories")
	httpAddr := flag.String("http", ":8418", "HTTP address")
	sshAddr := flag.String("ssh", ":2222", "SSH address")
	user := flag.String("user", "test", "HTTP user name")
	password := flag.String("password", "secret", "HTTP password")
	seed := flag.Bool("seed", false, "create notes.git with a few notes if missing")
	flag.Parse()

	gitBin, err := exec.LookPath("git")
	if err != nil {
		log.Fatal("needs git: ", err)
	}
	if *seed {
		if err := seedRepo(gitBin, filepath.Join(*root, "notes.git")); err != nil {
			log.Fatal(err)
		}
	}

	backend := &cgi.Handler{
		Path: gitBin,
		Args: []string{"http-backend"},
		Env:  []string{"GIT_PROJECT_ROOT=" + *root, "GIT_HTTP_EXPORT_ALL=1", "REMOTE_USER=" + *user},
	}
	go func() {
		log.Printf("HTTP on %s (user %s, password %s)", *httpAddr, *user, *password)
		log.Fatal(http.ListenAndServe(*httpAddr, http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
			u, p, ok := r.BasicAuth()
			if !ok || u != *user || p != *password {
				w.Header().Set("WWW-Authenticate", `Basic realm="testremote"`)
				http.Error(w, "unauthorized", http.StatusUnauthorized)
				return
			}
			log.Printf("http %s %s", r.Method, r.URL)
			backend.ServeHTTP(w, r)
		})))
	}()

	_, hostKey, _ := ed25519.GenerateKey(rand.Reader)
	signer, err := ssh.NewSignerFromKey(hostKey)
	if err != nil {
		log.Fatal(err)
	}
	cfg := &ssh.ServerConfig{
		PublicKeyCallback: func(_ ssh.ConnMetadata, key ssh.PublicKey) (*ssh.Permissions, error) {
			log.Printf("ssh key %s", ssh.FingerprintSHA256(key))
			return nil, nil
		},
	}
	cfg.AddHostKey(signer)
	l, err := net.Listen("tcp", *sshAddr)
	if err != nil {
		log.Fatal(err)
	}
	log.Printf("SSH on %s, host key %s", *sshAddr, ssh.FingerprintSHA256(signer.PublicKey()))
	for {
		conn, err := l.Accept()
		if err != nil {
			log.Fatal(err)
		}
		go serveSSH(conn, cfg, *root)
	}
}

func serveSSH(conn net.Conn, cfg *ssh.ServerConfig, root string) {
	_, chans, reqs, err := ssh.NewServerConn(conn, cfg)
	if err != nil {
		log.Printf("ssh: %v", err)
		return
	}
	go ssh.DiscardRequests(reqs)
	for nc := range chans {
		ch, reqs, err := nc.Accept()
		if err != nil {
			continue
		}
		go func() {
			defer ch.Close()
			for req := range reqs {
				if req.Type != "exec" {
					req.Reply(req.Type == "env", nil)
					continue
				}
				n := binary.BigEndian.Uint32(req.Payload)
				command := string(req.Payload[4 : 4+n])
				verb, repo, _ := strings.Cut(command, " ")
				repo = strings.Trim(repo, `'"`)
				if (verb != "git-upload-pack" && verb != "git-receive-pack") || strings.Contains(repo, "..") {
					req.Reply(false, nil)
					return
				}
				req.Reply(true, nil)
				log.Printf("ssh %s %s", verb, repo)
				cmd := exec.Command(verb, filepath.Join(root, strings.TrimPrefix(repo, "/")))
				cmd.Stdin, cmd.Stdout, cmd.Stderr = ch, ch, ch.Stderr()
				status := uint32(0)
				if err := cmd.Run(); err != nil {
					status = 1
				}
				ch.SendRequest("exit-status", false, binary.BigEndian.AppendUint32(nil, status))
				return
			}
		}()
	}
}

func seedRepo(gitBin, bare string) error {
	if _, err := os.Stat(bare); err == nil {
		return nil
	}
	work, err := os.MkdirTemp("", "seed")
	if err != nil {
		return err
	}
	defer os.RemoveAll(work)
	notes := map[string]string{
		"Welcome.md":         "---\ncreated: 2026-11-20T09:00:00\nmodified: 2026-11-20T09:00:00\ntags: [githeft]\n---\n\n# Welcome\n\nThis notebook came from the test remote.\n\n- [x] clone it\n- [ ] edit it\n- [ ] sync it\n",
		"ideas/Garden.md":    "---\ncreated: 2026-11-21T18:30:00\nmodified: 2026-11-22T08:15:00\n---\n\n# Garden\n\nPlant tulips in October. #garden\n",
		"20261123T071500.md": "Quick note without front matter.\n",
	}
	for name, text := range notes {
		p := filepath.Join(work, name)
		os.MkdirAll(filepath.Dir(p), 0o755)
		if err := os.WriteFile(p, []byte(text), 0o644); err != nil {
			return err
		}
	}
	run := func(dir string, args ...string) error {
		cmd := exec.Command(gitBin, args...)
		cmd.Dir = dir
		cmd.Env = append(os.Environ(), "GIT_AUTHOR_NAME=Seed", "GIT_AUTHOR_EMAIL=seed@test", "GIT_COMMITTER_NAME=Seed", "GIT_COMMITTER_EMAIL=seed@test")
		if out, err := cmd.CombinedOutput(); err != nil {
			return fmt.Errorf("git %v: %v\n%s", args, err, out)
		}
		return nil
	}
	for _, args := range [][]string{
		{"init", "-q", "-b", "main"}, {"add", "."}, {"commit", "-q", "-m", "Seed notes"},
		{"clone", "-q", "--bare", ".", bare},
	} {
		if err := run(work, args...); err != nil {
			return err
		}
	}
	return run(bare, "config", "http.receivepack", "true")
}
