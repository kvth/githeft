// Package merge does three-way merges of text files line by line, the way
// git merges files that both sides changed.
package merge

import (
	"strings"

	"github.com/sergi/go-diff/diffmatchpatch"
)

// Lines merges ours and theirs, both edited from base. ok is false when both
// changed the same lines differently; merged is then not usable.
func Lines(base, ours, theirs string) (merged string, ok bool) {
	if ours == theirs || theirs == base {
		return ours, true
	}
	if ours == base {
		return theirs, true
	}
	b, o, t := split(base), split(ours), split(theirs)
	mo, mt := match(b, o), match(b, t)

	var out strings.Builder
	i, j, k := 0, 0, 0
	for {
		// Lines all three agree on.
		for i < len(b) && mo[i] == j && mt[i] == k {
			out.WriteString(b[i])
			i, j, k = i+1, j+1, k+1
		}
		if i == len(b) && j == len(o) && k == len(t) {
			return out.String(), true
		}
		// The next base line both sides kept ends the changed chunk.
		i2 := i
		for i2 < len(b) && (mo[i2] < 0 || mt[i2] < 0) {
			i2++
		}
		j2, k2 := len(o), len(t)
		if i2 < len(b) {
			j2, k2 = mo[i2], mt[i2]
		}
		bc, oc, tc := b[i:i2], o[j:j2], t[k:k2]
		switch {
		case equal(oc, bc):
			write(&out, tc)
		case equal(tc, bc), equal(oc, tc):
			write(&out, oc)
		default:
			return "", false
		}
		i, j, k = i2, j2, k2
	}
}

// split cuts s into lines that keep their "\n".
func split(s string) []string {
	if s == "" {
		return nil
	}
	lines := strings.SplitAfter(s, "\n")
	if lines[len(lines)-1] == "" {
		lines = lines[:len(lines)-1]
	}
	return lines
}

// match maps each line of a to the line of b it is matched with in a
// longest common subsequence, or -1.
func match(a, b []string) []int {
	m := make([]int, len(a))
	for i := range m {
		m[i] = -1
	}
	dmp := diffmatchpatch.New()
	ra, rb, _ := dmp.DiffLinesToRunes(strings.Join(a, ""), strings.Join(b, ""))
	i, j := 0, 0
	for _, d := range dmp.DiffMainRunes(ra, rb, false) {
		n := len([]rune(d.Text))
		switch d.Type {
		case diffmatchpatch.DiffEqual:
			for x := 0; x < n; x++ {
				m[i+x] = j + x
			}
			i, j = i+n, j+n
		case diffmatchpatch.DiffDelete:
			i += n
		case diffmatchpatch.DiffInsert:
			j += n
		}
	}
	return m
}

func equal(a, b []string) bool {
	if len(a) != len(b) {
		return false
	}
	for i := range a {
		if a[i] != b[i] {
			return false
		}
	}
	return true
}

func write(out *strings.Builder, lines []string) {
	for _, l := range lines {
		out.WriteString(l)
	}
}
