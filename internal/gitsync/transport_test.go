package gitsync

import (
	"context"
	"crypto/ed25519"
	"crypto/rand"
	"encoding/binary"
	"encoding/pem"
	"errors"
	"net"
	"net/http"
	"net/http/cgi"
	"net/http/httptest"
	"os"
	"os/exec"
	"path/filepath"
	"strings"
	"testing"

	"github.com/go-git/go-git/v5"
	"golang.org/x/crypto/ssh"
)

func needGit(t *testing.T) string {
	git, err := exec.LookPath("git")
	if err != nil {
		t.Skip("needs the git binary for the server side")
	}
	return git
}

// sshServer serves git-upload-pack and git-receive-pack over SSH to clients
// with the given key, like a git host does.
func sshServer(t *testing.T, hostKey ssh.Signer, client ssh.PublicKey) string {
	t.Helper()
	cfg := &ssh.ServerConfig{
		PublicKeyCallback: func(_ ssh.ConnMetadata, key ssh.PublicKey) (*ssh.Permissions, error) {
			if string(key.Marshal()) == string(client.Marshal()) {
				return nil, nil
			}
			return nil, errors.New("unknown key")
		},
	}
	cfg.AddHostKey(hostKey)
	l, err := net.Listen("tcp", "127.0.0.1:0")
	if err != nil {
		t.Fatal(err)
	}
	t.Cleanup(func() { l.Close() })
	go func() {
		for {
			conn, err := l.Accept()
			if err != nil {
				return
			}
			go serveSSH(conn, cfg)
		}
	}()
	return l.Addr().String()
}

