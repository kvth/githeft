import 'package:flutter/material.dart';

import '../gen/githeft/v1/githeft.pbgrpc.dart';
import '../platform/platform.dart';
import '../state.dart';
import '../widgets/remote_form.dart';
import 'setup_screen.dart' show AuthorFields;

/// Settings of the open notebook (remote, author, note names) and the app.
class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  late Notebook _nb;
  late RemoteFormController _remote;
  final _name = TextEditingController();
  final _authorName = TextEditingController();
  final _authorEmail = TextEditingController();
  final _defaultFolder = TextEditingController();
  late bool _autoSync;
  late NewNoteName _newNoteName;
  String? _message, _error;
  bool _busy = false;

  @override
  void initState() {
    super.initState();
    _nb = AppScope.read(context).current!;
    _remote = RemoteFormController(_nb.hasRemote() ? _nb.remote : null);
    _name.text = _nb.name;
    _authorName.text = _nb.author.name;
    _authorEmail.text = _nb.author.email;
    _defaultFolder.text = _nb.defaultFolder;
    _autoSync = _nb.autoSync;
    _newNoteName = _nb.newNoteName == NewNoteName.NEW_NOTE_NAME_DATE_TIME
        ? NewNoteName.NEW_NOTE_NAME_DATE_TIME
        : NewNoteName.NEW_NOTE_NAME_TITLE;
  }

  @override
  void dispose() {
    for (final c in [_name, _authorName, _authorEmail, _defaultFolder]) {
      c.dispose();
    }
    _remote.dispose();
    super.dispose();
  }

  Notebook _edited() => Notebook(
    id: _nb.id,
    name: _name.text.trim(),
    remote: _remote.url.text.trim().isEmpty ? null : _remote.toRemote(),
    author: Author(name: _authorName.text.trim(), email: _authorEmail.text.trim()),
    autoSync: _autoSync,
    newNoteName: _newNoteName,
    defaultFolder: _defaultFolder.text.trim(),
  );

  Future<void> _run(String doing, Future<String?> Function() action) async {
    setState(() {
      _busy = true;
      _error = null;
      _message = doing;
    });
    try {
      final msg = await action();
      setState(() => _message = msg);
    } catch (e) {
      setState(() {
        _error = errorText(e);
        _message = null;
      });
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _save() => _run('Saving…', () async {
    final state = AppScope.read(context);
    final nb = await state.api.updateNotebook(UpdateNotebookRequest(notebook: _edited()));
    _nb = nb;
    _remote.password.clear();
    _remote.hasStoredPassword = nb.remote.passwordStored;
    state.updated(nb);
    await state.refreshStatus();
    return 'Saved';
  });

  Future<void> _test() => _run('Connecting…', () async {
    final res = await AppScope.read(
      context,
    ).api.testRemote(TestRemoteRequest(remote: _remote.toRemote(), notebookId: _nb.id));
    return res.branches.isEmpty
        ? 'Connected. The repository is empty.'
        : 'Connected. Branches: ${res.branches.join(', ')}';
  });

  Future<void> _forgetHostKey() async {
    final m = RegExp(r'^(?:ssh://)?[\w.-]+@([\w.-]+)(?::(\d+)/)?').firstMatch(_remote.url.text.trim());
    if (m == null) return;
    final host = m.group(2) == null ? m.group(1)! : '[${m.group(1)}]:${m.group(2)}';
    await _run('Forgetting…', () async {
      await AppScope.read(context).api.forgetHostKey(ForgetHostKeyRequest(host: host));
      return 'The next sync accepts the key $host presents then.';
    });
  }

  Future<void> _delete() async {
    final state = AppScope.read(context);
    final yes = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Remove “${_nb.name}”?'),
        content: Text(
          _nb.path.contains('/notebooks/')
              ? 'The notes on this device are deleted. Changes that were not synced are lost; '
                    'the remote repository is not touched.'
              : 'Githeft forgets the notebook. The folder ${_nb.path} stays as it is.',
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancel')),
          FilledButton(onPressed: () => Navigator.pop(context, true), child: const Text('Remove')),
        ],
      ),
    );
    if (yes != true) return;
    try {
      await state.api.deleteNotebook(DeleteNotebookRequest(id: _nb.id, deleteFiles: true));
      await state.removed();
      if (mounted) Navigator.popUntil(context, (r) => r.isFirst);
    } catch (e) {
      setState(() => _error = errorText(e));
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = AppScope.of(context);
    final theme = Theme.of(context);
    Widget section(String title) => Padding(
      padding: const EdgeInsets.only(top: 24, bottom: 8),
      child: Text(title, style: theme.textTheme.titleMedium?.copyWith(color: theme.colorScheme.primary)),
    );
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListenableBuilder(
        listenable: _remote,
        builder: (context, _) => ListView(
          padding: const EdgeInsets.all(16),
          children: [
            section('Notebook'),
            TextField(
              controller: _name,
              decoration: const InputDecoration(labelText: 'Name', border: OutlineInputBorder()),
            ),
            const SizedBox(height: 8),
            Text(_nb.path, style: theme.textTheme.bodySmall),
            section('Sync'),
            RemoteForm(controller: _remote),
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('Sync automatically'),
              subtitle: const Text('After changes, when the app opens and every 10 minutes'),
              value: _autoSync,
              onChanged: (v) => setState(() => _autoSync = v),
            ),
            if (_remote.url.text.trim().isNotEmpty)
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  OutlinedButton(onPressed: _busy ? null : _test, child: const Text('Test connection')),
                  if (_remote.ssh)
                    TextButton(onPressed: _busy ? null : _forgetHostKey, child: const Text('Forget host key')),
                ],
              ),
            section('New notes'),
            SegmentedButton<NewNoteName>(
              segments: const [
                ButtonSegment(value: NewNoteName.NEW_NOTE_NAME_TITLE, label: Text('Named by title')),
                ButtonSegment(value: NewNoteName.NEW_NOTE_NAME_DATE_TIME, label: Text('Date and time')),
              ],
              selected: {_newNoteName},
              onSelectionChanged: (s) => setState(() => _newNoteName = s.first),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _defaultFolder,
              decoration: const InputDecoration(
                labelText: 'Folder for new notes',
                helperText: 'Empty: the top folder',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 24),
            AuthorFields(name: _authorName, email: _authorEmail),
            if (_error != null)
              Padding(
                padding: const EdgeInsets.only(top: 16),
                child: Text(_error!, style: TextStyle(color: theme.colorScheme.error)),
              ),
            if (_message != null) Padding(padding: const EdgeInsets.only(top: 16), child: Text(_message!)),
            const SizedBox(height: 16),
            Align(
              alignment: Alignment.centerRight,
              child: FilledButton(onPressed: _busy ? null : _save, child: const Text('Save')),
            ),
            section('App'),
            SegmentedButton<ThemeMode>(
              segments: const [
                ButtonSegment(value: ThemeMode.system, label: Text('System')),
                ButtonSegment(value: ThemeMode.light, label: Text('Light')),
                ButtonSegment(value: ThemeMode.dark, label: Text('Dark')),
              ],
              selected: {state.themeMode},
              onSelectionChanged: (s) => state.setThemeMode(s.first),
            ),
            const SizedBox(height: 8),
            if (Device.backgroundSyncSupported)
              ListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text('Sync while the app is closed'),
                subtitle: Text(
                  Device.isAndroid
                      ? 'Notebooks with automatic sync, when there is a network connection'
                      : 'Notebooks with automatic sync, with a systemd user timer',
                ),
                trailing: DropdownButton<int>(
                  value: state.backgroundSync,
                  onChanged: (m) async {
                    if (m == null) return;
                    try {
                      await state.setBackgroundSync(m);
                    } catch (e) {
                      setState(() => _error = errorText(e));
                    }
                  },
                  items: const [
                    DropdownMenuItem(value: 0, child: Text('Off')),
                    DropdownMenuItem(value: 15, child: Text('15 min')),
                    DropdownMenuItem(value: 30, child: Text('30 min')),
                    DropdownMenuItem(value: 60, child: Text('1 hour')),
                    DropdownMenuItem(value: 360, child: Text('6 hours')),
                  ],
                ),
              )
            else
              Text(
                'The server syncs in the background when started with -sync-every.',
                style: theme.textTheme.bodySmall,
              ),
            section('Danger zone'),
            OutlinedButton.icon(
              style: OutlinedButton.styleFrom(foregroundColor: theme.colorScheme.error),
              onPressed: _delete,
              icon: const Icon(Icons.delete_outline),
              label: const Text('Remove notebook from this device'),
            ),
          ],
        ),
      ),
    );
  }
}
