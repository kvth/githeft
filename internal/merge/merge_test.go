package merge

import "testing"

func TestLines(t *testing.T) {
	for _, c := range []struct {
		name, base, ours, theirs, want string
		ok                             bool
	}{
		{"same", "a\n", "b\n", "b\n", "b\n", true},
		{"only ours", "a\nb\n", "a\nB\n", "a\nb\n", "a\nB\n", true},
		{"only theirs", "a\nb\n", "a\nb\n", "a\nB\n", "a\nB\n", true},
		{"different lines", "a\nb\nc\nd\n", "A\nb\nc\nd\n", "a\nb\nc\nD\n", "A\nb\nc\nD\n", true},
		{"insert both ends", "m\n", "top\nm\n", "m\nbottom\n", "top\nm\nbottom\n", true},
		{"delete and edit elsewhere", "a\nb\nc\nd\n", "a\nc\nd\n", "a\nb\nc\nD\n", "a\nc\nD\n", true},
		// Like git, edits of neighbouring lines conflict.
		{"adjacent", "a\nb\nc\n", "a\nc\n", "a\nb\nC\n", "", false},
		{"same line", "a\nb\nc\n", "a\nX\nc\n", "a\nY\nc\n", "", false},
		{"both append", "a\n", "a\nx\n", "a\ny\n", "", false},
		{"no trailing newline", "a\nm\nb", "A\nm\nb", "a\nm\nB", "A\nm\nB", true},
		{"empty base", "", "x\n", "x\n", "x\n", true},
	} {
		got, ok := Lines(c.base, c.ours, c.theirs)
		if ok != c.ok || (ok && got != c.want) {
			t.Errorf("%s: got %q ok=%v, want %q ok=%v", c.name, got, ok, c.want, c.ok)
		}
	}
}
