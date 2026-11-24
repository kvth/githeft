// Package service implements the Githeft gRPC API on top of the notebooks'
// git repositories.
package service

import (
	"context"
	"crypto/rand"
	"encoding/hex"
	"errors"
	"fmt"
	"log"
	"os"
	"path"
	"path/filepath"
	"strings"
	"sync"
	"time"

	"connectrpc.com/connect"

	v1 "github.com/kvth/githeft/gen/githeft/v1"
	"github.com/kvth/githeft/gen/githeft/v1/githeftv1connect"
	"github.com/kvth/githeft/internal/config"
	"github.com/kvth/githeft/internal/gitsync"
	"github.com/kvth/githeft/internal/keys"
)

// Service keeps the notebooks of one data directory:
//
//	config.json     notebooks and their settings
//	keys/           SSH keys
//	known_hosts     SSH host keys, remembered on first use
//	notebooks/<id>/ working trees of notebooks created in the app
type Service struct {
	githeftv1connect.UnimplementedGitheftHandler

	dataDir string
	keys    keys.Store
	hosts   *gitsync.KnownHosts
	// AllowExistingPaths permits notebooks in folders outside the data
	// directory; off on Android, where the app may only use its own storage.
	AllowExistingPaths bool

	mu    sync.Mutex
	cfg   *config.Config
	books map[string]*book
}

// book is an open notebook.
type book struct {
	repo  *gitsync.Repo
	cache noteCache

	statusMu sync.Mutex
	status   *v1.SyncStatus
}

// New opens the data directory, creating it if needed.
func New(dataDir string) (*Service, error) {
	if err := os.MkdirAll(filepath.Join(dataDir, "notebooks"), 0o700); err != nil {
		return nil, err
	}
	cfg, err := config.Load(filepath.Join(dataDir, "config.json"))
	if err != nil {
		return nil, fmt.Errorf("read config: %w", err)
	}
	return &Service{
		dataDir: dataDir,
		keys:    keys.Store{Dir: filepath.Join(dataDir, "keys")},
		hosts:   &gitsync.KnownHosts{Path: filepath.Join(dataDir, "known_hosts")},
		cfg:     cfg,
		books:   map[string]*book{},
	}, nil
}

func (s *Service) saveConfig() error {
	return s.cfg.Save(filepath.Join(s.dataDir, "config.json"))
}

// notebook returns a copy of a notebook's settings and its open repository.
func (s *Service) notebook(id string) (config.Notebook, *book, error) {
	s.mu.Lock()
	defer s.mu.Unlock()
	nb, ok := s.cfg.Find(id)
	if !ok {
		return config.Notebook{}, nil, connect.NewError(connect.CodeNotFound, fmt.Errorf("no notebook %q", id))
	}
	b := s.books[id]
	if b == nil {
		repo, err := gitsync.Open(nb.Path, s.hosts)
		if err != nil {
			return config.Notebook{}, nil, connect.NewError(connect.CodeFailedPrecondition, err)
		}
		b = &book{repo: repo}
		s.books[id] = b
	}
	return *nb, b, nil
}

func newID() string {
	b := make([]byte, 6)
	rand.Read(b)
	return hex.EncodeToString(b)
}

func ok[T any](m *T) (*connect.Response[T], error) { return connect.NewResponse(m), nil }

func invalid(format string, args ...any) error {
	return connect.NewError(connect.CodeInvalidArgument, fmt.Errorf(format, args...))
}

// gitError classifies errors from talking to a remote.
func gitError(err error) error {
	var ce *connect.Error
	switch {
	case errors.As(err, &ce):
		return err
	case errors.Is(err, context.DeadlineExceeded):
		return connect.NewError(connect.CodeDeadlineExceeded, err)
	case errors.Is(err, gitsync.ErrHostKeyChanged):
		return connect.NewError(connect.CodePermissionDenied, err)
	}
	msg := err.Error()
	for _, s := range []string{"authentication", "authorization", "unable to authenticate", "permission denied"} {
		if strings.Contains(strings.ToLower(msg), s) {
			return connect.NewError(connect.CodePermissionDenied, err)
		}
	}
	return connect.NewError(connect.CodeUnavailable, err)
}

func toProto(nb config.Notebook) *v1.Notebook {
	p := &v1.Notebook{
		Id:            nb.ID,
		Name:          nb.Name,
		Path:          nb.Path,
		Author:        &v1.Author{Name: nb.Author.Name, Email: nb.Author.Email},
		AutoSync:      nb.AutoSync,
		NewNoteName:   v1.NewNoteName_NEW_NOTE_NAME_TITLE,
		DefaultFolder: nb.DefaultFolder,
	}
	if nb.NewNoteName == "datetime" {
		p.NewNoteName = v1.NewNoteName_NEW_NOTE_NAME_DATE_TIME
	}
	if r := nb.Remote; r != nil {
		p.Remote = &v1.Remote{
			Url:            r.URL,
			AuthType:       authFromConfig(r.AuthType),
			SshKeyId:       r.SSHKeyID,
			Username:       r.Username,
			PasswordStored: r.Password != "",
			Branch:         r.Branch,
		}
	}
	return p
}

