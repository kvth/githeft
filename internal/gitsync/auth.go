package gitsync

import (
	"errors"
	"fmt"
	"net"
	"os"
	"strings"
	"sync"

	"github.com/go-git/go-git/v5/plumbing/transport"
	githttp "github.com/go-git/go-git/v5/plumbing/transport/http"
	gitssh "github.com/go-git/go-git/v5/plumbing/transport/ssh"
	"github.com/skeema/knownhosts"
	"golang.org/x/crypto/ssh"
)

// Auth holds the credentials for a remote.
type Auth struct {
	// SSH: private key in PEM or OpenSSH format and its passphrase.
	SSHKey        []byte
	SSHPassphrase string
	// HTTPS: user name and password or access token.
	Username string
	Password string
}

// KnownHosts remembers SSH host keys the first time a host is seen and
// refuses connections when a host's key changes afterwards.
type KnownHosts struct {
	Path string
	mu   sync.Mutex
}

// ErrHostKeyChanged is returned when a host presents a different key than
// the one remembered for it.
var ErrHostKeyChanged = errors.New("the SSH host key of the server changed")

func (k *KnownHosts) callback() (ssh.HostKeyCallback, error) {
	if _, err := os.Stat(k.Path); errors.Is(err, os.ErrNotExist) {
		if err := os.WriteFile(k.Path, nil, 0o600); err != nil {
			return nil, err
		}
	}
	db, err := knownhosts.NewDB(k.Path)
	if err != nil {
		return nil, err
	}
	check := db.HostKeyCallback()
	return func(hostname string, remote net.Addr, key ssh.PublicKey) error {
		err := check(hostname, remote, key)
		switch {
		case err == nil:
			return nil
		case knownhosts.IsHostKeyChanged(err):
			return fmt.Errorf("%w: %s now presents %s %s; if that is expected, forget the old key in the remote settings",
				ErrHostKeyChanged, hostname, key.Type(), ssh.FingerprintSHA256(key))
		case knownhosts.IsHostUnknown(err):
			k.mu.Lock()
			defer k.mu.Unlock()
			f, ferr := os.OpenFile(k.Path, os.O_APPEND|os.O_WRONLY, 0o600)
			if ferr != nil {
				return ferr
			}
			defer f.Close()
			return knownhosts.WriteKnownHost(f, hostname, remote, key)
		}
		return err
	}, nil
}

func (k *KnownHosts) algorithms(hostWithPort string) []string {
	db, err := knownhosts.NewDB(k.Path)
	if err != nil {
		return nil
	}
	return db.HostKeyAlgorithms(hostWithPort)
}

// Forget drops the remembered keys of host ("example.com" or
// "example.com:2222").
func (k *KnownHosts) Forget(host string) error {
	k.mu.Lock()
	defer k.mu.Unlock()
	data, err := os.ReadFile(k.Path)
	if errors.Is(err, os.ErrNotExist) {
		return nil
	} else if err != nil {
		return err
	}
	want := knownhosts.Normalize(host)
	var keep []string
	for _, line := range strings.Split(string(data), "\n") {
		fields := strings.Fields(line)
		if len(fields) > 0 {
			match := false
			for _, h := range strings.Split(fields[0], ",") {
				if knownhosts.Normalize(h) == want {
					match = true
				}
			}
			if match {
				continue
			}
		}
		keep = append(keep, line)
	}
	return os.WriteFile(k.Path, []byte(strings.Join(keep, "\n")), 0o600)
}

// IsSSH reports whether a clone URL uses SSH: ssh://… or user@host:path.
func IsSSH(url string) bool {
	ep, err := transport.NewEndpoint(url)
	return err == nil && ep.Protocol == "ssh"
}

// method turns Auth into what go-git needs for url.
func (a *Auth) method(url string, hosts *KnownHosts) (transport.AuthMethod, error) {
	if a == nil {
		return nil, nil
	}
	ep, err := transport.NewEndpoint(url)
	if err != nil {
		return nil, fmt.Errorf("invalid remote URL: %w", err)
	}
	switch ep.Protocol {
	case "ssh":
		if len(a.SSHKey) == 0 {
			return nil, errors.New("an SSH URL needs an SSH key")
		}
		user := ep.User
		if user == "" {
			user = "git"
		}
		keys, err := gitssh.NewPublicKeys(user, a.SSHKey, a.SSHPassphrase)
		if err != nil {
			return nil, fmt.Errorf("SSH key: %w", err)
		}
		if keys.HostKeyCallback, err = hosts.callback(); err != nil {
			return nil, err
		}
		port := ep.Port
		if port == 0 {
			port = 22
		}
		keys.HostKeyAlgorithms = hosts.algorithms(net.JoinHostPort(ep.Host, fmt.Sprint(port)))
		return keys, nil
	case "http", "https":
		if a.Password == "" && a.Username == "" {
			return nil, nil
		}
		user := a.Username
		if user == "" {
			// Hosts want some user name with an access token, any works.
			user = "githeft"
		}
		return &githttp.BasicAuth{Username: user, Password: a.Password}, nil
	}
	return nil, nil
}
