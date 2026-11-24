package server

import (
	"context"
	"net"
	"net/http"
	"os"
	"path/filepath"
	"strings"
	"testing"

	"connectrpc.com/connect"
	"github.com/go-git/go-git/v5"
	"google.golang.org/protobuf/proto"

	v1 "github.com/kvth/githeft/gen/githeft/v1"
	"github.com/kvth/githeft/gen/githeft/v1/githeftv1connect"
	"github.com/kvth/githeft/internal/service"
)

// client starts a core on a Unix socket and connects to it with the gRPC
// protocol over HTTP/2 without TLS, like the app does.
func client(t *testing.T, dataDir string) githeftv1connect.GitheftClient {
	t.Helper()
	svc, err := service.New(dataDir)
	if err != nil {
		t.Fatal(err)
	}
	sock := filepath.Join(t.TempDir(), "g.sock")
	l, err := ListenUnix(sock)
	if err != nil {
		t.Fatal(err)
	}
	ctx, cancel := context.WithCancel(context.Background())
	t.Cleanup(cancel)
	go Serve(ctx, l, Handler(svc, Options{}))

	var protocols http.Protocols
	protocols.SetUnencryptedHTTP2(true)
	httpClient := &http.Client{Transport: &http.Transport{
		Protocols: &protocols,
		DialContext: func(ctx context.Context, _, _ string) (net.Conn, error) {
			return (&net.Dialer{}).DialContext(ctx, "unix", sock)
		},
	}}
	return githeftv1connect.NewGitheftClient(httpClient, "http://githeft", connect.WithGRPC())
}

