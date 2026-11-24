package service

import (
	"context"
	"log"
	"time"

	"connectrpc.com/connect"
	"google.golang.org/protobuf/proto"

	v1 "github.com/kvth/githeft/gen/githeft/v1"
	"github.com/kvth/githeft/internal/config"
	"github.com/kvth/githeft/internal/gitsync"
)

func signature(nb config.Notebook) gitsync.Signature {
	return gitsync.Signature{Name: nb.Author.Name, Email: nb.Author.Email}
}

func (b *book) currentStatus() *v1.SyncStatus {
	b.statusMu.Lock()
	defer b.statusMu.Unlock()
	if b.status == nil {
		return &v1.SyncStatus{State: v1.SyncState_SYNC_STATE_IDLE}
	}
	return proto.Clone(b.status).(*v1.SyncStatus)
}

func (b *book) setStatus(update func(*v1.SyncStatus)) {
	b.statusMu.Lock()
	defer b.statusMu.Unlock()
	if b.status == nil {
		b.status = &v1.SyncStatus{State: v1.SyncState_SYNC_STATE_IDLE}
	}
	update(b.status)
}

// fill adds the counts that come from the repository itself.
func (b *book) fill(st *v1.SyncStatus, nb config.Notebook) *v1.SyncStatus {
	if nb.Remote == nil && st.State != v1.SyncState_SYNC_STATE_SYNCING {
		st.State = v1.SyncState_SYNC_STATE_LOCAL_ONLY
	}
	if pending, err := b.repo.Pending(); err == nil {
		st.PendingChanges = int32(len(pending))
	}
	if nb.Remote != nil {
		st.Ahead = int32(b.repo.Ahead())
	}
	return st
}

func (s *Service) Sync(ctx context.Context, req *connect.Request[v1.SyncRequest]) (*connect.Response[v1.SyncStatus], error) {
	nb, b, err := s.notebook(req.Msg.NotebookId)
	if err != nil {
		return nil, err
	}
	if nb.Remote == nil {
		if _, err := b.repo.CommitAll("", signature(nb)); err != nil {
			return nil, err
		}
		return ok(b.fill(b.currentStatus(), nb))
	}
	remote, err := s.remote(nb.Remote)
	if err != nil {
		return nil, err
	}
	b.setStatus(func(st *v1.SyncStatus) { st.State = v1.SyncState_SYNC_STATE_SYNCING })

	// A sync that started keeps going when the app stops waiting for it.
	ctx, cancel := context.WithTimeout(context.WithoutCancel(ctx), 5*time.Minute)
	defer cancel()
	start := time.Now()
	res, err := b.repo.Sync(ctx, remote, signature(nb))
	b.setStatus(func(st *v1.SyncStatus) {
		st.ChangedPaths, st.Conflicts = res.Changed, res.Conflicts
		if err != nil {
			st.State, st.Error = v1.SyncState_SYNC_STATE_ERROR, gitError(err).Error()
			return
		}
		st.State, st.Error, st.LastSync = v1.SyncState_SYNC_STATE_IDLE, "", time.Now().Unix()
	})
	if err != nil {
		log.Printf("sync %s failed after %s: %v", nb.Name, time.Since(start).Round(time.Millisecond), err)
	} else {
		log.Printf("sync %s: %d changed, %d conflicts, %s", nb.Name, len(res.Changed), len(res.Conflicts), time.Since(start).Round(time.Millisecond))
	}
	// The status carries the error; the call itself succeeds so the app can
	// show what happened.
	return ok(b.fill(b.currentStatus(), nb))
}

func (s *Service) GetSyncStatus(ctx context.Context, req *connect.Request[v1.GetSyncStatusRequest]) (*connect.Response[v1.SyncStatus], error) {
	nb, b, err := s.notebook(req.Msg.NotebookId)
	if err != nil {
		return nil, err
	}
	return ok(b.fill(b.currentStatus(), nb))
}

// SyncAll syncs every notebook with a remote and automatic sync, one after
// the other. The background job (Android WorkManager, systemd timer) uses it.
func (s *Service) SyncAll(ctx context.Context, req *connect.Request[v1.SyncAllRequest]) (*connect.Response[v1.SyncAllResponse], error) {
	s.mu.Lock()
	var ids []string
	for _, nb := range s.cfg.Notebooks {
		if nb.AutoSync && nb.Remote != nil {
			ids = append(ids, nb.ID)
		}
	}
	s.mu.Unlock()
	res := &v1.SyncAllResponse{Statuses: map[string]*v1.SyncStatus{}}
	for _, id := range ids {
		st, err := s.Sync(ctx, connect.NewRequest(&v1.SyncRequest{NotebookId: id}))
		if err != nil {
			res.Statuses[id] = &v1.SyncStatus{State: v1.SyncState_SYNC_STATE_ERROR, Error: err.Error()}
			continue
		}
		res.Statuses[id] = st.Msg
	}
	return ok(res)
}
