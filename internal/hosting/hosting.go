// Package hosting talks to the APIs of git hosts to set up a notebook in one
// go: sign in, list or create a repository and add the device's SSH key as a
// deploy key. GitHub, GitLab and Gitea/Forgejo (Codeberg) are supported.
//
// Signing in with a code in the browser (OAuth device flow) needs an OAuth
// app registered with the host; its client ID is set at build time with
//
//	-ldflags "-X github.com/kvth/githeft/internal/hosting.GitHubClientID=…"
//
// or with $GITHEFT_GITHUB_CLIENT_ID / $GITHEFT_GITLAB_CLIENT_ID. Without one,
// the user pastes an access token instead.
package hosting

import (
	"context"
	"encoding/json"
	"errors"
	"fmt"
	"io"
	"net/http"
	"net/url"
	"os"
	"strings"
	"time"
)

// OAuth client IDs for the device flow on github.com and gitlab.com.
var (
	GitHubClientID string
	GitLabClientID string
)

type Kind int

const (
	GitHub Kind = iota + 1
	GitLab
	Gitea
)

// Host is one git host, with or without a token.
type Host struct {
	Kind Kind
	// BaseURL is the web address, e.g. https://codeberg.org; empty for the
	// public instance.
	BaseURL string
	Token   string
	Client  *http.Client
}

// Repo is a repository on the host.
type Repo struct {
	FullName    string
	SSHURL      string
	HTTPSURL    string
	Private     bool
	Description string
	Updated     time.Time
}

// Errors the caller tells apart.
var (
	ErrUnauthorized = errors.New("the host did not accept the token")
	ErrNotFound     = errors.New("not found on the host")
	ErrExists       = errors.New("already exists on the host")
	ErrNoDeviceFlow = errors.New("signing in through the browser is not set up for this host; create an access token instead")
)

func (h Host) base() string {
	if h.BaseURL != "" {
		return strings.TrimRight(h.BaseURL, "/")
	}
	switch h.Kind {
	case GitHub:
		return "https://github.com"
	case GitLab:
		return "https://gitlab.com"
	default:
		return "https://codeberg.org"
	}
}

func (h Host) api() string {
	switch h.Kind {
	case GitHub:
		if h.BaseURL == "" {
			return "https://api.github.com"
		}
		return h.base() + "/api/v3" // GitHub Enterprise Server
	case GitLab:
		return h.base() + "/api/v4"
	default:
		return h.base() + "/api/v1"
	}
}

func (h Host) client() *http.Client {
	if h.Client != nil {
		return h.Client
	}
	return &http.Client{Timeout: 30 * time.Second}
}

// clientID returns the OAuth client ID for the device flow, or "".
func (h Host) clientID() string {
	switch {
	case h.Kind == GitHub && h.BaseURL == "":
		return firstOf(os.Getenv("GITHEFT_GITHUB_CLIENT_ID"), GitHubClientID)
	case h.Kind == GitLab && h.BaseURL == "":
		return firstOf(os.Getenv("GITHEFT_GITLAB_CLIENT_ID"), GitLabClientID)
	case h.Kind == GitHub || h.Kind == GitLab:
		// Self-hosted: only with an app registered there, given by env.
		if h.Kind == GitHub {
			return os.Getenv("GITHEFT_GITHUB_CLIENT_ID")
		}
		return os.Getenv("GITHEFT_GITLAB_CLIENT_ID")
	}
	return ""
}

func firstOf(s ...string) string {
	for _, v := range s {
		if v != "" {
			return v
		}
	}
	return ""
}

// DeviceLogin reports whether signing in through the browser works.
func (h Host) DeviceLogin() bool { return h.clientID() != "" }

// TokenURL is where the user creates an access token, with the scopes
// Githeft needs preselected where the host allows that, and what to pick.
func (h Host) TokenURL() (string, string) {
	switch h.Kind {
	case GitHub:
		return h.base() + "/settings/tokens/new?scopes=repo&description=Githeft",
			"A classic token with the \"repo\" scope lets Githeft list and create repositories and add the deploy key. It is only used during the setup."
	case GitLab:
		return h.base() + "/-/user_settings/personal_access_tokens?name=Githeft&scopes=api",
			"A token with the \"api\" scope lets Githeft list and create projects and add the deploy key. It is only used during the setup."
	default:
		return h.base() + "/user/settings/applications",
			"Generate a token with read and write access to repositories and read access to the user. It is only used during the setup."
	}
}