func TestNotebookOverGRPC(t *testing.T) {
	ctx := context.Background()
	dir := t.TempDir()
	bare := filepath.Join(dir, "remote.git")
	if _, err := git.PlainInit(bare, true); err != nil {
		t.Fatal(err)
	}
	remote := &v1.Remote{Url: "file://" + bare, AuthType: v1.AuthType_AUTH_TYPE_NONE}

	phone := client(t, filepath.Join(dir, "phone"))
	nb, err := phone.CreateNotebook(ctx, connect.NewRequest(&v1.CreateNotebookRequest{
		Source: &v1.CreateNotebookRequest_CloneRemote{CloneRemote: remote},
		Author: &v1.Author{Name: "Phone"},
	}))
	if err != nil {
		t.Fatal(err)
	}
	id := nb.Msg.Id
	if nb.Msg.Name != "remote" {
		t.Errorf("name %q", nb.Msg.Name)
	}

	saved, err := phone.SaveNote(ctx, connect.NewRequest(&v1.SaveNoteRequest{
		NotebookId: id, Folder: "ideas", Content: "# Shopping list\n\n- milk #todo\n",
	}))
	if err != nil {
		t.Fatal(err)
	}
	note := saved.Msg.Note
	if note.Summary.Path != "ideas/Shopping list.md" || note.Summary.Title != "Shopping list" ||
		strings.Join(note.Summary.Tags, ",") != "todo" || !strings.HasPrefix(note.Raw, "---\ncreated: ") {
		t.Fatalf("saved %+v", note)
	}

	list, err := phone.ListNotes(ctx, connect.NewRequest(&v1.ListNotesRequest{NotebookId: id, Recursive: true, Query: "MILK"}))
	if err != nil || len(list.Msg.Notes) != 1 || len(list.Msg.Folders) != 1 || list.Msg.Folders[0].NoteCount != 1 {
		t.Fatalf("list %v %v", list, err)
	}
	st, err := phone.Sync(ctx, connect.NewRequest(&v1.SyncRequest{NotebookId: id}))
	if err != nil || st.Msg.State != v1.SyncState_SYNC_STATE_IDLE || st.Msg.Ahead != 0 {
		t.Fatalf("sync %v %v", st, err)
	}

	// A second device edits the same note while the phone has it open.
	laptop := client(t, filepath.Join(dir, "laptop"))
	nb2, err := laptop.CreateNotebook(ctx, connect.NewRequest(&v1.CreateNotebookRequest{Source: &v1.CreateNotebookRequest_CloneRemote{CloneRemote: remote}}))
	if err != nil {
		t.Fatal(err)
	}
	open, err := laptop.GetNote(ctx, connect.NewRequest(&v1.GetNoteRequest{NotebookId: nb2.Msg.Id, Path: note.Summary.Path}))
	if err != nil {
		t.Fatal(err)
	}
	if _, err := laptop.SaveNote(ctx, connect.NewRequest(&v1.SaveNoteRequest{
		NotebookId: nb2.Msg.Id, Path: note.Summary.Path,
		Content:      strings.Replace(open.Msg.Body, "# Shopping list", "# Shopping list for Saturday", 1),
		BaseRevision: open.Msg.Revision, BaseContent: open.Msg.Body,
	})); err != nil {
		t.Fatal(err)
	}
	if st, err := laptop.Sync(ctx, connect.NewRequest(&v1.SyncRequest{NotebookId: nb2.Msg.Id})); err != nil || st.Msg.Error != "" {
		t.Fatalf("laptop sync %v %v", st, err)
	}

	// The phone syncs in the background, then saves the editor it had open.
	if st, err := phone.Sync(ctx, connect.NewRequest(&v1.SyncRequest{NotebookId: id})); err != nil || len(st.Msg.ChangedPaths) != 1 {
		t.Fatalf("phone sync %v %v", st, err)
	}
	merged, err := phone.SaveNote(ctx, connect.NewRequest(&v1.SaveNoteRequest{
		NotebookId: id, Path: note.Summary.Path,
		Content:      note.Body + "- eggs\n",
		BaseRevision: note.Revision, BaseContent: note.Body,
	}))
	if err != nil {
		t.Fatal(err)
	}
	if b := merged.Msg.Note.Body; merged.Msg.ConflictCopy != "" || !strings.Contains(b, "for Saturday") || !strings.Contains(b, "- eggs") {
		t.Errorf("open editor not merged: copy=%q\n%s", merged.Msg.ConflictCopy, b)
	}

	tags, err := phone.ListTags(ctx, connect.NewRequest(&v1.ListTagsRequest{NotebookId: id}))
	if err != nil || len(tags.Msg.Tags) != 1 || tags.Msg.Tags[0].Name != "todo" {
		t.Errorf("tags %v %v", tags, err)
	}
	if _, err := phone.RenameNote(ctx, connect.NewRequest(&v1.RenameNoteRequest{NotebookId: id, Path: note.Summary.Path, NewPath: "shopping"})); err != nil {
		t.Fatal(err)
	}
	if _, err := phone.GetNote(ctx, connect.NewRequest(&v1.GetNoteRequest{NotebookId: id, Path: "shopping.md"})); err != nil {
		t.Errorf("renamed note: %v", err)
	}
	if _, err := phone.GetNote(ctx, connect.NewRequest(&v1.GetNoteRequest{NotebookId: id, Path: "../secret"})); connect.CodeOf(err) != connect.CodeInvalidArgument {
		t.Errorf("path outside the notebook: %v", err)
	}
	if _, err := phone.CreateNotebook(ctx, connect.NewRequest(&v1.CreateNotebookRequest{Source: &v1.CreateNotebookRequest_ExistingPath{ExistingPath: dir}})); connect.CodeOf(err) != connect.CodePermissionDenied {
		t.Errorf("existing path allowed: %v", err)
	}
}

