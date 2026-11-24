// Package gitsync keeps a notebook's working tree in a git repository and
// syncs it with a remote: commit, fetch, merge, push. Everything runs on
// go-git, so it needs no git binary (there is none on Android).
package gitsync

import (
	"context"
	"errors"
	"fmt"
	"io"
	"os"
	"path"
	"path/filepath"
	"slices"
	"sort"
	"strings"
	"sync"
	"time"

	"github.com/go-git/go-git/v5"
	"github.com/go-git/go-git/v5/config"
	"github.com/go-git/go-git/v5/plumbing"
	"github.com/go-git/go-git/v5/plumbing/object"
	"github.com/go-git/go-git/v5/plumbing/transport"
	"github.com/go-git/go-git/v5/storage/memory"

	"github.com/kvth/githeft/internal/notes"
)

const remoteName = "origin"

// DefaultBranch is the branch of new repositories.
const DefaultBranch = "main"

// Remote is where a repository syncs to.
type Remote struct {
	URL    string
	Branch string // empty: the current branch
	Auth   *Auth
}

// Repo is a git working tree. Its methods are safe for concurrent use; git
// operations on one repository run one at a time.
type Repo struct {
	Path  string
	Hosts *KnownHosts
	repo  *git.Repository
	mu    sync.Mutex
}

// Open opens an existing working tree.
func Open(dir string, hosts *KnownHosts) (*Repo, error) {
	r, err := git.PlainOpen(dir)
	if err != nil {
		return nil, fmt.Errorf("open %s: %w", dir, err)
	}
	return &Repo{Path: dir, Hosts: hosts, repo: r}, nil
}

// Init creates an empty repository.
func Init(dir string, hosts *KnownHosts) (*Repo, error) {
	r, err := git.PlainInitWithOptions(dir, &git.PlainInitOptions{
		InitOptions: git.InitOptions{DefaultBranch: plumbing.NewBranchReferenceName(DefaultBranch)},
	})
	if err != nil {
		return nil, err
	}
	return &Repo{Path: dir, Hosts: hosts, repo: r}, nil
}

// Clone clones remote into dir. An empty remote repository gives an empty
// local one that pushes to it on the first sync.
func Clone(ctx context.Context, dir string, remote Remote, hosts *KnownHosts) (*Repo, error) {
	auth, err := remote.Auth.method(remote.URL, hosts)
	if err != nil {
		return nil, err
	}
	opts := &git.CloneOptions{URL: remote.URL, Auth: auth, RemoteName: remoteName}
	if remote.Branch != "" {
		opts.ReferenceName = plumbing.NewBranchReferenceName(remote.Branch)
	}
	r, err := git.PlainCloneContext(ctx, dir, false, opts)
	if errors.Is(err, plumbing.ErrReferenceNotFound) && remote.Branch == "" {
		// The remote's HEAD names a branch that does not exist; take the
		// branch ListRemote considers the default instead.
		os.RemoveAll(dir)
		_, branch, lerr := ListRemote(ctx, remote, hosts)
		if lerr != nil {
			return nil, lerr
		}
		if branch != "" {
			remote.Branch = branch
			return Clone(ctx, dir, remote, hosts)
		}
	}
	if errors.Is(err, transport.ErrEmptyRemoteRepository) {
		if err := os.RemoveAll(dir); err != nil {
			return nil, err
		}
		repo, err := Init(dir, hosts)
		if err != nil {
			return nil, err
		}
		if remote.Branch != "" && remote.Branch != DefaultBranch {
			head := plumbing.NewSymbolicReference(plumbing.HEAD, plumbing.NewBranchReferenceName(remote.Branch))
			if err := repo.repo.Storer.SetReference(head); err != nil {
				return nil, err
			}
		}
		return repo, repo.SetRemoteURL(remote.URL)
	}
	if err != nil {
		os.RemoveAll(dir)
		return nil, explainAuth(err, remote.Auth)
	}
	return &Repo{Path: dir, Hosts: hosts, repo: r}, nil
}