func (h Host) do(ctx context.Context, method, path string, body any, out any) error {
	var rd io.Reader
	if body != nil {
		data, err := json.Marshal(body)
		if err != nil {
			return err
		}
		rd = strings.NewReader(string(data))
	}
	req, err := http.NewRequestWithContext(ctx, method, h.api()+path, rd)
	if err != nil {
		return err
	}
	req.Header.Set("Accept", "application/json")
	if body != nil {
		req.Header.Set("Content-Type", "application/json")
	}
	switch h.Kind {
	case GitHub:
		req.Header.Set("Authorization", "Bearer "+h.Token)
		req.Header.Set("Accept", "application/vnd.github+json")
		req.Header.Set("X-GitHub-Api-Version", "2022-11-28")
	case GitLab:
		req.Header.Set("Authorization", "Bearer "+h.Token)
	default:
		req.Header.Set("Authorization", "token "+h.Token)
	}
	resp, err := h.client().Do(req)
	if err != nil {
		return err
	}
	defer resp.Body.Close()
	data, _ := io.ReadAll(io.LimitReader(resp.Body, 10<<20))
	if resp.StatusCode >= 300 {
		return statusError(resp.StatusCode, data)
	}
	if out == nil {
		return nil
	}
	return json.Unmarshal(data, out)
}

func statusError(code int, body []byte) error {
	var msg struct {
		Message any `json:"message"`
		Errors  []struct {
			Message string `json:"message"`
		} `json:"errors"`
	}
	json.Unmarshal(body, &msg)
	text := fmt.Sprint(msg.Message)
	if msg.Message == nil {
		text = strings.TrimSpace(string(body))
	}
	for _, e := range msg.Errors {
		if e.Message != "" {
			text += ": " + e.Message
		}
	}
	if len(text) > 300 {
		text = text[:300]
	}
	switch {
	case code == http.StatusUnauthorized:
		return fmt.Errorf("%w (%s)", ErrUnauthorized, text)
	case code == http.StatusForbidden:
		return fmt.Errorf("%w: the token lacks a permission (%s)", ErrUnauthorized, text)
	case code == http.StatusNotFound:
		return fmt.Errorf("%w (%s)", ErrNotFound, text)
	case code == http.StatusConflict, code == http.StatusUnprocessableEntity,
		code == http.StatusBadRequest && strings.Contains(strings.ToLower(text), "taken"):
		return fmt.Errorf("%w (%s)", ErrExists, text)
	}
	return fmt.Errorf("the host answered %d: %s", code, text)
}

// User returns the name of the signed-in user.
func (h Host) User(ctx context.Context) (string, error) {
	var u struct {
		Login    string `json:"login"`
		Username string `json:"username"`
	}
	if err := h.do(ctx, "GET", "/user", nil, &u); err != nil {
		return "", err
	}
	return firstOf(u.Login, u.Username), nil
}

type githubRepo struct {
	FullName    string    `json:"full_name"`
	SSHURL      string    `json:"ssh_url"`
	CloneURL    string    `json:"clone_url"`
	Private     bool      `json:"private"`
	Description string    `json:"description"`
	UpdatedAt   time.Time `json:"updated_at"`
}

func (r githubRepo) repo() Repo {
	return Repo{r.FullName, r.SSHURL, r.CloneURL, r.Private, r.Description, r.UpdatedAt}
}

type gitlabProject struct {
	PathWithNamespace string    `json:"path_with_namespace"`
	SSHURL            string    `json:"ssh_url_to_repo"`
	HTTPURL           string    `json:"http_url_to_repo"`
	Visibility        string    `json:"visibility"`
	Description       string    `json:"description"`
	LastActivityAt    time.Time `json:"last_activity_at"`
}

func (p gitlabProject) repo() Repo {
	return Repo{p.PathWithNamespace, p.SSHURL, p.HTTPURL, p.Visibility != "public", p.Description, p.LastActivityAt}
}

// Repos lists the repositories the user can write to, most recently
// changed first (up to a few hundred).
func (h Host) Repos(ctx context.Context) ([]Repo, error) {
	var out []Repo
	for page := 1; page <= 5; page++ {
		var n int
		switch h.Kind {
		case GitHub:
			var list []githubRepo
			if err := h.do(ctx, "GET", fmt.Sprintf("/user/repos?per_page=100&sort=updated&affiliation=owner,collaborator,organization_member&page=%d", page), nil, &list); err != nil {
				return nil, err
			}
			for _, r := range list {
				out = append(out, r.repo())
			}
			n = len(list)
		case GitLab:
			var list []gitlabProject
			if err := h.do(ctx, "GET", fmt.Sprintf("/projects?membership=true&min_access_level=30&order_by=last_activity_at&simple=true&per_page=100&page=%d", page), nil, &list); err != nil {
				return nil, err
			}
			for _, p := range list {
				out = append(out, p.repo())
			}
			n = len(list)
		default:
			var list []githubRepo // Gitea uses the same field names
			if err := h.do(ctx, "GET", fmt.Sprintf("/user/repos?limit=50&page=%d", page), nil, &list); err != nil {
				return nil, err
			}
			for _, r := range list {
				out = append(out, r.repo())
			}
			n = len(list)
		}
		if n == 0 || (h.Kind == Gitea && n < 50) || (h.Kind != Gitea && n < 100) {
			break
		}
	}
	return out, nil
}

