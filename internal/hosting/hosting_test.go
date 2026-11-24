package hosting

import (
	"context"
	"encoding/json"
	"errors"
	"io"
	"net/http"
	"net/http/httptest"
	"net/url"
	"strings"
	"sync"
	"testing"
)

// fakeHost answers the API calls of one host kind like the real one does.
type fakeHost struct {
	kind  Kind
	token string
	mu    sync.Mutex
	repos []string
	keys  map[string]string
	polls int
}

func (f *fakeHost) authorized(r *http.Request) bool {
	want := "Bearer " + f.token
	if f.kind == Gitea {
		want = "token " + f.token
	}
	return r.Header.Get("Authorization") == want
}

func (f *fakeHost) ServeHTTP(w http.ResponseWriter, r *http.Request) {
	f.mu.Lock()
	defer f.mu.Unlock()
	reply := func(code int, v any) {
		w.Header().Set("Content-Type", "application/json")
		w.WriteHeader(code)
		json.NewEncoder(w).Encode(v)
	}
	body, _ := io.ReadAll(r.Body)
	p := r.URL.Path
	switch {
	case p == "/login/device/code" || p == "/oauth/authorize_device":
		form, _ := url.ParseQuery(string(body))
		if form.Get("client_id") != "client" {
			reply(400, map[string]string{"error": "invalid_client"})
			return
		}
		reply(200, map[string]any{"device_code": "dev", "user_code": "ABCD-1234", "verification_uri": "https://host/device", "expires_in": 900, "interval": 1})
		return
	case p == "/login/oauth/access_token" || p == "/oauth/token":
		f.polls++
		if f.polls == 1 {
			reply(200, map[string]string{"error": "authorization_pending"})
			return
		}
		reply(200, map[string]string{"access_token": f.token})
		return
	}
	if !f.authorized(r) {
		reply(401, map[string]string{"message": "Bad credentials"})
		return
	}
	api := map[Kind]string{GitHub: "/api/v3", GitLab: "/api/v4", Gitea: "/api/v1"}[f.kind]
	p = strings.TrimPrefix(p, api)
	switch {
	case p == "/user":
		reply(200, map[string]string{"login": "kevin", "username": "kevin"})
	case r.Method == "GET" && (p == "/user/repos" || p == "/projects"):
		var list []map[string]any
		for _, name := range f.repos {
			list = append(list, map[string]any{
				"full_name": "kevin/" + name, "ssh_url": "git@host:kevin/" + name + ".git", "clone_url": "https://host/kevin/" + name + ".git",
				"path_with_namespace": "kevin/" + name, "ssh_url_to_repo": "git@host:kevin/" + name + ".git", "visibility": "private",
				"private": true, "updated_at": "2026-11-20T10:00:00Z", "last_activity_at": "2026-11-20T10:00:00Z",
			})
		}
		if r.URL.Query().Get("page") != "1" {
			list = nil
		}
		reply(200, list)
	case r.Method == "POST" && (p == "/user/repos" || p == "/projects"):
		var req map[string]any
		json.Unmarshal(body, &req)
		name := req["name"].(string)
		for _, n := range f.repos {
			if n == name {
				reply(422, map[string]any{"message": "Repository creation failed.", "errors": []map[string]string{{"message": "name already exists on this account"}}})
				return
			}
		}
		f.repos = append(f.repos, name)
		reply(201, map[string]any{"full_name": "kevin/" + name, "ssh_url": "git@host:kevin/" + name + ".git",
			"path_with_namespace": "kevin/" + name, "ssh_url_to_repo": "git@host:kevin/" + name + ".git", "visibility": "private", "private": true})
	case r.Method == "POST" && (strings.HasSuffix(p, "/keys") || strings.HasSuffix(p, "/deploy_keys")):
		var req map[string]any
		json.Unmarshal(body, &req)
		if f.kind == GitLab && req["can_push"] != true || f.kind != GitLab && req["read_only"] != false {
			reply(400, map[string]string{"message": "key without write access"})
			return
		}
		f.keys[p] = req["key"].(string)
		reply(201, map[string]any{"id": 1})
	default:
		reply(404, map[string]string{"message": "Not Found"})
	}
}

func TestHosts(t *testing.T) {
	ctx := context.Background()
	for _, kind := range []Kind{GitHub, GitLab, Gitea} {
		fake := &fakeHost{kind: kind, token: "secret", repos: []string{"notes"}, keys: map[string]string{}}
		srv := httptest.NewServer(fake)
		h := Host{Kind: kind, BaseURL: srv.URL, Token: "secret"}

		if _, err := (Host{Kind: kind, BaseURL: srv.URL, Token: "wrong"}).User(ctx); !errors.Is(err, ErrUnauthorized) {
			t.Errorf("%v: wrong token: %v", kind, err)
		}
		if u, err := h.User(ctx); err != nil || u != "kevin" {
			t.Errorf("%v: user %q %v", kind, u, err)
		}
		repos, err := h.Repos(ctx)
		if err != nil || len(repos) != 1 || repos[0].FullName != "kevin/notes" || repos[0].SSHURL == "" || !repos[0].Private {
			t.Errorf("%v: repos %+v %v", kind, repos, err)
		}
		if _, err := h.CreateRepo(ctx, "notes", true); !errors.Is(err, ErrExists) {
			t.Errorf("%v: duplicate repo: %v", kind, err)
		}
		r, err := h.CreateRepo(ctx, "journal", true)
		if err != nil || r.FullName != "kevin/journal" {
			t.Errorf("%v: create %+v %v", kind, r, err)
		}
		if err := h.AddDeployKey(ctx, "kevin/journal", "Githeft", "ssh-ed25519 AAAA test"); err != nil || len(fake.keys) != 1 {
			t.Errorf("%v: deploy key %v %v", kind, err, fake.keys)
		}
		srv.Close()
	}
}

func TestDeviceLogin(t *testing.T) {
	ctx := context.Background()
	for _, kind := range []Kind{GitHub, GitLab} {
		fake := &fakeHost{kind: kind, token: "granted", keys: map[string]string{}}
		srv := httptest.NewServer(fake)
		h := Host{Kind: kind, BaseURL: srv.URL}
		if h.DeviceLogin() {
			t.Fatalf("%v: device login without client id", kind)
		}
		env := map[Kind]string{GitHub: "GITHEFT_GITHUB_CLIENT_ID", GitLab: "GITHEFT_GITLAB_CLIENT_ID"}[kind]
		t.Setenv(env, "client")
		dc, err := h.StartLogin(ctx)
		if err != nil || dc.UserCode != "ABCD-1234" {
			t.Fatalf("%v: start %+v %v", kind, dc, err)
		}
		if _, _, err := h.PollLogin(ctx, dc.DeviceCode); !errors.Is(err, ErrPending) {
			t.Errorf("%v: first poll %v", kind, err)
		}
		if token, _, err := h.PollLogin(ctx, dc.DeviceCode); err != nil || token != "granted" {
			t.Errorf("%v: token %q %v", kind, token, err)
		}
		srv.Close()
	}
	if (Host{Kind: Gitea}).DeviceLogin() {
		t.Error("Gitea has no device flow")
	}
}