func TestRemoteValidation(t *testing.T) {
	c := client(t, t.TempDir())
	ctx := context.Background()
	_, err := c.TestRemote(ctx, connect.NewRequest(&v1.TestRemoteRequest{Remote: &v1.Remote{Url: "git@github.com:x/y.git", AuthType: v1.AuthType_AUTH_TYPE_HTTPS}}))
	if connect.CodeOf(err) != connect.CodeInvalidArgument {
		t.Errorf("ssh url with https auth: %v", err)
	}
	_, err = c.TestRemote(ctx, connect.NewRequest(&v1.TestRemoteRequest{Remote: &v1.Remote{Url: "git@github.com:x/y.git"}}))
	if connect.CodeOf(err) != connect.CodeInvalidArgument || !strings.Contains(err.Error(), "SSH key") {
		t.Errorf("ssh without key: %v", err)
	}
	key, err := c.GenerateSshKey(ctx, connect.NewRequest(&v1.GenerateSshKeyRequest{}))
	if err != nil || !strings.HasPrefix(key.Msg.PublicKey, "ssh-ed25519 ") {
		t.Fatalf("key %v %v", key, err)
	}
	got, err := c.GetSshKey(ctx, connect.NewRequest(&v1.GetSshKeyRequest{Id: key.Msg.Id}))
	if err != nil || got.Msg.Fingerprint != key.Msg.Fingerprint {
		t.Errorf("get key %v %v", got, err)
	}
}

func TestNoteFeaturesOverGRPC(t *testing.T) {
	ctx := context.Background()
	dir := t.TempDir()
	c := client(t, filepath.Join(dir, "data"))
	nb, err := c.CreateNotebook(ctx, connect.NewRequest(&v1.CreateNotebookRequest{Source: &v1.CreateNotebookRequest_Empty{Empty: true}}))
	if err != nil {
		t.Fatal(err)
	}
	id := nb.Msg.Id
	save := func(folder, content string, typ v1.NoteType) *v1.Note {
		t.Helper()
		res, err := c.SaveNote(ctx, connect.NewRequest(&v1.SaveNoteRequest{NotebookId: id, Folder: folder, Content: content, Type: typ}))
		if err != nil {
			t.Fatal(err)
		}
		return res.Msg.Note
	}

	// Journal entries are named by date and get type: Journal.
	journal := save("", "Went for a walk.\n", v1.NoteType_NOTE_TYPE_JOURNAL)
	if !strings.Contains(journal.Raw, "\ntype: Journal\n") || strings.HasPrefix(journal.Summary.Path, "Went") ||
		journal.Summary.Type != v1.NoteType_NOTE_TYPE_JOURNAL {
		t.Errorf("journal %s\n%s", journal.Summary.Path, journal.Raw)
	}
	list := save("", "# Groceries\n\n- [ ] milk\n", v1.NoteType_NOTE_TYPE_CHECKLIST)
	if list.Summary.Type != v1.NoteType_NOTE_TYPE_CHECKLIST {
		t.Errorf("checklist type %v", list.Summary.Type)
	}

	// Pinning writes pinned: true and keeps the rest of the file.
	pinned, err := c.UpdateNoteMeta(ctx, connect.NewRequest(&v1.UpdateNoteMetaRequest{NotebookId: id, Path: list.Summary.Path, Pinned: proto.Bool(true)}))
	if err != nil || !pinned.Msg.Summary.Pinned || !strings.Contains(pinned.Msg.Raw, "pinned: true\n") || !strings.Contains(pinned.Msg.Raw, "- [ ] milk") {
		t.Fatalf("pin %v\n%v", err, pinned)
	}
	unpinned, _ := c.UpdateNoteMeta(ctx, connect.NewRequest(&v1.UpdateNoteMetaRequest{
		NotebookId: id, Path: list.Summary.Path, Pinned: proto.Bool(false), Type: v1.NoteType_NOTE_TYPE_MARKDOWN.Enum(),
	}))
	if unpinned.Msg.Summary.Pinned || strings.Contains(unpinned.Msg.Raw, "type:") {
		t.Errorf("unpin/untype\n%s", unpinned.Msg.Raw)
	}

	// Images go next to the note, linked relative to it.
	garden := save("ideas", "# Garden\n\nSee [[Groceries]] and [the walk](../"+journal.Summary.Path+").\n", 0)
	img, err := c.AddAttachment(ctx, connect.NewRequest(&v1.AddAttachmentRequest{
		NotebookId: id, NotePath: garden.Summary.Path, FileName: "IMG 0001.JPG", Data: []byte("jpeg"),
	}))
	if err != nil || !strings.HasPrefix(img.Msg.Path, "ideas/IMG-0001-") || !strings.HasSuffix(img.Msg.Path, ".jpg") ||
		!strings.HasPrefix(img.Msg.Markdown, "![Image](./IMG-0001-") {
		t.Fatalf("attachment %v %v", img, err)
	}
	file, err := c.GetFile(ctx, connect.NewRequest(&v1.GetFileRequest{NotebookId: id, Path: img.Msg.Path}))
	if err != nil || string(file.Msg.Data) != "jpeg" || file.Msg.MimeType != "image/jpeg" {
		t.Errorf("get file %v %v", file, err)
	}

	// Links resolve by file name, title or relative path; backlinks find them.
	for target, want := range map[string]string{
		"Groceries":                     list.Summary.Path,
		"groceries":                     list.Summary.Path,
		"../" + journal.Summary.Path:    journal.Summary.Path,
		"Garden":                        garden.Summary.Path,
		"Nope":                          "",
		"https://example.com/Garden.md": "",
	} {
		res, err := c.ResolveLink(ctx, connect.NewRequest(&v1.ResolveLinkRequest{NotebookId: id, FromPath: garden.Summary.Path, Target: target}))
		if err != nil || res.Msg.Path != want {
			t.Errorf("resolve %q: %q %v", target, res.Msg.GetPath(), err)
		}
	}
	for _, target := range []string{list.Summary.Path, journal.Summary.Path} {
		back, err := c.GetBacklinks(ctx, connect.NewRequest(&v1.GetBacklinksRequest{NotebookId: id, Path: target}))
		if err != nil || len(back.Msg.Notes) != 1 || back.Msg.Notes[0].Path != garden.Summary.Path {
			t.Errorf("backlinks of %s: %v %v", target, back, err)
		}
	}

	// A notebook outside the app's storage needs permission and an empty folder.
	target := filepath.Join(dir, "shared", "Notes")
	_, err = c.CreateNotebook(ctx, connect.NewRequest(&v1.CreateNotebookRequest{Source: &v1.CreateNotebookRequest_Empty{Empty: true}, TargetPath: target}))
	if connect.CodeOf(err) != connect.CodePermissionDenied {
		t.Errorf("target path without permission: %v", err)
	}

	all, err := c.SyncAll(ctx, connect.NewRequest(&v1.SyncAllRequest{}))
	if err != nil || len(all.Msg.Statuses) != 0 {
		t.Errorf("sync all without remotes: %v %v", all, err)
	}
}