// ListRemote returns the branches of a remote and its default branch, to
// check URL and credentials.
func ListRemote(ctx context.Context, remote Remote, hosts *KnownHosts) (branches []string, defaultBranch string, err error) {
	auth, err := remote.Auth.method(remote.URL, hosts)
	if err != nil {
		return nil, "", err
	}
	rem := git.NewRemote(memory.NewStorage(), &config.RemoteConfig{Name: remoteName, URLs: []string{remote.URL}})
	refs, err := rem.ListContext(ctx, &git.ListOptions{Auth: auth})
	if errors.Is(err, transport.ErrEmptyRemoteRepository) {
		return nil, "", nil
	}
	if err != nil {
		return nil, "", explainAuth(err, remote.Auth)
	}
	for _, ref := range refs {
		switch {
		case ref.Name() == plumbing.HEAD && ref.Type() == plumbing.SymbolicReference:
			defaultBranch = ref.Target().Short()
		case ref.Name().IsBranch():
			branches = append(branches, ref.Name().Short())
		}
	}
	sort.Strings(branches)
	if !slices.Contains(branches, defaultBranch) {
		defaultBranch = ""
	}
	if defaultBranch == "" && len(branches) > 0 {
		defaultBranch = branches[0]
		for _, b := range branches {
			if b == "main" || b == "master" {
				defaultBranch = b
				break
			}
		}
	}
	return branches, defaultBranch, nil
}

// SetRemoteURL points origin at url, or removes origin for an empty url.
func (r *Repo) SetRemoteURL(url string) error {
	defer r.lock()()
	if rem, err := r.repo.Remote(remoteName); err == nil {
		if url != "" && len(rem.Config().URLs) == 1 && rem.Config().URLs[0] == url {
			return nil
		}
		if err := r.repo.DeleteRemote(remoteName); err != nil {
			return err
		}
	}
	if url == "" {
		return nil
	}
	_, err := r.repo.CreateRemote(&config.RemoteConfig{
		Name:  remoteName,
		URLs:  []string{url},
		Fetch: []config.RefSpec{config.RefSpec("+refs/heads/*:refs/remotes/" + remoteName + "/*")},
	})
	return err
}

// RemoteURL returns the URL of origin, or "".
func (r *Repo) RemoteURL() string {
	rem, err := r.repo.Remote(remoteName)
	if err != nil || len(rem.Config().URLs) == 0 {
		return ""
	}
	return rem.Config().URLs[0]
}

// Branch returns the branch HEAD points to.
func (r *Repo) Branch() string {
	head, err := r.repo.Reference(plumbing.HEAD, false)
	if err != nil || head.Type() != plumbing.SymbolicReference {
		return DefaultBranch
	}
	return head.Target().Short()
}

// lock serializes git operations on the repository, within the process and
// across processes.
func (r *Repo) lock() (unlock func()) {
	r.mu.Lock()
	release := r.fileLock()
	return func() {
		release()
		r.mu.Unlock()
	}
}

// Signature is the author of commits.
type Signature struct{ Name, Email string }

func (s Signature) object() *object.Signature {
	if s.Name == "" {
		s.Name = "Githeft"
	}
	if s.Email == "" {
		s.Email = "githeft@localhost"
	}
	return &object.Signature{Name: s.Name, Email: s.Email, When: time.Now()}
}

// Commit stages paths (relative, with forward slashes; deleted files are
// removed from the index) and commits them. Nothing staged means no commit.
func (r *Repo) Commit(msg string, author Signature, paths ...string) error {
	defer r.lock()()
	wt, err := r.repo.Worktree()
	if err != nil {
		return err
	}
	for _, p := range paths {
		if _, err := os.Lstat(filepath.Join(r.Path, filepath.FromSlash(p))); errors.Is(err, os.ErrNotExist) {
			if _, err := wt.Remove(p); err != nil && !errors.Is(err, os.ErrNotExist) && !strings.Contains(err.Error(), "entry not found") {
				return fmt.Errorf("unstage %s: %w", p, err)
			}
			continue
		}
		if _, err := wt.Add(p); err != nil {
			return fmt.Errorf("stage %s: %w", p, err)
		}
	}
	return r.commit(wt, msg, author, nil)
}

func (r *Repo) commit(wt *git.Worktree, msg string, author Signature, parents []plumbing.Hash) error {
	sig := author.object()
	_, err := wt.Commit(msg, &git.CommitOptions{Author: sig, Committer: sig, Parents: parents})
	if errors.Is(err, git.ErrEmptyCommit) {
		return nil
	}
	return err
}

// Pending returns the paths with uncommitted changes.
func (r *Repo) Pending() ([]string, error) {
	defer r.lock()()
	return r.pending()
}

func (r *Repo) pending() ([]string, error) {
	wt, err := r.repo.Worktree()
	if err != nil {
		return nil, err
	}
	status, err := wt.Status()
	if err != nil {
		return nil, err
	}
	var paths []string
	for p, s := range status {
		if s.Worktree != git.Unmodified || s.Staging != git.Unmodified {
			paths = append(paths, p)
		}
	}
	sort.Strings(paths)
	return paths, nil
}

