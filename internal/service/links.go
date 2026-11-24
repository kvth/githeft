package service

import (
	"context"
	"errors"
	"fmt"
	"io/fs"
	"mime"
	"net/url"
	"os"
	"path"
	"path/filepath"
	"regexp"
	"strings"
	"time"

	"connectrpc.com/connect"

	v1 "github.com/kvth/githeft/gen/githeft/v1"
	"github.com/kvth/githeft/internal/notes"
)

type indexed struct {
	rel  string
	info notes.Info
}

// index describes every note of a notebook, from the cache where possible.
func (b *book) index(root string) ([]indexed, error) {
	var all []indexed
	err := walk(root, func(rel, full string, fi fs.FileInfo) {
		if info, err := b.cache.get(rel, full, fi); err == nil {
			all = append(all, indexed{rel, info})
		}
	}, nil)
	return all, err
}

// resolve finds the note a link in the note from points to. target is a
// Markdown link href (relative to from's folder, URL-escaped) or the text of
// a [[wiki link]]: a path, a file name without extension or a title. Notes
// in from's own folder win when names repeat.
func resolve(all []indexed, from, target string) string {
	target = strings.TrimSpace(target)
	if !notes.LocalLink(target) {
		return ""
	}
	if i := strings.IndexByte(target, '#'); i > 0 {
		target = target[:i]
	}
	if u, err := url.PathUnescape(target); err == nil {
		target = u
	}
	dir := path.Dir(from)
	exists := map[string]bool{}
	for _, n := range all {
		exists[n.rel] = true
	}
	var candidates []string
	if strings.HasPrefix(target, "/") {
		candidates = append(candidates, path.Clean(strings.TrimPrefix(target, "/")))
	} else {
		candidates = append(candidates, path.Join(dir, target), path.Clean(target))
	}
	for _, c := range candidates {
		if exists[c] {
			return c
		}
		for _, ext := range notes.Extensions {
			if exists[c+ext] {
				return c + ext
			}
		}
	}
	// [[Name]]: a file name without extension, then a title.
	name := strings.ToLower(path.Base(target))
	best := ""
	for _, match := range []func(indexed) bool{
		func(n indexed) bool {
			return strings.ToLower(strings.TrimSuffix(path.Base(n.rel), path.Ext(n.rel))) == name
		},
		func(n indexed) bool { return strings.ToLower(n.info.Title) == strings.ToLower(target) },
	} {
		for _, n := range all {
			if !match(n) {
				continue
			}
			if path.Dir(n.rel) == dir {
				return n.rel
			}
			if best == "" {
				best = n.rel
			}
		}
		if best != "" {
			return best
		}
	}
	return ""
}

func (s *Service) ResolveLink(ctx context.Context, req *connect.Request[v1.ResolveLinkRequest]) (*connect.Response[v1.ResolveLinkResponse], error) {
	nb, b, err := s.notebook(req.Msg.NotebookId)
	if err != nil {
		return nil, err
	}
	from, err := cleanPath(req.Msg.FromPath, true)
	if err != nil {
		return nil, err
	}
	all, err := b.index(nb.Path)
	if err != nil {
		return nil, err
	}
	return ok(&v1.ResolveLinkResponse{Path: resolve(all, from, req.Msg.Target)})
}

func (s *Service) GetBacklinks(ctx context.Context, req *connect.Request[v1.GetBacklinksRequest]) (*connect.Response[v1.GetBacklinksResponse], error) {
	nb, b, err := s.notebook(req.Msg.NotebookId)
	if err != nil {
		return nil, err
	}
	target, err := cleanPath(req.Msg.Path, false)
	if err != nil {
		return nil, err
	}
	all, err := b.index(nb.Path)
	if err != nil {
		return nil, err
	}
	res := &v1.GetBacklinksResponse{}
	for _, n := range all {
		if n.rel == target {
			continue
		}
		for _, l := range n.info.Links {
			if resolve(all, n.rel, l) == target {
				res.Notes = append(res.Notes, summary(n.rel, n.info))
				break
			}
		}
	}
	sortNotes(res.Notes, v1.SortOrder_SORT_ORDER_MODIFIED_DESC)
	return ok(res)
}

