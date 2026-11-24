package service

import (
	"context"
	"crypto/sha256"
	"encoding/hex"
	"errors"
	"fmt"
	"io/fs"
	"os"
	"path"
	"path/filepath"
	"sort"
	"strings"
	"sync"
	"time"

	"connectrpc.com/connect"

	v1 "github.com/kvth/githeft/gen/githeft/v1"
	"github.com/kvth/githeft/internal/notes"
)

// noteCache keeps the parsed summary of each note until its file changes, so
// listing a notebook only reads the files that changed.
type noteCache struct {
	mu      sync.Mutex
	entries map[string]cacheEntry
}

type cacheEntry struct {
	modTime time.Time
	size    int64
	info    notes.Info
}

func (c *noteCache) get(rel, full string, fi fs.FileInfo) (notes.Info, error) {
	c.mu.Lock()
	e, ok := c.entries[rel]
	c.mu.Unlock()
	if ok && e.modTime.Equal(fi.ModTime()) && e.size == fi.Size() {
		return e.info, nil
	}
	data, err := os.ReadFile(full)
	if err != nil {
		return notes.Info{}, err
	}
	info := notes.Describe(rel, string(data), fi.ModTime())
	c.mu.Lock()
	if c.entries == nil {
		c.entries = map[string]cacheEntry{}
	}
	c.entries[rel] = cacheEntry{fi.ModTime(), fi.Size(), info}
	c.mu.Unlock()
	return info, nil
}

// cleanPath checks a path from the app: relative, inside the notebook, not
// in .git. folder allows the empty path for the root.
func cleanPath(p string, folder bool) (string, error) {
	p = strings.Trim(strings.ReplaceAll(p, "\\", "/"), "/")
	if p == "" {
		if folder {
			return "", nil
		}
		return "", invalid("empty path")
	}
	c := path.Clean(p)
	if c == "." || c == ".." || strings.HasPrefix(c, "../") {
		return "", invalid("%q is outside the notebook", p)
	}
	for _, part := range strings.Split(c, "/") {
		if part == ".git" {
			return "", invalid("%q is inside .git", p)
		}
	}
	return c, nil
}

func revision(data []byte) string {
	sum := sha256.Sum256(data)
	return hex.EncodeToString(sum[:8])
}

func summary(rel string, info notes.Info) *v1.NoteSummary {
	return &v1.NoteSummary{
		Path:     rel,
		Title:    info.Title,
		Excerpt:  info.Excerpt,
		Tags:     info.Tags,
		Created:  info.Created.Unix(),
		Modified: info.Modified.Unix(),
		Conflict: info.Conflict,
		Pinned:   info.Pinned,
		Type:     typeToProto(info.Type),
	}
}

func typeToProto(t string) v1.NoteType {
	switch t {
	case notes.TypeChecklist:
		return v1.NoteType_NOTE_TYPE_CHECKLIST
	case notes.TypeJournal:
		return v1.NoteType_NOTE_TYPE_JOURNAL
	}
	return v1.NoteType_NOTE_TYPE_MARKDOWN
}

func typeFromProto(t v1.NoteType) string {
	switch t {
	case v1.NoteType_NOTE_TYPE_CHECKLIST:
		return notes.TypeChecklist
	case v1.NoteType_NOTE_TYPE_JOURNAL:
		return notes.TypeJournal
	}
	return ""
}

// walk calls fn for every note, skipping hidden files and folders.
func walk(root string, fn func(rel, full string, fi fs.FileInfo), dir func(rel string)) error {
	return filepath.WalkDir(root, func(full string, d fs.DirEntry, err error) error {
		if err != nil {
			if full == root {
				return err
			}
			return nil
		}
		rel, _ := filepath.Rel(root, full)
		rel = filepath.ToSlash(rel)
		if rel == "." {
			return nil
		}
		if strings.HasPrefix(d.Name(), ".") {
			if d.IsDir() {
				return filepath.SkipDir
			}
			return nil
		}
		if d.IsDir() {
			if dir != nil {
				dir(rel)
			}
			return nil
		}
		if !notes.IsNote(d.Name()) {
			return nil
		}
		fi, err := d.Info()
		if err == nil {
			fn(rel, full, fi)
		}
		return nil
	})
}

