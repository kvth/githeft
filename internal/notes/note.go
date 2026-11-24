package notes

import (
	"path"
	"regexp"
	"sort"
	"strings"
	"time"
	"unicode"
)

// Extensions of the files that count as notes.
var Extensions = []string{".md", ".markdown", ".txt"}

// IsNote reports whether a file name has a note extension.
func IsNote(name string) bool {
	ext := strings.ToLower(path.Ext(name))
	for _, e := range Extensions {
		if ext == e {
			return true
		}
	}
	return false
}

// Info is what the note list shows.
type Info struct {
	Title    string
	Excerpt  string
	Tags     []string
	Created  time.Time
	Modified time.Time
	Conflict bool
	// Pinned notes are listed first (front matter "pinned: true").
	Pinned bool
	// Type is the editor the note opens in: TypeChecklist, TypeJournal or
	// "" for Markdown (front matter "type").
	Type string
	// Links are the targets of [[wiki links]] and of relative Markdown links
	// (as written, not resolved).
	Links []string
}

// Editor types as GitJournal writes them into the front matter.
const (
	TypeChecklist = "Checklist"
	TypeJournal   = "Journal"
)

var (
	wikiLink = regexp.MustCompile(`\[\[([^\]|#\n]+)(?:#[^\]|\n]*)?(?:\|[^\]\n]*)?\]\]`)
	mdLink   = regexp.MustCompile(`(?:^|[^!])\[[^\]\n]*\]\(([^)\s]+)(?:\s+"[^"]*")?\)`)
)

// LocalLink reports whether a Markdown link target points into the notebook
// rather than to a web page or an anchor.
func LocalLink(href string) bool {
	return href != "" && !strings.HasPrefix(href, "#") && !strings.Contains(href, "://") &&
		!strings.HasPrefix(href, "mailto:") && !strings.HasPrefix(href, "tel:")
}

// inlineTag matches #tag after the start of a line or whitespace. "# Heading"
// has a space and is no tag; URL fragments have no whitespace before them.
var inlineTag = regexp.MustCompile(`(?:^|\s)#([\p{L}\p{N}_/-]*\p{L}[\p{L}\p{N}_/-]*)`)

// Describe extracts title, tags, dates and an excerpt from a note's text.
// name is the file name, the title of last resort; fileTime stands in for
// missing dates.
func Describe(name, raw string, fileTime time.Time) Info {
	doc := Parse(raw)
	info := Info{Created: fileTime, Modified: fileTime}
	if v, ok := doc.Get("created"); ok {
		if t, _, ok := ParseTime(v); ok {
			info.Created = t
		}
	}
	if v, ok := doc.Get("modified"); ok {
		if t, _, ok := ParseTime(v); ok {
			info.Modified = t
		}
	}

	headingLine := -1
	lines := strings.Split(doc.Body, "\n")
	if v, ok := doc.Get("title"); ok && strings.TrimSpace(v) != "" {
		info.Title = strings.TrimSpace(v)
	} else {
		for i, l := range lines {
			if strings.HasPrefix(l, "# ") {
				info.Title = strings.TrimSpace(strings.TrimRight(l[2:], "# \r"))
				headingLine = i
				break
			}
		}
	}
	if v, ok := doc.Get("pinned"); ok && strings.EqualFold(strings.TrimSpace(v), "true") {
		info.Pinned = true
	}
	for _, key := range []string{"type", "editorType"} {
		if v, ok := doc.Get(key); ok {
			switch strings.ToLower(strings.TrimSpace(v)) {
			case "checklist":
				info.Type = TypeChecklist
			case "journal":
				info.Type = TypeJournal
			}
		}
	}
	if info.Title == "" && info.Type == TypeJournal {
		info.Title = info.Created.Format("Mon 2 Jan 2006, 15:04")
	}
	if info.Title == "" {
		info.Title = strings.TrimSuffix(path.Base(name), path.Ext(name))
	}

	var excerpt strings.Builder
	for i, l := range lines {
		if i == headingLine {
			continue
		}
		if l = strings.TrimSpace(l); l == "" {
			continue
		}
		if excerpt.Len() > 0 {
			excerpt.WriteByte(' ')
		}
		excerpt.WriteString(l)
		if excerpt.Len() > 200 {
			break
		}
	}
	info.Excerpt = truncate(excerpt.String(), 200)

	seen := map[string]bool{}
	add := func(t string) {
		if !seen[strings.ToLower(t)] {
			seen[strings.ToLower(t)] = true
			info.Tags = append(info.Tags, t)
		}
	}
	for _, t := range doc.Tags() {
		add(t)
	}
	inCode := false
	for _, l := range lines {
		if strings.HasPrefix(strings.TrimSpace(l), "```") {
			inCode = !inCode
			continue
		}
		if inCode {
			continue
		}
		for _, m := range inlineTag.FindAllStringSubmatch(l, -1) {
			add(m[1])
		}
		for _, m := range wikiLink.FindAllStringSubmatch(l, -1) {
			info.Links = append(info.Links, strings.TrimSpace(m[1]))
		}
		for _, m := range mdLink.FindAllStringSubmatch(l, -1) {
			if LocalLink(m[1]) {
				info.Links = append(info.Links, m[1])
			}
		}
	}
	sort.Strings(info.Tags)

	info.Conflict = strings.Contains(raw, "\n<<<<<<< ") || strings.HasPrefix(raw, "<<<<<<< ") ||
		strings.Contains(path.Base(name), ConflictMarker)
	return info
}