// maxAttachment keeps a single file from filling the phone or the gRPC
// connection.
const maxAttachment = 50 << 20

var unsafeName = regexp.MustCompile(`[^\p{L}\p{N}._-]+`)

func attachmentName(original string, now time.Time) string {
	ext := strings.ToLower(path.Ext(original))
	if len(ext) > 10 || unsafeName.MatchString(ext[min(1, len(ext)):]) {
		ext = ""
	}
	stem := strings.Trim(unsafeName.ReplaceAllString(strings.TrimSuffix(path.Base(original), path.Ext(original)), "-"), "-.")
	if len(stem) > 40 {
		stem = stem[:40]
	}
	if stem == "" {
		stem = "file"
	}
	return fmt.Sprintf("%s-%s%s", stem, now.Format("20060102-150405"), ext)
}

func isImage(name string) bool {
	switch strings.ToLower(path.Ext(name)) {
	case ".png", ".jpg", ".jpeg", ".gif", ".webp", ".bmp", ".svg", ".heic", ".avif":
		return true
	}
	return false
}

func (s *Service) AddAttachment(ctx context.Context, req *connect.Request[v1.AddAttachmentRequest]) (*connect.Response[v1.AddAttachmentResponse], error) {
	m := req.Msg
	nb, b, err := s.notebook(m.NotebookId)
	if err != nil {
		return nil, err
	}
	if len(m.Data) == 0 {
		return nil, invalid("the file is empty")
	}
	if len(m.Data) > maxAttachment {
		return nil, invalid("the file is larger than %d MB", maxAttachment>>20)
	}
	folder := m.Folder
	if m.NotePath != "" {
		notePath, err := cleanPath(m.NotePath, false)
		if err != nil {
			return nil, err
		}
		folder = path.Dir(notePath)
	} else if folder == "" {
		folder = nb.DefaultFolder
	}
	if folder, err = cleanPath(folder, true); err != nil {
		return nil, err
	}
	name := attachmentName(m.FileName, time.Now())
	rel := unique(nb.Path, path.Join(folder, name))
	if err := writeFile(nb.Path, rel, m.Data); err != nil {
		return nil, err
	}
	if err := b.repo.Commit("Added "+rel, signature(nb), rel); err != nil {
		return nil, err
	}
	link := "./" + (&url.URL{Path: path.Base(rel)}).EscapedPath()
	md := fmt.Sprintf("[%s](%s)", path.Base(rel), link)
	if isImage(rel) {
		md = fmt.Sprintf("![Image](%s)", link)
	}
	return ok(&v1.AddAttachmentResponse{Path: rel, Markdown: md})
}

func (s *Service) GetFile(ctx context.Context, req *connect.Request[v1.GetFileRequest]) (*connect.Response[v1.GetFileResponse], error) {
	nb, _, err := s.notebook(req.Msg.NotebookId)
	if err != nil {
		return nil, err
	}
	rel, err := cleanPath(req.Msg.Path, false)
	if err != nil {
		return nil, err
	}
	full := filepath.Join(nb.Path, filepath.FromSlash(rel))
	fi, err := os.Stat(full)
	if errors.Is(err, os.ErrNotExist) {
		return nil, connect.NewError(connect.CodeNotFound, fmt.Errorf("no file %s", rel))
	} else if err != nil {
		return nil, err
	}
	if fi.IsDir() || fi.Size() > maxAttachment {
		return nil, invalid("%s is not a file that can be shown", rel)
	}
	data, err := os.ReadFile(full)
	if err != nil {
		return nil, err
	}
	return ok(&v1.GetFileResponse{Data: data, MimeType: mime.TypeByExtension(path.Ext(rel))})
}
