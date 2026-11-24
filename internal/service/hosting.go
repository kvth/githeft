package service

import (
	"context"
	"errors"
	"time"

	"connectrpc.com/connect"

	v1 "github.com/kvth/githeft/gen/githeft/v1"
	"github.com/kvth/githeft/internal/hosting"
)

func host(kind v1.HostKind, baseURL, token string) (hosting.Host, error) {
	h := hosting.Host{BaseURL: baseURL, Token: token}
	switch kind {
	case v1.HostKind_HOST_KIND_GITHUB:
		h.Kind = hosting.GitHub
	case v1.HostKind_HOST_KIND_GITLAB:
		h.Kind = hosting.GitLab
	case v1.HostKind_HOST_KIND_GITEA:
		h.Kind = hosting.Gitea
	default:
		return h, invalid("choose a host")
	}
	return h, nil
}

func account(a *v1.HostAccount) (hosting.Host, error) {
	if a == nil {
		return hosting.Host{}, invalid("no account")
	}
	if a.Token == "" {
		return hosting.Host{}, invalid("sign in or enter an access token")
	}
	return host(a.Kind, a.BaseUrl, a.Token)
}

func hostError(err error) error {
	switch {
	case errors.Is(err, hosting.ErrUnauthorized):
		return connect.NewError(connect.CodePermissionDenied, err)
	case errors.Is(err, hosting.ErrNotFound):
		return connect.NewError(connect.CodeNotFound, err)
	case errors.Is(err, hosting.ErrExists):
		return connect.NewError(connect.CodeAlreadyExists, err)
	case errors.Is(err, hosting.ErrNoDeviceFlow):
		return connect.NewError(connect.CodeFailedPrecondition, err)
	}
	return gitError(err)
}

func repoToProto(r hosting.Repo) *v1.HostRepo {
	var updated int64
	if !r.Updated.IsZero() {
		updated = r.Updated.Unix()
	}
	return &v1.HostRepo{
		FullName: r.FullName, SshUrl: r.SSHURL, HttpsUrl: r.HTTPSURL,
		Private: r.Private, Description: r.Description, Updated: updated,
	}
}

func (s *Service) HostInfo(ctx context.Context, req *connect.Request[v1.HostInfoRequest]) (*connect.Response[v1.HostInfoResponse], error) {
	h, err := host(req.Msg.Kind, req.Msg.BaseUrl, "")
	if err != nil {
		return nil, err
	}
	url, hint := h.TokenURL()
	return ok(&v1.HostInfoResponse{DeviceLogin: h.DeviceLogin(), TokenUrl: url, TokenHint: hint})
}

func (s *Service) HostLoginStart(ctx context.Context, req *connect.Request[v1.HostLoginStartRequest]) (*connect.Response[v1.HostLoginStartResponse], error) {
	h, err := host(req.Msg.Kind, req.Msg.BaseUrl, "")
	if err != nil {
		return nil, err
	}
	dc, err := h.StartLogin(ctx)
	if err != nil {
		return nil, hostError(err)
	}
	return ok(&v1.HostLoginStartResponse{
		DeviceCode: dc.DeviceCode, UserCode: dc.UserCode, VerificationUrl: dc.VerificationURI,
		Interval: int32(dc.Interval), ExpiresIn: int32(dc.ExpiresIn),
	})
}

func (s *Service) HostLoginPoll(ctx context.Context, req *connect.Request[v1.HostLoginPollRequest]) (*connect.Response[v1.HostLoginPollResponse], error) {
	h, err := host(req.Msg.Kind, req.Msg.BaseUrl, "")
	if err != nil {
		return nil, err
	}
	token, interval, err := h.PollLogin(ctx, req.Msg.DeviceCode)
	if errors.Is(err, hosting.ErrPending) {
		return ok(&v1.HostLoginPollResponse{Pending: true, Interval: int32(interval)})
	}
	if err != nil {
		return nil, hostError(err)
	}
	return ok(&v1.HostLoginPollResponse{Token: token})
}

func (s *Service) HostListRepos(ctx context.Context, req *connect.Request[v1.HostListReposRequest]) (*connect.Response[v1.HostListReposResponse], error) {
	h, err := account(req.Msg.Account)
	if err != nil {
		return nil, err
	}
	ctx, cancel := context.WithTimeout(ctx, 2*time.Minute)
	defer cancel()
	user, err := h.User(ctx)
	if err != nil {
		return nil, hostError(err)
	}
	repos, err := h.Repos(ctx)
	if err != nil {
		return nil, hostError(err)
	}
	res := &v1.HostListReposResponse{User: user}
	for _, r := range repos {
		res.Repos = append(res.Repos, repoToProto(r))
	}
	return ok(res)
}

func (s *Service) HostCreateRepo(ctx context.Context, req *connect.Request[v1.HostCreateRepoRequest]) (*connect.Response[v1.HostRepo], error) {
	h, err := account(req.Msg.Account)
	if err != nil {
		return nil, err
	}
	r, err := h.CreateRepo(ctx, req.Msg.Name, req.Msg.Private)
	if err != nil {
		return nil, hostError(err)
	}
	return ok(repoToProto(r))
}

func (s *Service) HostAddDeployKey(ctx context.Context, req *connect.Request[v1.HostAddDeployKeyRequest]) (*connect.Response[v1.HostAddDeployKeyResponse], error) {
	h, err := account(req.Msg.Account)
	if err != nil {
		return nil, err
	}
	if req.Msg.FullName == "" || req.Msg.PublicKey == "" {
		return nil, invalid("repository and key are needed")
	}
	title := req.Msg.Title
	if title == "" {
		title = "Githeft"
	}
	if err := h.AddDeployKey(ctx, req.Msg.FullName, title, req.Msg.PublicKey); err != nil {
		return nil, hostError(err)
	}
	return ok(&v1.HostAddDeployKeyResponse{})
}