func (s *Service) ListNotes(ctx context.Context, req *connect.Request[v1.ListNotesRequest]) (*connect.Response[v1.ListNotesResponse], error) {
	m := req.Msg
	nb, b, err := s.notebook(m.NotebookId)
	if err != nil {
		return nil, err
	}
	folder, err := cleanPath(m.Folder, true)
	if err != nil {
		return nil, err
	}
	query := strings.ToLower(strings.TrimSpace(m.Query))
	tag := strings.ToLower(strings.TrimPrefix(strings.TrimSpace(m.Tag), "#"))

	res := &v1.ListNotesResponse{}
	folders := map[string]*v1.Folder{}
	inFolder := func(rel string) bool {
		dir := path.Dir(rel)
		if dir == "." {
			dir = ""
		}
		if m.Recursive {
			return folder == "" || dir == folder || strings.HasPrefix(dir, folder+"/")
		}
		return dir == folder
	}
	err = walk(nb.Path, func(rel, full string, fi fs.FileInfo) {
		// Count notes for every folder they are in, for the folder list.
		for dir := path.Dir(rel); dir != "."; dir = path.Dir(dir) {
			if f := folders[dir]; f != nil {
				f.NoteCount++
			}
		}
		if !inFolder(rel) {
			return
		}
		info, err := b.cache.get(rel, full, fi)
		if err != nil {
			return
		}
		if tag != "" && !hasTag(info.Tags, tag) {
			return
		}
		if query != "" && !matches(rel, full, info, query) {
			return
		}
		res.Notes = append(res.Notes, summary(rel, info))
	}, func(rel string) {
		folders[rel] = &v1.Folder{Path: rel}
	})
	if err != nil {
		return nil, err
	}
	for rel, f := range folders {
		parent := path.Dir(rel)
		if parent == "." {
			parent = ""
		}
		if m.Recursive || parent == folder {
			res.Folders = append(res.Folders, f)
		}
	}
	sort.Slice(res.Folders, func(i, j int) bool { return res.Folders[i].Path < res.Folders[j].Path })
	sortNotes(res.Notes, m.Sort)
	return ok(res)
}

func hasTag(tags []string, tag string) bool {
	for _, t := range tags {
		if lt := strings.ToLower(t); lt == tag || strings.HasPrefix(lt, tag+"/") {
			return true
		}
	}
	return false
}

func matches(rel, full string, info notes.Info, query string) bool {
	if strings.Contains(strings.ToLower(rel), query) || strings.Contains(strings.ToLower(info.Title), query) {
		return true
	}
	data, err := os.ReadFile(full)
	return err == nil && strings.Contains(strings.ToLower(string(data)), query)
}

func sortNotes(list []*v1.NoteSummary, order v1.SortOrder) {
	sort.SliceStable(list, func(i, j int) bool {
		a, b := list[i], list[j]
		switch order {
		case v1.SortOrder_SORT_ORDER_CREATED_DESC:
			if a.Created != b.Created {
				return a.Created > b.Created
			}
		case v1.SortOrder_SORT_ORDER_TITLE_ASC:
			if at, bt := strings.ToLower(a.Title), strings.ToLower(b.Title); at != bt {
				return at < bt
			}
		case v1.SortOrder_SORT_ORDER_PATH_ASC:
		default:
			if a.Modified != b.Modified {
				return a.Modified > b.Modified
			}
		}
		return a.Path < b.Path
	})
}

