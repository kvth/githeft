import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

import '../gen/githeft/v1/githeft.pbgrpc.dart';
import '../platform/platform.dart';
import '../state.dart';
import '../widgets/storage_location.dart';
import 'setup_screen.dart' show AuthorFields;

/// One-tap setup with GitHub, GitLab or a Gitea/Forgejo host: sign in, pick
/// or create a repository, and Githeft generates an SSH key, adds it to the
/// repository as a deploy key and clones it. The token is only used for the
/// setup unless HTTPS sync is chosen.
class HostSetupScreen extends StatefulWidget {
  const HostSetupScreen({super.key});

  @override
  State<HostSetupScreen> createState() => _HostSetupScreenState();
}

class _HostSetupScreenState extends State<HostSetupScreen> {
  HostKind _kind = HostKind.HOST_KIND_GITHUB;
  final _baseUrl = TextEditingController();
  final _token = TextEditingController();
  final _filter = TextEditingController();
  final _newRepo = TextEditingController(text: 'notes');
  final _authorName = TextEditingController();
  final _authorEmail = TextEditingController();
  final _storage = StorageLocationController();

  HostInfoResponse? _info;
  HostLoginStartResponse? _login;
  String? _user;
  List<HostRepo>? _repos;
  HostRepo? _repo;
  bool _private = true;
  bool _https = false;
  bool _selfHosted = false;
  String? _error, _busy;
  int _loginRun = 0;

  @override
  void initState() {
    super.initState();
    AuthorFields.prefill(_authorName, _authorEmail);
    WidgetsBinding.instance.addPostFrameCallback((_) => _loadInfo());
  }

  @override
  void dispose() {
    _loginRun++;
    for (final c in [_baseUrl, _token, _filter, _newRepo, _authorName, _authorEmail]) {
      c.dispose();
    }
    _storage.dispose();
    super.dispose();
  }

  GitheftClient get _api => AppScope.read(context).api;

  String get _hostName => switch (_kind) {
    HostKind.HOST_KIND_GITHUB => 'GitHub',
    HostKind.HOST_KIND_GITLAB => 'GitLab',
    _ => _selfHosted ? 'Gitea/Forgejo' : 'Codeberg',
  };

  String get _base => _selfHosted ? _baseUrl.text.trim() : '';

  HostAccount get _account => HostAccount(kind: _kind, baseUrl: _base, token: _token.text.trim());

  Future<void> _loadInfo() async {
    try {
      final info = await _api.hostInfo(HostInfoRequest(kind: _kind, baseUrl: _base));
      if (mounted) setState(() => _info = info);
    } catch (e) {
      if (mounted) setState(() => _error = errorText(e));
    }
  }

  void _changeHost(HostKind kind) {
    _loginRun++;
    setState(() {
      _kind = kind;
      _info = null;
      _login = null;
      _user = null;
      _repos = null;
      _repo = null;
      _error = null;
    });
    _loadInfo();
  }

  /// Browser sign-in: show the code, open the page, wait for the approval.
  Future<void> _deviceLogin() async {
    final run = ++_loginRun;
    setState(() {
      _error = null;
      _busy = null;
    });
    try {
      final login = await _api.hostLoginStart(HostLoginStartRequest(kind: _kind, baseUrl: _base));
      if (!mounted || run != _loginRun) return;
      setState(() => _login = login);
      await Clipboard.setData(ClipboardData(text: login.userCode));
      unawaited(launchUrl(Uri.parse(login.verificationUrl), mode: LaunchMode.externalApplication));
      var interval = login.interval > 0 ? login.interval : 5;
      final deadline = DateTime.now().add(Duration(seconds: login.expiresIn > 0 ? login.expiresIn : 900));
      while (DateTime.now().isBefore(deadline)) {
        await Future<void>.delayed(Duration(seconds: interval));
        if (!mounted || run != _loginRun) return;
        final res = await _api.hostLoginPoll(
          HostLoginPollRequest(kind: _kind, baseUrl: _base, deviceCode: login.deviceCode),
        );
        if (res.pending) {
          if (res.interval > 0) interval = res.interval;
          continue;
        }
        _token.text = res.token;
        setState(() => _login = null);
        await _loadRepos();
        return;
      }
      throw StateError('The code expired; start again.');
    } catch (e) {
      if (mounted && run == _loginRun) {
        setState(() {
          _login = null;
          _error = errorText(e);
        });
      }
    }
  }

  Future<void> _loadRepos() async {
    setState(() {
      _error = null;
      _busy = 'Loading repositories…';
    });
    try {
      final res = await _api.hostListRepos(HostListReposRequest(account: _account));
      if (!mounted) return;
      setState(() {
        _user = res.user;
        _repos = res.repos;
      });
    } catch (e) {
      if (mounted) setState(() => _error = errorText(e));
    } finally {
      if (mounted) setState(() => _busy = null);
    }
  }

