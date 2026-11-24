// Package keys creates and stores the SSH keys notebooks authenticate with.
package keys

import (
	"crypto/ed25519"
	"crypto/rand"
	"crypto/rsa"
	"encoding/hex"
	"encoding/pem"
	"errors"
	"fmt"
	"os"
	"path/filepath"
	"regexp"
	"strings"

	"golang.org/x/crypto/ssh"
)

// Store keeps keys as files in a directory: <id>.key (private key),
// <id>.pub and, for imported keys that have one, <id>.passphrase.
type Store struct{ Dir string }

// Key is a stored key pair.
type Key struct {
	ID          string
	Type        string // ssh-ed25519, ssh-rsa, …
	PublicKey   string // authorized_keys line
	Fingerprint string
}

var validID = regexp.MustCompile(`^[a-f0-9]{16}$`)

// Generate creates a new key: "ed25519" (default) or "rsa" (4096 bits, for
// hosts that still lack ed25519 support).
func (s Store) Generate(kind, comment string) (Key, error) {
	var priv any
	switch kind {
	case "", "ed25519":
		_, k, err := ed25519.GenerateKey(rand.Reader)
		if err != nil {
			return Key{}, err
		}
		priv = k
	case "rsa":
		k, err := rsa.GenerateKey(rand.Reader, 4096)
		if err != nil {
			return Key{}, err
		}
		priv = k
	default:
		return Key{}, fmt.Errorf("unknown key type %q", kind)
	}
	block, err := ssh.MarshalPrivateKey(priv, comment)
	if err != nil {
		return Key{}, err
	}
	return s.save(pem.EncodeToMemory(block), "", comment)
}

// Import stores an existing private key after checking that it opens with
// the passphrase.
func (s Store) Import(privateKey, passphrase string) (Key, error) {
	data := []byte(strings.TrimSpace(privateKey) + "\n")
	if _, err := parse(data, passphrase); err != nil {
		return Key{}, err
	}
	return s.save(data, passphrase, "")
}

func parse(data []byte, passphrase string) (ssh.Signer, error) {
	signer, err := ssh.ParsePrivateKey(data)
	var missing *ssh.PassphraseMissingError
	if errors.As(err, &missing) {
		if passphrase == "" {
			return nil, errors.New("the key is encrypted: enter its passphrase")
		}
		signer, err = ssh.ParsePrivateKeyWithPassphrase(data, []byte(passphrase))
	}
	if err != nil {
		return nil, fmt.Errorf("not a usable private key: %w", err)
	}
	return signer, nil
}

func (s Store) save(private []byte, passphrase, comment string) (Key, error) {
	signer, err := parse(private, passphrase)
	if err != nil {
		return Key{}, err
	}
	id := make([]byte, 8)
	rand.Read(id)
	k := describe(hex.EncodeToString(id), signer.PublicKey(), comment)
	if err := os.MkdirAll(s.Dir, 0o700); err != nil {
		return Key{}, err
	}
	if err := os.WriteFile(s.path(k.ID, ".key"), private, 0o600); err != nil {
		return Key{}, err
	}
	if err := os.WriteFile(s.path(k.ID, ".pub"), []byte(k.PublicKey+"\n"), 0o644); err != nil {
		return Key{}, err
	}
	if passphrase != "" {
		if err := os.WriteFile(s.path(k.ID, ".passphrase"), []byte(passphrase), 0o600); err != nil {
			return Key{}, err
		}
	}
	return k, nil
}

func describe(id string, pub ssh.PublicKey, comment string) Key {
	line := strings.TrimSpace(string(ssh.MarshalAuthorizedKey(pub)))
	if comment != "" {
		line += " " + comment
	}
	return Key{ID: id, Type: pub.Type(), PublicKey: line, Fingerprint: ssh.FingerprintSHA256(pub)}
}

func (s Store) path(id, ext string) string { return filepath.Join(s.Dir, id+ext) }

// Get returns a stored key.
func (s Store) Get(id string) (Key, error) {
	if !validID.MatchString(id) {
		return Key{}, fmt.Errorf("no SSH key %q", id)
	}
	data, err := os.ReadFile(s.path(id, ".pub"))
	if err != nil {
		return Key{}, fmt.Errorf("no SSH key %q", id)
	}
	pub, comment, _, _, err := ssh.ParseAuthorizedKey(data)
	if err != nil {
		return Key{}, err
	}
	return describe(id, pub, comment), nil
}

// Private returns the private key and its passphrase for go-git.
func (s Store) Private(id string) ([]byte, string, error) {
	if !validID.MatchString(id) {
		return nil, "", fmt.Errorf("no SSH key %q", id)
	}
	data, err := os.ReadFile(s.path(id, ".key"))
	if err != nil {
		return nil, "", fmt.Errorf("no SSH key %q", id)
	}
	pass, _ := os.ReadFile(s.path(id, ".passphrase"))
	return data, string(pass), nil
}
