// Package notes reads and writes Markdown notes with an optional YAML front
// matter, the format GitJournal and Obsidian use:
//
//	---
//	created: 2026-08-26T19:27:20
//	modified: 2026-08-26T19:27:22
//	tags: [Async]
//	---
//
//	# Title
//
// Saving only ever touches the lines of the keys it changes, so the file
// keeps its formatting and git diffs stay limited to real edits.
package notes

import (
	"strconv"
	"strings"
	"time"

	"gopkg.in/yaml.v3"
)

// Doc is a note file split into front matter and body. Joining it again
// gives back exactly the original text until a key is changed.
type Doc struct {
	// Front is the YAML between the --- lines, each line ending in "\n".
	Front string
	// HasFront is false for files without front matter.
	HasFront bool
	// open and close are the delimiter lines as found in the file.
	open, close string
	Body        string
}

// Parse splits raw into front matter and body. Text that only looks like
// front matter (no closing delimiter) stays in the body.
func Parse(raw string) Doc {
	first, rest, found := strings.Cut(raw, "\n")
	if !found || strings.TrimRight(first, " \t\r") != "---" {
		return Doc{Body: raw}
	}
	pos := 0
	for pos < len(rest) {
		end := strings.IndexByte(rest[pos:], '\n')
		var line string
		if end < 0 {
			line = rest[pos:]
			end = len(rest) - pos
		} else {
			line = rest[pos : pos+end+1]
			end++
		}
		if t := strings.TrimRight(line, " \t\r\n"); t == "---" || t == "..." {
			return Doc{
				Front:    rest[:pos],
				HasFront: true,
				open:     first + "\n",
				close:    line,
				Body:     rest[pos+end:],
			}
		}
		pos += end
	}
	return Doc{Body: raw}
}

// String joins the document back into file contents.
func (d Doc) String() string {
	if !d.HasFront {
		return d.Body
	}
	open, closing := d.open, d.close
	if open == "" {
		open = "---\n"
	}
	if closing == "" {
		closing = "---\n"
	}
	if !strings.HasSuffix(closing, "\n") {
		closing += "\n"
	}
	return open + d.Front + closing + d.Body
}

// Values decodes the front matter. Invalid YAML gives an empty map; the text
// is still kept as it is.
func (d Doc) Values() map[string]*yaml.Node {
	values := map[string]*yaml.Node{}
	if !d.HasFront {
		return values
	}
	var root yaml.Node
	if err := yaml.Unmarshal([]byte(d.Front), &root); err != nil || len(root.Content) == 0 {
		return values
	}
	m := root.Content[0]
	if m.Kind != yaml.MappingNode {
		return values
	}
	for i := 0; i+1 < len(m.Content); i += 2 {
		values[m.Content[i].Value] = m.Content[i+1]
	}
	return values
}

// Get returns the scalar value of a top-level key.
func (d Doc) Get(key string) (string, bool) {
	n, ok := d.Values()[key]
	if !ok || n.Kind != yaml.ScalarNode {
		return "", false
	}
	return n.Value, true
}

// Tags returns the tags from the front matter, accepting [a, b], a block
// list and a comma or space separated string.
func (d Doc) Tags() []string {
	n, ok := d.Values()["tags"]
	if !ok {
		return nil
	}
	var tags []string
	switch n.Kind {
	case yaml.SequenceNode:
		for _, c := range n.Content {
			if t := strings.TrimSpace(strings.TrimPrefix(c.Value, "#")); t != "" {
				tags = append(tags, t)
			}
		}
	case yaml.ScalarNode:
		for _, t := range strings.FieldsFunc(n.Value, func(r rune) bool { return r == ',' || r == ' ' }) {
			if t = strings.TrimPrefix(t, "#"); t != "" {
				tags = append(tags, t)
			}
		}
	}
	return tags
}