func (s *Service) readNote(nbPath, rel string) (*v1.Note, []byte, error) {
	full := filepath.Join(nbPath, filepath.FromSlash(rel))
	fi, err := os.Stat(full)
	if errors.Is(err, os.ErrNotExist) {
		return nil, nil, connect.NewError(connect.CodeNotFound, fmt.Errorf("no note %s", rel))
	} else if err != nil {
		return nil, nil, err
	}
	data, err := os.ReadFile(full)
	if err != nil {
		return nil, nil, err
	}
	raw := string(data)
	return &v1.Note{
		Summary:  summary(rel, notes.Describe(rel, raw, fi.ModTime())),
		Body:     notes.Parse(raw).Body,
		Raw:      raw,
		Revision: revision(data),
	}, data, nil
}

func (s *Service) GetNote(ctx context.Context, req *connect.Request[v1.GetNoteRequest]) (*connect.Response[v1.Note], error) {
	nb, _, err := s.notebook(req.Msg.NotebookId)
	if err != nil {
		return nil, err
	}
	rel, err := cleanPath(req.Msg.Path, false)
	if err != nil {
		return nil, err
	}
	note, _, err := s.readNote(nb.Path, rel)
	if err != nil {
		return nil, err
	}
	return ok(note)
}

func (s *Service) SaveNote(ctx context.Context, req *connect.Request[v1.SaveNoteRequest]) (*connect.Response[v1.SaveNoteResponse], error) {
	m := req.Msg
	nb, b, err := s.notebook(m.NotebookId)
	if err != nil {
		return nil, err
	}
	author := signature(nb)
	now := time.Now()
	res := &v1.SaveNoteResponse{}

	if m.Path == "" {
		folder := m.Folder
		if folder == "" {
			folder = nb.DefaultFolder
		}
		if folder, err = cleanPath(folder, true); err != nil {
			return nil, err
		}
		byTitle := nb.NewNoteName != "datetime" && m.Type != v1.NoteType_NOTE_TYPE_JOURNAL
		name := notes.FileName(m.Content, byTitle, now)
		if m.Raw {
			name = notes.FileName(notes.Parse(m.Content).Body, byTitle, now)
		}
		rel := unique(nb.Path, path.Join(folder, name))
		text := m.Content
		if !m.Raw {
			var tags []string
			if m.Tags != nil {
				tags = m.Tags.Tags
			}
			text = notes.New(m.Content, tags, now)
			if t := typeFromProto(m.Type); t != "" {
				doc := notes.Parse(text)
				doc.Set("type", t)
				text = doc.String()
			}
		}
		if err := writeFile(nb.Path, rel, []byte(text)); err != nil {
			return nil, err
		}
		if err := b.repo.Commit("Added Note "+rel, author, rel); err != nil {
			return nil, err
		}
		if res.Note, _, err = s.readNote(nb.Path, rel); err != nil {
			return nil, err
		}
		return ok(res)
	}

	rel, err := cleanPath(m.Path, false)
	if err != nil {
		return nil, err
	}
	current, data, err := s.readNote(nb.Path, rel)
	if err != nil {
		return nil, err
	}
	content := m.Content
	if m.BaseRevision != "" && m.BaseRevision != current.Revision {
		// The file changed while the note was open, by a sync or another
		// editor: merge both edits, or keep ours and save theirs aside.
		theirs := current.Body
		if m.Raw {
			theirs = current.Raw
		}
		if merged, okMerge := notes.Merge(m.BaseContent, content, theirs); okMerge {
			content = merged
		} else {
			ext := path.Ext(rel)
			copyRel := unique(nb.Path, strings.TrimSuffix(rel, ext)+notes.ConflictMarker+now.Format("20060102-150405")+ext)
			if err := writeFile(nb.Path, copyRel, data); err != nil {
				return nil, err
			}
			if err := b.repo.Commit("Added conflict copy "+copyRel, author, copyRel); err != nil {
				return nil, err
			}
			res.ConflictCopy = copyRel
		}
	}

	var text string
	if m.Raw {
		text = content
	} else {
		doc := notes.Parse(current.Raw)
		doc.Body = content
		if m.Tags != nil {
			doc.SetTags(m.Tags.Tags)
		}
		if doc.String() != current.Raw {
			doc.Touch(now)
		}
		text = doc.String()
	}
	if text != current.Raw {
		if err := writeFile(nb.Path, rel, []byte(text)); err != nil {
			return nil, err
		}
		if err := b.repo.Commit("Updated Note "+rel, author, rel); err != nil {
			return nil, err
		}
	}
	if res.Note, _, err = s.readNote(nb.Path, rel); err != nil {
		return nil, err
	}
	return ok(res)
}