func authFromConfig(s string) v1.AuthType {
	switch s {
	case "ssh":
		return v1.AuthType_AUTH_TYPE_SSH
	case "https":
		return v1.AuthType_AUTH_TYPE_HTTPS
	}
	return v1.AuthType_AUTH_TYPE_NONE
}

// remoteFromProto validates a remote. stored supplies the password when the
// request leaves it empty.
func remoteFromProto(r *v1.Remote, stored *config.Remote) (*config.Remote, error) {
	if r == nil || strings.TrimSpace(r.Url) == "" {
		return nil, nil
	}
	c := &config.Remote{
		URL:      strings.TrimSpace(r.Url),
		SSHKeyID: r.SshKeyId,
		Username: r.Username,
		Password: r.Password,
		Branch:   strings.TrimSpace(r.Branch),
	}
	isSSH := gitsync.IsSSH(c.URL)
	switch r.AuthType {
	case v1.AuthType_AUTH_TYPE_SSH:
		c.AuthType = "ssh"
	case v1.AuthType_AUTH_TYPE_HTTPS:
		c.AuthType = "https"
	case v1.AuthType_AUTH_TYPE_NONE:
		c.AuthType = "none"
	default:
		c.AuthType = "none"
		if isSSH {
			c.AuthType = "ssh"
		}
	}
	if c.AuthType == "ssh" {
		if !isSSH {
			return nil, invalid("%s is not an SSH URL; SSH URLs look like git@host:user/repo.git", c.URL)
		}
		if c.SSHKeyID == "" {
			return nil, invalid("choose or generate an SSH key")
		}
		c.Username, c.Password = "", ""
	} else {
		if isSSH {
			return nil, invalid("%s is an SSH URL; use SSH authentication or an https:// URL", c.URL)
		}
		c.SSHKeyID = ""
		if c.AuthType == "none" {
			c.Username, c.Password = "", ""
		} else if c.Password == "" && stored != nil && stored.AuthType == "https" {
			c.Password = stored.Password
		}
	}
	return c, nil
}

// remote turns stored remote settings into what gitsync needs.
func (s *Service) remote(r *config.Remote) (gitsync.Remote, error) {
	if r == nil {
		return gitsync.Remote{}, nil
	}
	out := gitsync.Remote{URL: r.URL, Branch: r.Branch, Auth: &gitsync.Auth{}}
	switch r.AuthType {
	case "ssh":
		key, pass, err := s.keys.Private(r.SSHKeyID)
		if err != nil {
			return out, connect.NewError(connect.CodeFailedPrecondition, err)
		}
		out.Auth.SSHKey, out.Auth.SSHPassphrase = key, pass
	case "https":
		out.Auth.Username, out.Auth.Password = r.Username, r.Password
	}
	return out, nil
}

func (s *Service) ListNotebooks(ctx context.Context, req *connect.Request[v1.ListNotebooksRequest]) (*connect.Response[v1.ListNotebooksResponse], error) {
	s.mu.Lock()
	defer s.mu.Unlock()
	res := &v1.ListNotebooksResponse{}
	for _, nb := range s.cfg.Notebooks {
		res.Notebooks = append(res.Notebooks, toProto(nb))
	}
	return ok(res)
}