// CreateRepo creates an empty repository of the user.
func (h Host) CreateRepo(ctx context.Context, name string, private bool) (Repo, error) {
	name = strings.TrimSpace(name)
	if name == "" {
		return Repo{}, errors.New("the repository needs a name")
	}
	switch h.Kind {
	case GitLab:
		visibility := "public"
		if private {
			visibility = "private"
		}
		var p gitlabProject
		err := h.do(ctx, "POST", "/projects", map[string]any{"name": name, "visibility": visibility}, &p)
		return p.repo(), err
	default:
		var r githubRepo
		err := h.do(ctx, "POST", "/user/repos", map[string]any{"name": name, "private": private, "auto_init": false}, &r)
		return r.repo(), err
	}
}

// AddDeployKey gives a public key write access to one repository.
func (h Host) AddDeployKey(ctx context.Context, fullName, title, publicKey string) error {
	switch h.Kind {
	case GitLab:
		return h.do(ctx, "POST", "/projects/"+url.PathEscape(fullName)+"/deploy_keys",
			map[string]any{"title": title, "key": publicKey, "can_push": true}, nil)
	default:
		return h.do(ctx, "POST", "/repos/"+fullName+"/keys",
			map[string]any{"title": title, "key": publicKey, "read_only": false}, nil)
	}
}

// DeviceCode is a started browser sign-in.
type DeviceCode struct {
	DeviceCode      string `json:"device_code"`
	UserCode        string `json:"user_code"`
	VerificationURI string `json:"verification_uri"`
	ExpiresIn       int    `json:"expires_in"`
	Interval        int    `json:"interval"`
}

func (h Host) oauth(ctx context.Context, path string, form url.Values, out any) error {
	req, err := http.NewRequestWithContext(ctx, "POST", h.base()+path, strings.NewReader(form.Encode()))
	if err != nil {
		return err
	}
	req.Header.Set("Content-Type", "application/x-www-form-urlencoded")
	req.Header.Set("Accept", "application/json")
	resp, err := h.client().Do(req)
	if err != nil {
		return err
	}
	defer resp.Body.Close()
	data, _ := io.ReadAll(io.LimitReader(resp.Body, 1<<20))
	if err := json.Unmarshal(data, out); err != nil {
		return statusError(resp.StatusCode, data)
	}
	return nil
}

// StartLogin starts the OAuth device flow: the user opens VerificationURI
// and enters UserCode.
func (h Host) StartLogin(ctx context.Context) (DeviceCode, error) {
	id := h.clientID()
	if id == "" {
		return DeviceCode{}, ErrNoDeviceFlow
	}
	var dc struct {
		DeviceCode
		Error string `json:"error"`
		Desc  string `json:"error_description"`
	}
	form := url.Values{"client_id": {id}}
	path := "/login/device/code"
	form.Set("scope", "repo")
	if h.Kind == GitLab {
		path = "/oauth/authorize_device"
		form.Set("scope", "api")
	}
	if err := h.oauth(ctx, path, form, &dc); err != nil {
		return DeviceCode{}, err
	}
	if dc.Error != "" || dc.DeviceCode.DeviceCode == "" {
		return DeviceCode{}, fmt.Errorf("the host refused the sign-in: %s %s", dc.Error, dc.Desc)
	}
	if dc.Interval == 0 {
		dc.Interval = 5
	}
	return dc.DeviceCode, nil
}

// ErrPending means the user has not approved the sign-in yet.
var ErrPending = errors.New("waiting for the sign-in in the browser")

// PollLogin returns the token once the user approved. While waiting it
// returns ErrPending and the interval to wait before the next poll.
func (h Host) PollLogin(ctx context.Context, deviceCode string) (token string, interval int, err error) {
	id := h.clientID()
	if id == "" {
		return "", 0, ErrNoDeviceFlow
	}
	var res struct {
		AccessToken string `json:"access_token"`
		Error       string `json:"error"`
		Desc        string `json:"error_description"`
		Interval    int    `json:"interval"`
	}
	form := url.Values{
		"client_id":   {id},
		"device_code": {deviceCode},
		"grant_type":  {"urn:ietf:params:oauth:grant-type:device_code"},
	}
	path := "/login/oauth/access_token"
	if h.Kind == GitLab {
		path = "/oauth/token"
	}
	if err := h.oauth(ctx, path, form, &res); err != nil {
		return "", 0, err
	}
	switch res.Error {
	case "":
		if res.AccessToken == "" {
			return "", 0, errors.New("the host sent no token")
		}
		return res.AccessToken, 0, nil
	case "authorization_pending":
		return "", res.Interval, ErrPending
	case "slow_down":
		return "", max(res.Interval, 10), ErrPending
	case "expired_token":
		return "", 0, errors.New("the code expired; start the sign-in again")
	case "access_denied":
		return "", 0, errors.New("the sign-in was cancelled")
	}
	return "", 0, fmt.Errorf("sign-in failed: %s %s", res.Error, res.Desc)
}