// unique appends " 2", " 3", … to the name until no file has it.
func unique(root, rel string) string {
	ext := path.Ext(rel)
	stem := strings.TrimSuffix(rel, ext)
	for i := 2; ; i++ {
		if _, err := os.Lstat(filepath.Join(root, filepath.FromSlash(rel))); errors.Is(err, os.ErrNotExist) {
			return rel
		}
		rel = fmt.Sprintf("%s %d%s", stem, i, ext)
	}
}

func writeFile(root, rel string, data []byte) error {
	full := filepath.Join(root, filepath.FromSlash(rel))
	if err := os.MkdirAll(filepath.Dir(full), 0o755); err != nil {
		return err
	}
	tmp := full + ".githeft-tmp"
	if err := os.WriteFile(tmp, data, 0o644); err != nil {
		return err
	}
	return os.Rename(tmp, full)
}

func (s *Service) RenameNote(ctx context.Context, req *connect.Request[v1.RenameNoteRequest]) (*connect.Response[v1.Note], error) {
	nb, b, err := s.notebook(req.Msg.NotebookId)
	if err != nil {
		return nil, err
	}
	from, err := cleanPath(req.Msg.Path, false)
	if err != nil {
		return nil, err
	}
	to, err := cleanPath(req.Msg.NewPath, false)
	if err != nil {
		return nil, err
	}
	if !notes.IsNote(to) {
		to += path.Ext(from)
	}
	if from == to {
		note, _, err := s.readNote(nb.Path, from)
		if err != nil {
			return nil, err
		}
		return ok(note)
	}
	fromFull := filepath.Join(nb.Path, filepath.FromSlash(from))
	toFull := filepath.Join(nb.Path, filepath.FromSlash(to))
	if _, err := os.Lstat(toFull); err == nil {
		return nil, connect.NewError(connect.CodeAlreadyExists, fmt.Errorf("%s already exists", to))
	}
	if err := os.MkdirAll(filepath.Dir(toFull), 0o755); err != nil {
		return nil, err
	}
	if err := os.Rename(fromFull, toFull); err != nil {
		if errors.Is(err, os.ErrNotExist) {
			return nil, connect.NewError(connect.CodeNotFound, fmt.Errorf("no note %s", from))
		}
		return nil, err
	}
	msg := fmt.Sprintf("Renamed Note %s to %s", from, to)
	if path.Dir(from) != path.Dir(to) {
		msg = fmt.Sprintf("Moved Note %s to %s", from, to)
	}
	if err := b.repo.Commit(msg, signature(nb), from, to); err != nil {
		return nil, err
	}
	note, _, err := s.readNote(nb.Path, to)
	if err != nil {
		return nil, err
	}
	return ok(note)
}

