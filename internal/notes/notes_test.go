package notes

import (
	"strings"
	"testing"
	"time"
)

const sample = `---
created: 2024-07-04T16:17:20
modified: 2024-07-04T16:17:20
tags: [Async]
custom:
  - keep
  - me
---

# Sans IO

Some text with #inline tag and a [link](http://x/#frag).
`

func TestRoundTrip(t *testing.T) {
	for _, raw := range []string{sample, "no front matter\n", "---\nnot closed\n", "---\r\na: 1\r\n---\r\nbody", ""} {
		if got := Parse(raw).String(); got != raw {
			t.Errorf("round trip changed\n%q\n%q", raw, got)
		}
	}
}

func TestTouchKeepsOtherLines(t *testing.T) {
	d := Parse(sample)
	d.Touch(time.Date(2026, 11, 24, 15, 30, 0, 0, time.Local))
	want := strings.Replace(sample, "modified: 2024-07-04T16:17:20", "modified: 2026-11-24T15:30:00", 1)
	if got := d.String(); got != want {
		t.Errorf("got\n%s\nwant\n%s", got, want)
	}
}

func TestSetTagsBlockList(t *testing.T) {
	d := Parse("---\ntags:\n  - a\n  - b\ncreated: x\n---\nbody")
	if got := d.Tags(); strings.Join(got, ",") != "a,b" {
		t.Fatalf("tags %v", got)
	}
	d.SetTags([]string{"c", "with space"})
	if want := "---\ntags: [c, with space]\ncreated: x\n---\nbody"; d.String() != want {
		t.Errorf("got %q", d.String())
	}
	d.SetTags(nil)
	if want := "---\ncreated: x\n---\nbody"; d.String() != want {
		t.Errorf("got %q", d.String())
	}
}

func TestDescribe(t *testing.T) {
	info := Describe("Sans IO.md", sample, time.Time{})
	if info.Title != "Sans IO" {
		t.Errorf("title %q", info.Title)
	}
	if strings.Join(info.Tags, ",") != "Async,inline" {
		t.Errorf("tags %v", info.Tags)
	}
	if info.Created.Year() != 2024 || info.Excerpt == "" || strings.Contains(info.Excerpt, "Sans IO") {
		t.Errorf("info %+v", info)
	}
	if got := Describe("dir/20250104T095410.md", "just text", time.Time{}).Title; got != "20250104T095410" {
		t.Errorf("fallback title %q", got)
	}
}

func TestNewAndFileName(t *testing.T) {
	now := time.Date(2026, 8, 26, 19, 27, 20, 0, time.Local)
	raw := New("# Hello: World?\n\ntext\n", nil, now)
	if want := "---\ncreated: 2026-08-26T19:27:20\nmodified: 2026-08-26T19:27:20\n---\n\n# Hello: World?\n\ntext\n"; raw != want {
		t.Errorf("new note\n%q", raw)
	}
	if got := FileName("# Hello: World?\n", true, now); got != "Hello World.md" {
		t.Errorf("file name %q", got)
	}
	for body, want := range map[string]string{
		"- [ ] buy milk\n": "buy milk.md",
		"> quoted\n":       "quoted.md",
		"1. first\n":       "first.md",
		"\n\n## Sub\n":     "Sub.md",
	} {
		if got := FileName(body, true, now); got != want {
			t.Errorf("file name for %q: %q", body, got)
		}
	}
	if got := FileName("", true, now); got != "20260826T192720.md" {
		t.Errorf("file name %q", got)
	}
}

func TestMergeNote(t *testing.T) {
	base := "---\nmodified: 2026-01-01T10:00:00\n---\n\nline 1\nline 2\nline 3\n"
	ours := "---\nmodified: 2026-01-02T10:00:00\n---\n\nline 1 ours\nline 2\nline 3\n"
	theirs := "---\nmodified: 2026-01-03T10:00:00\n---\n\nline 1\nline 2\nline 3 theirs\n"
	got, ok := Merge(base, ours, theirs)
	want := "---\nmodified: 2026-01-03T10:00:00\n---\n\nline 1 ours\nline 2\nline 3 theirs\n"
	if !ok || got != want {
		t.Errorf("merge ok=%v\n%s", ok, got)
	}
	if _, ok := Merge(base, strings.Replace(base, "line 2", "A", 1), strings.Replace(base, "line 2", "B", 1)); ok {
		t.Error("conflicting edits merged")
	}
}

func TestDescribeMeta(t *testing.T) {
	raw := "---\ncreated: 2026-11-24T17:05:00\npinned: true\ntype: Journal\n---\n\nSaw [[Garden]] and [[ideas/Pond plans|the pond]], " +
		"[x](Other%20note.md) [web](https://x.org/a.md) ![img](./pic.jpg) [anchor](#top)\n"
	info := Describe("20261124T170500.md", raw, time.Time{})
	if !info.Pinned || info.Type != TypeJournal {
		t.Errorf("meta %+v", info)
	}
	if info.Title != "Tue 24 Nov 2026, 17:05" {
		t.Errorf("journal title %q", info.Title)
	}
	if got := strings.Join(info.Links, ","); got != "Garden,ideas/Pond plans,Other%20note.md" {
		t.Errorf("links %q", got)
	}
}