// ConflictMarker is part of the names of conflict copies.
const ConflictMarker = ".conflict-"

func truncate(s string, n int) string {
	if len(s) <= n {
		return s
	}
	cut := n
	for cut > 0 && !utf8Start(s[cut]) {
		cut--
	}
	return strings.TrimSpace(s[:cut]) + "…"
}

func utf8Start(b byte) bool { return b&0xC0 != 0x80 }

// New returns the text of a new note: front matter with the dates and tags,
// then the body.
func New(body string, tags []string, now time.Time) string {
	doc := Doc{HasFront: true}
	created := FormatTime(now, "")
	doc.Set("created", created)
	doc.Set("modified", created)
	doc.SetTags(tags)
	if body != "" && !strings.HasPrefix(body, "\n") {
		body = "\n" + body
	}
	doc.Body = body
	return doc.String()
}

// FileName picks a file name for a new note from its body: the first
// heading or line, else the date and time like 20260826T192720.
func FileName(body string, byTitle bool, now time.Time) string {
	if byTitle {
		for _, l := range strings.Split(body, "\n") {
			l = strings.TrimSpace(markup.ReplaceAllString(l, ""))
			if l == "" {
				continue
			}
			if name := sanitize(l); name != "" {
				return name + ".md"
			}
			break
		}
	}
	return now.Format("20060102T150405") + ".md"
}

// markup matches what starts a Markdown line but is no part of its text:
// heading marks, quotes, list markers and checkboxes.
var markup = regexp.MustCompile(`^\s*(?:#+|>+|[-*+]|\d+[.)])?\s*(?:\[[ xX]\]\s+)?`)

// sanitize turns a title into a file name that works on Android, Linux and
// Windows checkouts.
func sanitize(title string) string {
	var b strings.Builder
	for _, r := range title {
		switch {
		case strings.ContainsRune(`/\:*?"<>|#^[]`, r):
			b.WriteRune(' ')
		case unicode.IsControl(r):
		default:
			b.WriteRune(r)
		}
	}
	name := strings.Join(strings.Fields(b.String()), " ")
	name = strings.Trim(name, ". ")
	if len(name) > 80 {
		name = truncate(name, 80)
		name = strings.TrimSuffix(name, "…")
	}
	return name
}
