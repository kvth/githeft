//go:build unix

package gitsync

import (
	"os"
	"path/filepath"
	"syscall"
)

// fileLock takes .git/githeft.lock, so the app, a background job and the
// githeft command never work on one repository at the same time. Where the
// file system has no locks (some FUSE mounts) it does nothing.
func (r *Repo) fileLock() func() {
	f, err := os.OpenFile(filepath.Join(r.Path, ".git", "githeft.lock"), os.O_CREATE|os.O_RDWR, 0o600)
	if err != nil {
		return func() {}
	}
	if err := syscall.Flock(int(f.Fd()), syscall.LOCK_EX); err != nil {
		f.Close()
		return func() {}
	}
	return func() {
		syscall.Flock(int(f.Fd()), syscall.LOCK_UN)
		f.Close()
	}
}