func (s *Service) CreateNotebook(ctx context.Context, req *connect.Request[v1.CreateNotebookRequest]) (*connect.Response[v1.Notebook], error) {
	m := req.Msg
	nb := config.Notebook{
		ID:          newID(),
		Name:        strings.TrimSpace(m.Name),
		AutoSync:    true,
		NewNoteName: "title",
	}
	if a := m.Author; a != nil {
		nb.Author = config.Author{Name: strings.TrimSpace(a.Name), Email: strings.TrimSpace(a.Email)}
	}
	var repo *gitsync.Repo
	switch src := m.Source.(type) {
	case *v1.CreateNotebookRequest_Empty:
		r, err := remoteFromProto(m.Remote, nil)
		if err != nil {
			return nil, err
		}
		nb.Remote = r
		if nb.Path, nb.Managed, err = s.workTree(nb.ID, m.TargetPath); err != nil {
			return nil, err
		}
		if repo, err = gitsync.Init(nb.Path, s.hosts); err != nil {
			return nil, err
		}
		if r != nil {
			if err := repo.SetRemoteURL(r.URL); err != nil {
				return nil, err
			}
		}
	case *v1.CreateNotebookRequest_CloneRemote:
		r, err := remoteFromProto(src.CloneRemote, nil)
		if err != nil {
			return nil, err
		}
		if r == nil {
			return nil, invalid("enter the clone URL")
		}
		rem, err := s.remote(r)
		if err != nil {
			return nil, err
		}
		nb.Remote = r
		if nb.Path, nb.Managed, err = s.workTree(nb.ID, m.TargetPath); err != nil {
			return nil, err
		}
		ctx, cancel := context.WithTimeout(ctx, 10*time.Minute)
		defer cancel()
		if repo, err = gitsync.Clone(ctx, nb.Path, rem, s.hosts); err != nil {
			return nil, gitError(err)
		}
		if nb.Name == "" {
			nb.Name = strings.TrimSuffix(path.Base(strings.TrimRight(strings.ReplaceAll(r.URL, ":", "/"), "/")), ".git")
		}
	case *v1.CreateNotebookRequest_ExistingPath:
		if !s.AllowExistingPaths {
			return nil, connect.NewError(connect.CodePermissionDenied, errors.New("only notebooks in the app's storage are supported here"))
		}
		dir, err := filepath.Abs(src.ExistingPath)
		if err != nil {
			return nil, invalid("%v", err)
		}
		if repo, err = gitsync.Open(dir, s.hosts); err != nil {
			return nil, invalid("%s is not a git repository", dir)
		}
		nb.Path = dir
		if url := repo.RemoteURL(); url != "" {
			auth := "none"
			if gitsync.IsSSH(url) {
				// The key still has to be chosen in the settings.
				auth = "ssh"
			}
			nb.Remote = &config.Remote{URL: url, AuthType: auth}
		}
		if nb.Name == "" {
			nb.Name = filepath.Base(dir)
		}
	default:
		return nil, invalid("say where the notebook comes from")
	}
	if nb.Name == "" {
		nb.Name = "Notebook"
	}

	s.mu.Lock()
	defer s.mu.Unlock()
	s.cfg.Notebooks = append(s.cfg.Notebooks, nb)
	if err := s.saveConfig(); err != nil {
		return nil, err
	}
	s.books[nb.ID] = &book{repo: repo}
	log.Printf("notebook %s (%s) created at %s", nb.ID, nb.Name, nb.Path)
	return ok(toProto(nb))
}

// workTree picks the folder of a new notebook: the app's storage, or target
// if given and allowed. A target must not exist yet or be an empty folder.
func (s *Service) workTree(id, target string) (dir string, managed bool, err error) {
	if strings.TrimSpace(target) == "" {
		return filepath.Join(s.dataDir, "notebooks", id), true, nil
	}
	if !s.AllowExistingPaths {
		return "", false, connect.NewError(connect.CodePermissionDenied, errors.New("only notebooks in the app's storage are supported here"))
	}
	dir, err = filepath.Abs(strings.TrimSpace(target))
	if err != nil {
		return "", false, invalid("%v", err)
	}
	entries, err := os.ReadDir(dir)
	switch {
	case errors.Is(err, os.ErrNotExist):
	case err != nil:
		return "", false, connect.NewError(connect.CodePermissionDenied, fmt.Errorf("cannot use %s: %w", dir, err))
	case len(entries) > 0:
		return "", false, connect.NewError(connect.CodeAlreadyExists, fmt.Errorf("%s is not empty; open it as an existing folder instead", dir))
	}
	if err := os.MkdirAll(filepath.Dir(dir), 0o755); err != nil {
		return "", false, connect.NewError(connect.CodePermissionDenied, fmt.Errorf("cannot create %s: %w", dir, err))
	}
	return dir, false, nil
}

func (s *Service) UpdateNotebook(ctx context.Context, req *connect.Request[v1.UpdateNotebookRequest]) (*connect.Response[v1.Notebook], error) {
	p := req.Msg.Notebook
	if p == nil {
		return nil, invalid("no notebook")
	}
	_, b, err := s.notebook(p.Id)
	if err != nil {
		return nil, err
	}
	s.mu.Lock()
	defer s.mu.Unlock()
	nb, _ := s.cfg.Find(p.Id)
	remote, err := remoteFromProto(p.Remote, nb.Remote)
	if err != nil {
		return nil, err
	}
	url := ""
	if remote != nil {
		url = remote.URL
	}
	if err := b.repo.SetRemoteURL(url); err != nil {
		return nil, err
	}
	nb.Remote = remote
	if name := strings.TrimSpace(p.Name); name != "" {
		nb.Name = name
	}
	if a := p.Author; a != nil {
		nb.Author = config.Author{Name: strings.TrimSpace(a.Name), Email: strings.TrimSpace(a.Email)}
	}
	nb.AutoSync = p.AutoSync
	nb.NewNoteName = "title"
	if p.NewNoteName == v1.NewNoteName_NEW_NOTE_NAME_DATE_TIME {
		nb.NewNoteName = "datetime"
	}
	folder, err := cleanPath(p.DefaultFolder, true)
	if err != nil {
		return nil, err
	}
	nb.DefaultFolder = folder
	if err := s.saveConfig(); err != nil {
		return nil, err
	}
	return ok(toProto(*nb))
}