func (s *Service) DeleteNote(ctx context.Context, req *connect.Request[v1.DeleteNoteRequest]) (*connect.Response[v1.DeleteNoteResponse], error) {
	nb, b, err := s.notebook(req.Msg.NotebookId)
	if err != nil {
		return nil, err
	}
	rel, err := cleanPath(req.Msg.Path, false)
	if err != nil {
		return nil, err
	}
	if err := os.Remove(filepath.Join(nb.Path, filepath.FromSlash(rel))); err != nil {
		if errors.Is(err, os.ErrNotExist) {
			return nil, connect.NewError(connect.CodeNotFound, fmt.Errorf("no note %s", rel))
		}
		return nil, err
	}
	if err := b.repo.Commit("Removed Note "+rel, signature(nb), rel); err != nil {
		return nil, err
	}
	return ok(&v1.DeleteNoteResponse{})
}

func (s *Service) CreateFolder(ctx context.Context, req *connect.Request[v1.CreateFolderRequest]) (*connect.Response[v1.CreateFolderResponse], error) {
	nb, b, err := s.notebook(req.Msg.NotebookId)
	if err != nil {
		return nil, err
	}
	rel, err := cleanPath(req.Msg.Path, false)
	if err != nil {
		return nil, err
	}
	// git does not keep empty folders; .gitkeep makes the folder reach the
	// other devices.
	keep := path.Join(rel, ".gitkeep")
	if err := writeFile(nb.Path, keep, nil); err != nil {
		return nil, err
	}
	if err := b.repo.Commit("Added Folder "+rel, signature(nb), keep); err != nil {
		return nil, err
	}
	return ok(&v1.CreateFolderResponse{})
}

func (s *Service) ListTags(ctx context.Context, req *connect.Request[v1.ListTagsRequest]) (*connect.Response[v1.ListTagsResponse], error) {
	nb, b, err := s.notebook(req.Msg.NotebookId)
	if err != nil {
		return nil, err
	}
	counts := map[string]int32{}
	names := map[string]string{}
	err = walk(nb.Path, func(rel, full string, fi fs.FileInfo) {
		info, err := b.cache.get(rel, full, fi)
		if err != nil {
			return
		}
		for _, t := range info.Tags {
			k := strings.ToLower(t)
			counts[k]++
			if _, ok := names[k]; !ok {
				names[k] = t
			}
		}
	}, nil)
	if err != nil {
		return nil, err
	}
	res := &v1.ListTagsResponse{}
	for k, n := range counts {
		res.Tags = append(res.Tags, &v1.Tag{Name: names[k], NoteCount: n})
	}
	sort.Slice(res.Tags, func(i, j int) bool {
		return strings.ToLower(res.Tags[i].Name) < strings.ToLower(res.Tags[j].Name)
	})
	return ok(res)
}

func (s *Service) UpdateNoteMeta(ctx context.Context, req *connect.Request[v1.UpdateNoteMetaRequest]) (*connect.Response[v1.Note], error) {
	m := req.Msg
	nb, b, err := s.notebook(m.NotebookId)
	if err != nil {
		return nil, err
	}
	rel, err := cleanPath(m.Path, false)
	if err != nil {
		return nil, err
	}
	current, _, err := s.readNote(nb.Path, rel)
	if err != nil {
		return nil, err
	}
	doc := notes.Parse(current.Raw)
	var what []string
	if m.Pinned != nil {
		if *m.Pinned {
			doc.Set("pinned", "true")
			what = append(what, "Pinned")
		} else {
			doc.Delete("pinned")
			what = append(what, "Unpinned")
		}
	}
	if m.Type != nil {
		doc.Delete("editorType")
		if t := typeFromProto(*m.Type); t != "" {
			doc.Set("type", t)
		} else {
			doc.Delete("type")
		}
		what = append(what, "Changed type of")
	}
	if text := doc.String(); text != current.Raw && len(what) > 0 {
		if err := writeFile(nb.Path, rel, []byte(text)); err != nil {
			return nil, err
		}
		if err := b.repo.Commit(strings.Join(what, ", ")+" Note "+rel, signature(nb), rel); err != nil {
			return nil, err
		}
	}
	note, _, err := s.readNote(nb.Path, rel)
	if err != nil {
		return nil, err
	}
	return ok(note)
}