  Future<void> _createRepo() async {
    setState(() {
      _error = null;
      _busy = 'Creating ${_newRepo.text.trim()}…';
    });
    try {
      final repo = await _api.hostCreateRepo(
        HostCreateRepoRequest(account: _account, name: _newRepo.text.trim(), private: _private),
      );
      if (!mounted) return;
      setState(() {
        _repos = [repo, ...?_repos];
        _repo = repo;
      });
    } catch (e) {
      if (mounted) setState(() => _error = errorText(e));
    } finally {
      if (mounted) setState(() => _busy = null);
    }
  }

  /// Key, deploy key, clone.
  Future<void> _setUp() async {
    final repo = _repo!;
    final state = AppScope.read(context);
    setState(() => _error = null);
    try {
      await AuthorFields.remember(_authorName.text.trim(), _authorEmail.text.trim());
      Remote remote;
      if (_https) {
        remote = Remote(
          url: repo.httpsUrl,
          authType: AuthType.AUTH_TYPE_HTTPS,
          username: _user ?? '',
          password: _token.text.trim(),
        );
      } else {
        setState(() => _busy = 'Generating an SSH key…');
        final device = Device.isAndroid ? 'Android' : (Device.isLinux ? 'Linux' : 'web');
        final key = await state.api.generateSshKey(GenerateSshKeyRequest(comment: 'githeft@$device'));
        setState(() => _busy = 'Adding it to ${repo.fullName} as a deploy key…');
        await state.api.hostAddDeployKey(
          HostAddDeployKeyRequest(
            account: _account,
            fullName: repo.fullName,
            title: 'Githeft ($device, ${DateTime.now().toIso8601String().substring(0, 10)})',
            publicKey: key.publicKey,
          ),
        );
        remote = Remote(url: repo.sshUrl, authType: AuthType.AUTH_TYPE_SSH, sshKeyId: key.id);
      }
      setState(() => _busy = 'Cloning ${repo.fullName}…');
      final nb = await state.api.createNotebook(
        CreateNotebookRequest(
          name: repo.fullName.split('/').last,
          cloneRemote: remote,
          targetPath: _storage.targetPath,
          author: Author(name: _authorName.text.trim(), email: _authorEmail.text.trim()),
        ),
        options: state.long,
      );
      await state.added(nb);
      if (mounted) Navigator.popUntil(context, (r) => r.isFirst);
    } catch (e) {
      if (mounted) setState(() => _error = errorText(e));
    } finally {
      if (mounted) setState(() => _busy = null);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    Widget step(String n, String title) => Padding(
      padding: const EdgeInsets.only(top: 24, bottom: 8),
      child: Row(
        children: [
          CircleAvatar(radius: 12, child: Text(n, style: theme.textTheme.labelMedium)),
          const SizedBox(width: 8),
          Text(title, style: theme.textTheme.titleMedium),
        ],
      ),
    );
    final repos = (_repos ?? [])
        .where((r) => r.fullName.toLowerCase().contains(_filter.text.trim().toLowerCase()))
        .toList();
    final signedIn = _repos != null;
    return Scaffold(
      appBar: AppBar(title: const Text('Set up with a git host')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          step('1', 'Host'),
          SegmentedButton<HostKind>(
            segments: const [
              ButtonSegment(value: HostKind.HOST_KIND_GITHUB, label: Text('GitHub')),
              ButtonSegment(value: HostKind.HOST_KIND_GITLAB, label: Text('GitLab')),
              ButtonSegment(value: HostKind.HOST_KIND_GITEA, label: Text('Codeberg')),
            ],
            selected: {_kind},
            onSelectionChanged: (s) => _changeHost(s.first),
          ),
          CheckboxListTile(
            contentPadding: EdgeInsets.zero,
            title: const Text('Self-hosted'),
            subtitle: const Text('GitHub Enterprise, your GitLab, Gitea or Forgejo'),
            value: _selfHosted,
            onChanged: (v) {
              setState(() => _selfHosted = v ?? false);
              _changeHost(_kind);
            },
          ),
          if (_selfHosted)
            TextField(
              controller: _baseUrl,
              keyboardType: TextInputType.url,
              autocorrect: false,
              decoration: const InputDecoration(
                labelText: 'Address',
                hintText: 'https://git.example.com',
                border: OutlineInputBorder(),
              ),
              onSubmitted: (_) => _changeHost(_kind),
            ),
          step('2', signedIn ? 'Signed in as $_user' : 'Sign in'),
          if (!signedIn) ...[
            if (_info?.deviceLogin == true) ...[
              FilledButton.icon(
                onPressed: _login == null ? _deviceLogin : null,
                icon: const Icon(Icons.login),
                label: Text('Sign in with $_hostName'),
              ),
              if (_login != null)
                Card.filled(
                  margin: const EdgeInsets.symmetric(vertical: 12),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        const Text('Enter this code on the page that opened (it is copied):'),
                        const SizedBox(height: 8),
                        SelectableText(_login!.userCode, style: theme.textTheme.headlineMedium),
                        TextButton(
                          onPressed: () =>
                              launchUrl(Uri.parse(_login!.verificationUrl), mode: LaunchMode.externalApplication),
                          child: Text(_login!.verificationUrl),
                        ),
                        const LinearProgressIndicator(),
                      ],
                    ),
                  ),
                ),
              const Padding(padding: EdgeInsets.symmetric(vertical: 12), child: Text('or with an access token:')),
            ],
            if (_info != null) ...[
              Text(_info!.tokenHint, style: theme.textTheme.bodyMedium),
              Align(
                alignment: Alignment.centerLeft,
                child: TextButton.icon(
                  onPressed: () => launchUrl(Uri.parse(_info!.tokenUrl), mode: LaunchMode.externalApplication),
                  icon: const Icon(Icons.open_in_new),
                  label: const Text('Create a token'),
                ),
              ),
            ],
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _token,
                    obscureText: true,
                    autocorrect: false,
                    enableSuggestions: false,
                    decoration: const InputDecoration(labelText: 'Access token', border: OutlineInputBorder()),
                    onSubmitted: (_) => _loadRepos(),
                  ),
                ),
                const SizedBox(width: 8),
                FilledButton(onPressed: _busy == null ? _loadRepos : null, child: const Text('Continue')),
              ],
            ),
          ],
          if (signedIn) ...[
            step('3', 'Repository'),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _newRepo,
                    decoration: const InputDecoration(labelText: 'New repository', border: OutlineInputBorder()),
                  ),
                ),
                const SizedBox(width: 8),
                FilledButton.tonal(onPressed: _busy == null ? _createRepo : null, child: const Text('Create')),
              ],
            ),
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('Private'),
              value: _private,
              onChanged: (v) => setState(() => _private = v),
            ),
            if ((_repos ?? []).length > 6)
              TextField(
                controller: _filter,
                decoration: const InputDecoration(prefixIcon: Icon(Icons.search), hintText: 'Filter'),
                onChanged: (_) => setState(() {}),
              ),
            ConstrainedBox(
              constraints: const BoxConstraints(maxHeight: 320),
              child: RadioGroup<String>(
                groupValue: _repo?.fullName,
                onChanged: (name) => setState(() => _repo = repos.firstWhere((r) => r.fullName == name)),
                child: ListView(
                  shrinkWrap: true,
                  children: [
                    for (final r in repos)
                      RadioListTile<String>(
                        value: r.fullName,
                        title: Text(r.fullName),
                        subtitle: r.description.isEmpty
                            ? null
                            : Text(r.description, maxLines: 1, overflow: TextOverflow.ellipsis),
                        secondary: Icon(r.private ? Icons.lock_outline : Icons.public),
                      ),
                  ],
                ),
              ),
            ),
          ],
          if (_repo != null) ...[
            step('4', 'Sync ${_repo!.fullName}'),
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('Use HTTPS with the token'),
              subtitle: Text(
                _https
                    ? 'The token is stored on this device and used for every sync.'
                    : 'Default: a new SSH key for this device, added as a deploy key for just this repository. '
                          'The token is not kept.',
              ),
              value: _https,
              onChanged: (v) => setState(() => _https = v),
            ),
            StorageLocation(controller: _storage, name: _repo!.fullName.split('/').last),
            const SizedBox(height: 16),
            AuthorFields(name: _authorName, email: _authorEmail),
          ],
          if (_error != null)
            Padding(
              padding: const EdgeInsets.only(top: 16),
              child: Text(_error!, style: TextStyle(color: theme.colorScheme.error)),
            ),
          if (_busy != null)
            Padding(
              padding: const EdgeInsets.only(top: 16),
              child: Row(
                children: [
                  const SizedBox.square(dimension: 20, child: CircularProgressIndicator(strokeWidth: 2)),
                  const SizedBox(width: 12),
                  Expanded(child: Text(_busy!)),
                ],
              ),
            ),
          if (_repo != null) ...[
            const SizedBox(height: 24),
            Align(
              alignment: Alignment.centerRight,
              child: FilledButton(onPressed: _busy == null ? _setUp : null, child: const Text('Set up notebook')),
            ),
          ],
          const SizedBox(height: 32),
        ],
      ),
    );
  }
}