// Set replaces the value of a top-level key, or appends the key. value is
// the YAML text after "key: ". Lines of other keys are left alone.
func (d *Doc) Set(key, value string) {
	d.HasFront = true
	lines := splitLines(d.Front)
	start, end := keyLines(lines, key)
	line := key + ": " + value + "\n"
	if start < 0 {
		if n := len(lines); n > 0 && !strings.HasSuffix(lines[n-1], "\n") {
			lines[n-1] += "\n"
		}
		lines = append(lines, line)
	} else {
		lines = append(lines[:start], append([]string{line}, lines[end:]...)...)
	}
	d.Front = strings.Join(lines, "")
}

// Delete removes a top-level key and its value lines.
func (d *Doc) Delete(key string) {
	lines := splitLines(d.Front)
	start, end := keyLines(lines, key)
	if start < 0 {
		return
	}
	d.Front = strings.Join(append(lines[:start], lines[end:]...), "")
}

// SetTags writes tags as a flow list, or removes the key when empty.
func (d *Doc) SetTags(tags []string) {
	if len(tags) == 0 {
		d.Delete("tags")
		return
	}
	n := &yaml.Node{Kind: yaml.SequenceNode, Style: yaml.FlowStyle}
	for _, t := range tags {
		n.Content = append(n.Content, &yaml.Node{Kind: yaml.ScalarNode, Value: t})
	}
	out, err := yaml.Marshal(n)
	if err != nil {
		return
	}
	d.Set("tags", strings.TrimSpace(string(out)))
}

// keyLines finds the lines of a top-level key: the "key:" line and the
// indented or "- " lines of its value that follow.
func keyLines(lines []string, key string) (start, end int) {
	start = -1
	for i, l := range lines {
		if start < 0 {
			if strings.HasPrefix(l, key+":") {
				start = i
			}
			continue
		}
		if l != "" && (l[0] == ' ' || l[0] == '\t' || l[0] == '-' || strings.TrimSpace(l) == "") {
			continue
		}
		return start, i
	}
	if start < 0 {
		return -1, -1
	}
	// Trailing blank lines belong to the front matter, not the value.
	end = len(lines)
	for end > start+1 && strings.TrimSpace(lines[end-1]) == "" {
		end--
	}
	return start, end
}

func splitLines(s string) []string {
	if s == "" {
		return nil
	}
	lines := strings.SplitAfter(s, "\n")
	if lines[len(lines)-1] == "" {
		lines = lines[:len(lines)-1]
	}
	return lines
}

// Date layouts found in front matter, the first one being what new notes get.
var dateLayouts = []string{
	"2006-01-02T15:04:05",
	time.RFC3339,
	time.RFC3339Nano,
	"2006-01-02T15:04:05.999999999",
	"2006-01-02 15:04:05",
	"2006-01-02 15:04",
	"2006-01-02",
}

// ParseTime reads a front matter date. Unix timestamps in seconds or
// milliseconds work too. The layout is returned so a changed date can be
// written back the same way.
func ParseTime(s string) (time.Time, string, bool) {
	s = strings.TrimSpace(strings.Trim(s, `"'`))
	for _, layout := range dateLayouts {
		if t, err := time.ParseInLocation(layout, s, time.Local); err == nil {
			return t, layout, true
		}
	}
	if n, err := strconv.ParseInt(s, 10, 64); err == nil {
		if n > 1e11 {
			return time.UnixMilli(n), "unixms", true
		}
		return time.Unix(n, 0), "unix", true
	}
	return time.Time{}, "", false
}

// FormatTime writes t in a layout returned by ParseTime.
func FormatTime(t time.Time, layout string) string {
	switch layout {
	case "unix":
		return strconv.FormatInt(t.Unix(), 10)
	case "unixms":
		return strconv.FormatInt(t.UnixMilli(), 10)
	case "":
		layout = dateLayouts[0]
	}
	return t.Format(layout)
}

// Touch sets the modified date to now, in the layout the note already uses.
// Notes without front matter are left without one.
func (d *Doc) Touch(now time.Time) {
	if !d.HasFront {
		return
	}
	layout := dateLayouts[0]
	if v, ok := d.Get("modified"); ok {
		if _, l, ok := ParseTime(v); ok {
			layout = l
		}
	} else if v, ok := d.Get("created"); ok {
		if _, l, ok := ParseTime(v); ok {
			layout = l
		}
	}
	d.Set("modified", FormatTime(now, layout))
}
