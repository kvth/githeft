package notes

import (
	"github.com/kvth/githeft/internal/merge"
)

// Merge merges two edits of a note. Both sides nearly always changed the
// modified date, which would make every concurrent edit a conflict, so both
// get the later of the two dates before the lines are merged.
func Merge(base, ours, theirs string) (string, bool) {
	o, t := Parse(ours), Parse(theirs)
	ov, ook := o.Get("modified")
	tv, tok := t.Get("modified")
	if ook && tok && ov != tv {
		ot, _, ok1 := ParseTime(ov)
		tt, _, ok2 := ParseTime(tv)
		if ok1 && ok2 {
			later := ov
			if tt.After(ot) {
				later = tv
			}
			o.Set("modified", later)
			t.Set("modified", later)
			ours, theirs = o.String(), t.String()
		}
	}
	return merge.Lines(base, ours, theirs)
}