// CommitAll commits every change in the working tree, edits made outside
// the app included.
func (r *Repo) CommitAll(msg string, author Signature) (bool, error) {
	defer r.lock()()
	return r.commitAll(msg, author)
}

func (r *Repo) commitAll(msg string, author Signature) (bool, error) {
	paths, err := r.pending()
	if err != nil || len(paths) == 0 {
		return false, err
	}
	wt, err := r.repo.Worktree()
	if err != nil {
		return false, err
	}
	if err := wt.AddWithOptions(&git.AddOptions{All: true}); err != nil {
		return false, err
	}
	if msg == "" {
		msg = fmt.Sprintf("Changes to %s", strings.Join(paths, ", "))
		if len(paths) > 3 {
			msg = fmt.Sprintf("Changes to %d files", len(paths))
		}
	}
	return true, r.commit(wt, msg, author, nil)
}

// Ahead counts local commits that are not on the remote branch yet.
func (r *Repo) Ahead() int {
	defer r.lock()()
	head, err := r.repo.Head()
	if err != nil {
		return 0
	}
	remoteHash := plumbing.ZeroHash
	if ref, err := r.repo.Reference(plumbing.NewRemoteReferenceName(remoteName, r.Branch()), true); err == nil {
		remoteHash = ref.Hash()
	}
	onRemote := map[plumbing.Hash]bool{}
	if !remoteHash.IsZero() {
		if iter, err := r.repo.Log(&git.LogOptions{From: remoteHash}); err == nil {
			n := 0
			iter.ForEach(func(c *object.Commit) error {
				onRemote[c.Hash] = true
				if n++; n > 5000 {
					return io.EOF
				}
				return nil
			})
		}
	}
	iter, err := r.repo.Log(&git.LogOptions{From: head.Hash()})
	if err != nil {
		return 0
	}
	ahead := 0
	iter.ForEach(func(c *object.Commit) error {
		if onRemote[c.Hash] || ahead >= 1000 {
			return io.EOF
		}
		ahead++
		return nil
	})
	return ahead
}

// SyncResult tells what a sync did.
type SyncResult struct {
	// Changed lists files the sync changed in the working tree.
	Changed []string
	// Conflicts lists conflict copies: files both sides changed that could
	// not be merged keep the local version, the remote one is saved next to
	// it under this name.
	Conflicts []string
}

// Sync commits local changes, fetches the remote, merges and pushes.
func (r *Repo) Sync(ctx context.Context, remote Remote, author Signature) (SyncResult, error) {
	defer r.lock()()
	var res SyncResult
	if _, err := r.commitAll("", author); err != nil {
		return res, fmt.Errorf("commit: %w", err)
	}
	auth, err := remote.Auth.method(remote.URL, r.Hosts)
	if err != nil {
		return res, err
	}
	branch := remote.Branch
	if branch == "" {
		branch = r.Branch()
	}
	// A push races with other devices: on rejection fetch and merge again.
	for attempt := 0; ; attempt++ {
		err := r.syncOnce(ctx, auth, remote.Auth, branch, author, &res)
		if attempt < 2 && errors.Is(err, errPushRejected) {
			continue
		}
		return res, err
	}
}

var errPushRejected = errors.New("the remote changed during the sync")