func (s *Service) DeleteNotebook(ctx context.Context, req *connect.Request[v1.DeleteNotebookRequest]) (*connect.Response[v1.DeleteNotebookResponse], error) {
	s.mu.Lock()
	defer s.mu.Unlock()
	for i, nb := range s.cfg.Notebooks {
		if nb.ID != req.Msg.Id {
			continue
		}
		s.cfg.Notebooks = append(s.cfg.Notebooks[:i], s.cfg.Notebooks[i+1:]...)
		if err := s.saveConfig(); err != nil {
			return nil, err
		}
		delete(s.books, nb.ID)
		if req.Msg.DeleteFiles && nb.Managed && strings.HasPrefix(nb.Path, filepath.Join(s.dataDir, "notebooks")+string(filepath.Separator)) {
			if err := os.RemoveAll(nb.Path); err != nil {
				return nil, err
			}
		}
		return ok(&v1.DeleteNotebookResponse{})
	}
	return nil, connect.NewError(connect.CodeNotFound, fmt.Errorf("no notebook %q", req.Msg.Id))
}

func keyToProto(k keys.Key) *v1.SshKey {
	t := v1.SshKeyType_SSH_KEY_TYPE_ED25519
	if k.Type == "ssh-rsa" {
		t = v1.SshKeyType_SSH_KEY_TYPE_RSA
	}
	return &v1.SshKey{Id: k.ID, Type: t, PublicKey: k.PublicKey, Fingerprint: k.Fingerprint}
}

func (s *Service) GenerateSshKey(ctx context.Context, req *connect.Request[v1.GenerateSshKeyRequest]) (*connect.Response[v1.SshKey], error) {
	kind := "ed25519"
	if req.Msg.Type == v1.SshKeyType_SSH_KEY_TYPE_RSA {
		kind = "rsa"
	}
	comment := req.Msg.Comment
	if comment == "" {
		comment = "githeft"
	}
	k, err := s.keys.Generate(kind, comment)
	if err != nil {
		return nil, err
	}
	return ok(keyToProto(k))
}

func (s *Service) ImportSshKey(ctx context.Context, req *connect.Request[v1.ImportSshKeyRequest]) (*connect.Response[v1.SshKey], error) {
	k, err := s.keys.Import(req.Msg.PrivateKey, req.Msg.Passphrase)
	if err != nil {
		return nil, invalid("%v", err)
	}
	return ok(keyToProto(k))
}

func (s *Service) GetSshKey(ctx context.Context, req *connect.Request[v1.GetSshKeyRequest]) (*connect.Response[v1.SshKey], error) {
	k, err := s.keys.Get(req.Msg.Id)
	if err != nil {
		return nil, connect.NewError(connect.CodeNotFound, err)
	}
	return ok(keyToProto(k))
}

func (s *Service) TestRemote(ctx context.Context, req *connect.Request[v1.TestRemoteRequest]) (*connect.Response[v1.TestRemoteResponse], error) {
	var stored *config.Remote
	if id := req.Msg.NotebookId; id != "" {
		if nb, _, err := s.notebook(id); err == nil {
			stored = nb.Remote
		}
	}
	r, err := remoteFromProto(req.Msg.Remote, stored)
	if err != nil {
		return nil, err
	}
	if r == nil {
		return nil, invalid("enter the clone URL")
	}
	rem, err := s.remote(r)
	if err != nil {
		return nil, err
	}
	ctx, cancel := context.WithTimeout(ctx, time.Minute)
	defer cancel()
	branches, def, err := gitsync.ListRemote(ctx, rem, s.hosts)
	if err != nil {
		return nil, gitError(err)
	}
	return ok(&v1.TestRemoteResponse{Branches: branches, DefaultBranch: def})
}

func (s *Service) ForgetHostKey(ctx context.Context, req *connect.Request[v1.ForgetHostKeyRequest]) (*connect.Response[v1.ForgetHostKeyResponse], error) {
	host := strings.TrimSpace(req.Msg.Host)
	if host == "" {
		return nil, invalid("no host")
	}
	if err := s.hosts.Forget(host); err != nil {
		return nil, err
	}
	return ok(&v1.ForgetHostKeyResponse{})
}