func TestTargetPath(t *testing.T) {
	ctx := context.Background()
	dir := t.TempDir()
	svc, err := service.New(filepath.Join(dir, "data"))
	if err != nil {
		t.Fatal(err)
	}
	svc.AllowExistingPaths = true
	target := filepath.Join(dir, "shared", "Notes")
	nb, err := svc.CreateNotebook(ctx, connect.NewRequest(&v1.CreateNotebookRequest{Source: &v1.CreateNotebookRequest_Empty{Empty: true}, TargetPath: target}))
	if err != nil || nb.Msg.Path != target {
		t.Fatalf("create in target: %v %v", nb, err)
	}
	_, err = svc.CreateNotebook(ctx, connect.NewRequest(&v1.CreateNotebookRequest{Source: &v1.CreateNotebookRequest_Empty{Empty: true}, TargetPath: target}))
	if connect.CodeOf(err) != connect.CodeAlreadyExists {
		t.Errorf("non-empty target: %v", err)
	}
	// Removing it forgets the notebook but keeps the folder.
	if _, err := svc.DeleteNotebook(ctx, connect.NewRequest(&v1.DeleteNotebookRequest{Id: nb.Msg.Id, DeleteFiles: true})); err != nil {
		t.Fatal(err)
	}
	if _, err := os.Stat(filepath.Join(target, ".git")); err != nil {
		t.Errorf("shared folder deleted: %v", err)
	}
}