func (r *Repo) syncOnce(ctx context.Context, auth transport.AuthMethod, creds *Auth, branch string, author Signature, res *SyncResult) error {
	err := r.repo.FetchContext(ctx, &git.FetchOptions{
		RemoteName: remoteName,
		Auth:       auth,
		RefSpecs:   []config.RefSpec{config.RefSpec("+refs/heads/*:refs/remotes/" + remoteName + "/*")},
		Force:      true,
	})
	if err != nil && !errors.Is(err, git.NoErrAlreadyUpToDate) && !errors.Is(err, transport.ErrEmptyRemoteRepository) {
		return fmt.Errorf("fetch: %w", explainAuth(err, creds))
	}

	localRef := plumbing.NewBranchReferenceName(branch)
	remoteRef := plumbing.NewRemoteReferenceName(remoteName, branch)
	var local, theirs plumbing.Hash
	if ref, err := r.repo.Reference(localRef, true); err == nil {
		local = ref.Hash()
	}
	if ref, err := r.repo.Reference(remoteRef, true); err == nil {
		theirs = ref.Hash()
	}

	switch {
	case theirs.IsZero() && local.IsZero():
		return nil // both empty
	case theirs.IsZero():
		// The remote does not have the branch yet.
	case local == theirs:
		return nil
	case local.IsZero():
		if err := r.checkout(localRef, theirs); err != nil {
			return err
		}
		res.Changed = append(res.Changed, r.filesOf(theirs)...)
		return nil
	default:
		localCommit, err := r.repo.CommitObject(local)
		if err != nil {
			return err
		}
		remoteCommit, err := r.repo.CommitObject(theirs)
		if err != nil {
			return err
		}
		if ok, _ := localCommit.IsAncestor(remoteCommit); ok {
			changed, err := r.changedFiles(local, theirs)
			if err != nil {
				return err
			}
			if err := r.checkout(localRef, theirs); err != nil {
				return err
			}
			res.Changed = append(res.Changed, changed...)
			return nil
		}
		if ok, _ := remoteCommit.IsAncestor(localCommit); !ok {
			if err := r.merge(localCommit, remoteCommit, branch, author, res); err != nil {
				return fmt.Errorf("merge: %w", err)
			}
		}
	}

	err = r.repo.PushContext(ctx, &git.PushOptions{
		RemoteName: remoteName,
		Auth:       auth,
		RefSpecs:   []config.RefSpec{config.RefSpec(localRef.String() + ":" + localRef.String())},
	})
	switch {
	case err == nil, errors.Is(err, git.NoErrAlreadyUpToDate):
	case strings.Contains(err.Error(), "non-fast-forward"), strings.Contains(err.Error(), "fetch first"),
		strings.Contains(err.Error(), "rejected"):
		return errPushRejected
	default:
		return fmt.Errorf("push: %w", explainAuth(err, creds))
	}
	if ref, err := r.repo.Reference(localRef, true); err == nil {
		r.repo.Storer.SetReference(plumbing.NewHashReference(remoteRef, ref.Hash()))
	}
	return nil
}

// checkout moves branch to hash and makes the working tree match. The tree
// is clean at this point: everything was committed first.
func (r *Repo) checkout(branch plumbing.ReferenceName, hash plumbing.Hash) error {
	if err := r.repo.Storer.SetReference(plumbing.NewHashReference(branch, hash)); err != nil {
		return err
	}
	wt, err := r.repo.Worktree()
	if err != nil {
		return err
	}
	return wt.Reset(&git.ResetOptions{Commit: hash, Mode: git.HardReset})
}

// files maps each path of a commit's tree to its blob.
func (r *Repo) files(hash plumbing.Hash) (map[string]plumbing.Hash, error) {
	out := map[string]plumbing.Hash{}
	if hash.IsZero() {
		return out, nil
	}
	c, err := r.repo.CommitObject(hash)
	if err != nil {
		return nil, err
	}
	tree, err := c.Tree()
	if err != nil {
		return nil, err
	}
	err = tree.Files().ForEach(func(f *object.File) error {
		out[f.Name] = f.Hash
		return nil
	})
	return out, err
}

func (r *Repo) filesOf(hash plumbing.Hash) []string {
	files, _ := r.files(hash)
	var paths []string
	for p := range files {
		paths = append(paths, p)
	}
	sort.Strings(paths)
	return paths
}

func (r *Repo) changedFiles(from, to plumbing.Hash) ([]string, error) {
	a, err := r.files(from)
	if err != nil {
		return nil, err
	}
	b, err := r.files(to)
	if err != nil {
		return nil, err
	}
	var changed []string
	for p, h := range b {
		if a[p] != h {
			changed = append(changed, p)
		}
	}
	for p := range a {
		if _, ok := b[p]; !ok {
			changed = append(changed, p)
		}
	}
	sort.Strings(changed)
	return changed, nil
}

func (r *Repo) blob(hash plumbing.Hash) ([]byte, error) {
	b, err := r.repo.BlobObject(hash)
	if err != nil {
		return nil, err
	}
	rd, err := b.Reader()
	if err != nil {
		return nil, err
	}
	defer rd.Close()
	return io.ReadAll(rd)
}

