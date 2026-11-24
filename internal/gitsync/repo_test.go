package gitsync

import (
	"context"
	"os"
	"path/filepath"
	"strings"
	"testing"

	"github.com/go-git/go-git/v5"
)

type device struct {
	t    *testing.T
	repo *Repo
	rem  Remote
}

func (d *device) write(name, text string) {
	d.t.Helper()
	full := filepath.Join(d.repo.Path, name)
	os.MkdirAll(filepath.Dir(full), 0o755)
	if err := os.WriteFile(full, []byte(text), 0o644); err != nil {
		d.t.Fatal(err)
	}
}

func (d *device) read(name string) string {
	d.t.Helper()
	data, err := os.ReadFile(filepath.Join(d.repo.Path, name))
	if err != nil {
		return "<" + err.Error() + ">"
	}
	return string(data)
}

func (d *device) sync() SyncResult {
	d.t.Helper()
	res, err := d.repo.Sync(context.Background(), d.rem, Signature{Name: "Test"})
	if err != nil {
		d.t.Fatalf("sync %s: %v", d.repo.Path, err)
	}
	return res
}

func setup(t *testing.T) (a, b *device) {
	dir := t.TempDir()
	bare := filepath.Join(dir, "remote.git")
	if _, err := git.PlainInit(bare, true); err != nil {
		t.Fatal(err)
	}
	hosts := &KnownHosts{Path: filepath.Join(dir, "known_hosts")}
	rem := Remote{URL: "file://" + bare}
	clone := func(name string) *device {
		r, err := Clone(context.Background(), filepath.Join(dir, name), rem, hosts)
		if err != nil {
			t.Fatalf("clone %s: %v", name, err)
		}
		return &device{t: t, repo: r, rem: rem}
	}
	a = clone("a")
	a.write("note.md", "---\nmodified: 2026-01-01T10:00:00\n---\n\nline 1\nline 2\nline 3\nline 4\n")
	a.write("other.md", "other\n")
	if err := a.repo.Commit("Added notes", Signature{}, "note.md", "other.md"); err != nil {
		t.Fatal(err)
	}
	a.sync()
	b = clone("b")
	if got := b.read("note.md"); !strings.Contains(got, "line 4") {
		t.Fatalf("clone did not get the note: %q", got)
	}
	return a, b
}

func TestSyncMergesEditsOfDifferentLines(t *testing.T) {
	a, b := setup(t)
	a.write("note.md", "---\nmodified: 2026-01-02T10:00:00\n---\n\nline 1 from a\nline 2\nline 3\nline 4\n")
	b.write("note.md", "---\nmodified: 2026-01-03T10:00:00\n---\n\nline 1\nline 2\nline 3\nline 4 from b\n")
	a.sync()
	res := b.sync()
	if len(res.Conflicts) != 0 {
		t.Fatalf("conflicts %v", res.Conflicts)
	}
	a.sync()
	want := "---\nmodified: 2026-01-03T10:00:00\n---\n\nline 1 from a\nline 2\nline 3\nline 4 from b\n"
	if got := a.read("note.md"); got != want {
		t.Errorf("a has\n%s", got)
	}
	if got := b.read("note.md"); got != want {
		t.Errorf("b has\n%s", got)
	}
	if a.repo.Ahead() != 0 || b.repo.Ahead() != 0 {
		t.Errorf("not everything pushed")
	}
}

func TestSyncConflictKeepsBothVersions(t *testing.T) {
	a, b := setup(t)
	a.write("note.md", "line 2 from a\n")
	b.write("note.md", "line 2 from b\n")
	a.sync()
	res := b.sync()
	if len(res.Conflicts) != 1 || !strings.HasPrefix(res.Conflicts[0], "note.conflict-") {
		t.Fatalf("conflicts %v", res.Conflicts)
	}
	if got := b.read("note.md"); got != "line 2 from b\n" {
		t.Errorf("local version lost: %q", got)
	}
	if got := b.read(res.Conflicts[0]); got != "line 2 from a\n" {
		t.Errorf("remote version lost: %q", got)
	}
	a.sync()
	if got := a.read(res.Conflicts[0]); got != "line 2 from a\n" {
		t.Errorf("conflict copy not synced: %q", got)
	}
}

func TestSyncDeleteAgainstEditKeepsEdit(t *testing.T) {
	a, b := setup(t)
	os.Remove(filepath.Join(a.repo.Path, "other.md"))
	a.write("new.md", "new\n")
	b.write("other.md", "other edited\n")
	a.sync()
	b.sync()
	a.sync()
	for _, d := range []*device{a, b} {
		if got := d.read("other.md"); got != "other edited\n" {
			t.Errorf("%s: other.md %q", d.repo.Path, got)
		}
		if got := d.read("new.md"); got != "new\n" {
			t.Errorf("%s: new.md %q", d.repo.Path, got)
		}
	}
}

func TestSyncFastForwardAndDelete(t *testing.T) {
	a, b := setup(t)
	os.Remove(filepath.Join(a.repo.Path, "other.md"))
	a.sync()
	res := b.sync()
	if strings.Join(res.Changed, ",") != "other.md" {
		t.Errorf("changed %v", res.Changed)
	}
	if got := b.read("other.md"); !strings.HasPrefix(got, "<") {
		t.Errorf("other.md still there: %q", got)
	}
}

func TestPendingAndCommitAll(t *testing.T) {
	a, _ := setup(t)
	a.write("dir/x.md", "x\n")
	if p, _ := a.repo.Pending(); strings.Join(p, ",") != "dir/x.md" {
		t.Fatalf("pending %v", p)
	}
	if ok, err := a.repo.CommitAll("", Signature{}); !ok || err != nil {
		t.Fatalf("commit all: %v %v", ok, err)
	}
	if a.repo.Ahead() != 1 {
		t.Errorf("ahead %d", a.repo.Ahead())
	}
}