func serveSSH(conn net.Conn, cfg *ssh.ServerConfig) {
	_, chans, reqs, err := ssh.NewServerConn(conn, cfg)
	if err != nil {
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
				if !strings.HasPrefix(command, "git-upload-pack ") && !strings.HasPrefix(command, "git-receive-pack ") {
					req.Reply(false, nil)
					return
				}
				req.Reply(true, nil)
				cmd := exec.Command("sh", "-c", command)
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

func newSigner(t *testing.T) (ssh.Signer, []byte) {
	_, priv, _ := ed25519.GenerateKey(rand.Reader)
	block, err := ssh.MarshalPrivateKey(priv, "test")
	if err != nil {
		t.Fatal(err)
	}
	signer, err := ssh.NewSignerFromKey(priv)
	if err != nil {
		t.Fatal(err)
	}
	return signer, pem.EncodeToMemory(block)
}

func TestSSHRemote(t *testing.T) {
	needGit(t)
	dir := t.TempDir()
	bare := filepath.Join(dir, "remote.git")
	if _, err := git.PlainInit(bare, true); err != nil {
		t.Fatal(err)
	}
	clientKey, clientPEM := newSigner(t)
	hostKey, _ := newSigner(t)
	addr := sshServer(t, hostKey, clientKey.PublicKey())
	hosts := &KnownHosts{Path: filepath.Join(dir, "known_hosts")}
	rem := Remote{URL: "ssh://git@" + addr + bare, Auth: &Auth{SSHKey: clientPEM}}
	ctx := context.Background()

	// First contact: the host key is remembered.
	repo, err := Clone(ctx, filepath.Join(dir, "a"), rem, hosts)
	if err != nil {
		t.Fatalf("clone over SSH: %v", err)
	}
	if data, _ := os.ReadFile(hosts.Path); !strings.Contains(string(data), "ssh-ed25519") {
		t.Fatalf("host key not remembered: %q", data)
	}
	os.WriteFile(filepath.Join(dir, "a", "n.md"), []byte("hi\n"), 0o644)
	if _, err := repo.Sync(ctx, rem, Signature{}); err != nil {
		t.Fatalf("push over SSH: %v", err)
	}
	if _, err := Clone(ctx, filepath.Join(dir, "b"), rem, hosts); err != nil {
		t.Fatalf("second clone: %v", err)
	}
	if data, _ := os.ReadFile(filepath.Join(dir, "b", "n.md")); string(data) != "hi\n" {
		t.Errorf("pushed note missing: %q", data)
	}

	// A wrong key is refused with a hint.
	_, otherPEM := newSigner(t)
	_, _, err = ListRemote(ctx, Remote{URL: rem.URL, Auth: &Auth{SSHKey: otherPEM}}, hosts)
	if err == nil || !strings.Contains(err.Error(), "deploy key") {
		t.Errorf("wrong key: %v", err)
	}

	// The server changes its host key: refuse until the old one is forgotten.
	newHost, _ := newSigner(t)
	addr2 := sshServer(t, newHost, clientKey.PublicKey())
	hostsCopy := filepath.Join(dir, "known_hosts2")
	data, _ := os.ReadFile(hosts.Path)
	_, port1, _ := net.SplitHostPort(addr)
	_, port2, _ := net.SplitHostPort(addr2)
	os.WriteFile(hostsCopy, []byte(strings.ReplaceAll(string(data), "]:"+port1, "]:"+port2)), 0o600)
	hosts2 := &KnownHosts{Path: hostsCopy}
	rem2 := Remote{URL: "ssh://git@" + addr2 + bare, Auth: rem.Auth}
	if _, _, err := ListRemote(ctx, rem2, hosts2); !errors.Is(err, ErrHostKeyChanged) {
		t.Fatalf("changed host key accepted: %v", err)
	}
	if err := hosts2.Forget(addr2); err != nil {
		t.Fatal(err)
	}
	if _, _, err := ListRemote(ctx, rem2, hosts2); err != nil {
		t.Errorf("after forgetting: %v", err)
	}
}

func TestHTTPRemoteWithPassword(t *testing.T) {
	gitBin := needGit(t)
	dir := t.TempDir()
	bare := filepath.Join(dir, "remote.git")
	if _, err := git.PlainInit(bare, true); err != nil {
		t.Fatal(err)
	}
	exec.Command(gitBin, "-C", bare, "config", "http.receivepack", "true").Run()
	backend := &cgi.Handler{
		Path: gitBin,
		Args: []string{"http-backend"},
		Env:  []string{"GIT_PROJECT_ROOT=" + dir, "GIT_HTTP_EXPORT_ALL=1", "REMOTE_USER=test"},
	}
	srv := httptest.NewServer(http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
		if u, p, ok := r.BasicAuth(); !ok || u != "githeft" || p != "token123" {
			w.Header().Set("WWW-Authenticate", `Basic realm="git"`)
			http.Error(w, "unauthorized", http.StatusUnauthorized)
			return
		}
		backend.ServeHTTP(w, r)
	}))
	defer srv.Close()
	hosts := &KnownHosts{Path: filepath.Join(dir, "known_hosts")}
	ctx := context.Background()
	url := srv.URL + "/remote.git"

	if _, _, err := ListRemote(ctx, Remote{URL: url}, hosts); err == nil || !strings.Contains(err.Error(), "password or token") {
		t.Errorf("without credentials: %v", err)
	}
	if _, _, err := ListRemote(ctx, Remote{URL: url, Auth: &Auth{Password: "wrong"}}, hosts); err == nil || !strings.Contains(err.Error(), "not accepted") {
		t.Errorf("wrong token: %v", err)
	}
	// No user name: a token alone works, as with GitHub.
	rem := Remote{URL: url, Auth: &Auth{Password: "token123"}}
	repo, err := Clone(ctx, filepath.Join(dir, "a"), rem, hosts)
	if err != nil {
		t.Fatalf("clone over HTTP: %v", err)
	}
	os.WriteFile(filepath.Join(dir, "a", "n.md"), []byte("hi\n"), 0o644)
	if _, err := repo.Sync(ctx, rem, Signature{}); err != nil {
		t.Fatalf("push over HTTP: %v", err)
	}
	branches, def, err := ListRemote(ctx, rem, hosts)
	if err != nil || def != "main" || strings.Join(branches, ",") != "main" {
		t.Errorf("list: %v %q %v", branches, def, err)
	}
}