// merge creates a merge commit of the local and remote branch. Files only
// one side changed take that side. Text files both changed are merged line
// by line; when that fails, or for binary files, the local version stays and
// the remote one becomes a conflict copy. A file deleted on one side and
// changed on the other is kept, so no edit is ever lost.
func (r *Repo) merge(ours, theirs *object.Commit, branch string, author Signature, res *SyncResult) error {
	var baseHash plumbing.Hash
	if bases, err := ours.MergeBase(theirs); err == nil && len(bases) > 0 {
		baseHash = bases[0].Hash
	}
	base, err := r.files(baseHash)
	if err != nil {
		return err
	}
	o, err := r.files(ours.Hash)
	if err != nil {
		return err
	}
	t, err := r.files(theirs.Hash)
	if err != nil {
		return err
	}

	paths := map[string]bool{}
	for p := range t {
		paths[p] = true
	}
	for p := range base {
		paths[p] = true
	}
	stamp := time.Now().Format("20060102-150405")
	for p := range paths {
		bh, th, oh := base[p], t[p], o[p]
		if th == bh || th == oh {
			continue // theirs did not change it, or both made the same change
		}
		switch {
		case oh == bh:
			// Only theirs changed it.
			if th.IsZero() {
				err = r.remove(p)
			} else {
				err = r.writeBlob(p, th)
			}
			res.Changed = append(res.Changed, p)
		case th.IsZero():
			// Theirs deleted what ours changed: keep ours.
		case oh.IsZero():
			// Ours deleted what theirs changed: bring it back.
			err = r.writeBlob(p, th)
			res.Changed = append(res.Changed, p)
		default:
			err = r.mergeFile(p, bh, oh, th, stamp, res)
		}
		if err != nil {
			return fmt.Errorf("%s: %w", p, err)
		}
	}

	wt, err := r.repo.Worktree()
	if err != nil {
		return err
	}
	if err := wt.AddWithOptions(&git.AddOptions{All: true}); err != nil {
		return err
	}
	sig := author.object()
	_, err = wt.Commit("Merge "+remoteName+"/"+branch, &git.CommitOptions{
		Author: sig, Committer: sig, Parents: []plumbing.Hash{ours.Hash, theirs.Hash}, AllowEmptyCommits: true,
	})
	return err
}

func (r *Repo) mergeFile(p string, bh, oh, th plumbing.Hash, stamp string, res *SyncResult) error {
	theirsData, err := r.blob(th)
	if err != nil {
		return err
	}
	oursData, err := r.blob(oh)
	if err != nil {
		return err
	}
	var baseData []byte
	if !bh.IsZero() {
		if baseData, err = r.blob(bh); err != nil {
			return err
		}
	}
	if isText(baseData) && isText(oursData) && isText(theirsData) {
		if merged, ok := notes.Merge(string(baseData), string(oursData), string(theirsData)); ok {
			res.Changed = append(res.Changed, p)
			return r.write(p, []byte(merged))
		}
	}
	ext := path.Ext(p)
	copyPath := strings.TrimSuffix(p, ext) + notes.ConflictMarker + stamp + ext
	res.Conflicts = append(res.Conflicts, copyPath)
	res.Changed = append(res.Changed, copyPath)
	return r.write(copyPath, theirsData)
}

func isText(b []byte) bool {
	n := len(b)
	if n > 8000 {
		n = 8000
	}
	for _, c := range b[:n] {
		if c == 0 {
			return false
		}
	}
	return true
}

func (r *Repo) writeBlob(p string, h plumbing.Hash) error {
	data, err := r.blob(h)
	if err != nil {
		return err
	}
	return r.write(p, data)
}

func (r *Repo) write(p string, data []byte) error {
	full := filepath.Join(r.Path, filepath.FromSlash(p))
	if err := os.MkdirAll(filepath.Dir(full), 0o755); err != nil {
		return err
	}
	return os.WriteFile(full, data, 0o644)
}

func (r *Repo) remove(p string) error {
	err := os.Remove(filepath.Join(r.Path, filepath.FromSlash(p)))
	if errors.Is(err, os.ErrNotExist) {
		return nil
	}
	return err
}

// explainAuth makes go-git's transport errors say what to do, knowing which
// credentials were tried.
func explainAuth(err error, a *Auth) error {
	switch {
	case errors.Is(err, transport.ErrAuthenticationRequired) && a != nil && a.Password != "":
		return fmt.Errorf("%w: the user name or password/token was not accepted", err)
	case errors.Is(err, transport.ErrAuthenticationRequired):
		return fmt.Errorf("%w: the remote needs a user name and password or token", err)
	case errors.Is(err, transport.ErrAuthorizationFailed):
		return fmt.Errorf("%w: check the credentials and that they may write to the repository", err)
	case errors.Is(err, transport.ErrRepositoryNotFound):
		return fmt.Errorf("%w: check the URL, and for private repositories the credentials", err)
	case strings.Contains(err.Error(), "unable to authenticate"):
		return fmt.Errorf("%w: add the public key to the git host (as a deploy key with write access)", err)
	}
	return err
}
