//go:build !unix

package gitsync

func (r *Repo) fileLock() func() { return func() {} }
