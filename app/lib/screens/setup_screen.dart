import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../platform/platform.dart';
import '../gen/githeft/v1/githeft.pbgrpc.dart';
import '../state.dart';
import '../widgets/remote_form.dart';
import '../widgets/storage_location.dart';
import 'host_setup_screen.dart';

/// Adding a notebook: clone one, start an empty one, or open a folder.
class SetupScreen extends StatelessWidget {
  const SetupScreen({super.key, this.first = false});

  /// No notebook exists yet: this is the start screen.
  final bool first;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    Widget choice(IconData icon, String title, String subtitle, Widget Function() screen) => Card(
      child: ListTile(
        leading: Icon(icon, size: 32),
        title: Text(title),
        subtitle: Text(subtitle),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => screen())),
      ),
    );
    return Scaffold(
      appBar: AppBar(title: Text(first ? 'Githeft' : 'Add notebook')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          if (first) ...[
            Text('Markdown notes in a git repository', style: theme.textTheme.headlineSmall),
            const SizedBox(height: 8),
            Text(
              'Your notes are plain Markdown files. Githeft commits every change and syncs them with '
              'any git host over HTTPS or SSH.',
              style: theme.textTheme.bodyLarge,
            ),
            const SizedBox(height: 24),
          ],
          choice(
            Icons.rocket_launch_outlined,
            'Set up with GitHub, GitLab or Codeberg',
            'Sign in, pick or create a repository; Githeft adds its key for you',
            () => const HostSetupScreen(),
          ),
          choice(
            Icons.cloud_download_outlined,
            'Clone a repository',
            'Any git server, with the URL and an SSH key or password',
            () => const CloneScreen(),
          ),
          choice(
            Icons.note_add_outlined,
            'New notebook on this device',
            'Add a git remote later to sync it',
            () => const LocalNotebookScreen(),
          ),
          if (Device.canOpenFolders)
            choice(
              Icons.folder_open_outlined,
              kIsWeb ? 'Open a repository on the server' : 'Open a folder',
              'Use an existing git repository in place',
              () => const OpenFolderScreen(),
            ),
        ],
      ),
    );
  }
}

/// Name and email for commits, remembered for the next notebook.
class AuthorFields extends StatelessWidget {
  const AuthorFields({super.key, required this.name, required this.email});

  final TextEditingController name, email;

  static Future<void> prefill(TextEditingController name, TextEditingController email) async {
    final prefs = await SharedPreferences.getInstance();
    name.text = prefs.getString('authorName') ?? '';
    email.text = prefs.getString('authorEmail') ?? '';
  }

  static Future<void> remember(String name, String email) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('authorName', name);
    await prefs.setString('authorEmail', email);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text('Commit author', style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 8),
        TextField(
          controller: name,
          textCapitalization: TextCapitalization.words,
          decoration: const InputDecoration(labelText: 'Name', border: OutlineInputBorder()),
        ),
        const SizedBox(height: 12),
        TextField(
          controller: email,
          keyboardType: TextInputType.emailAddress,
          autocorrect: false,
          decoration: const InputDecoration(labelText: 'Email', border: OutlineInputBorder()),
        ),
      ],
    );
  }
}

/// Shared frame of the setup forms: fields, an error line and buttons.
class _SetupForm extends StatelessWidget {
  const _SetupForm({required this.title, required this.actions, this.error, this.busy, required this.fields});

  final String title;
  final List<Widget> fields;
  final List<Widget> actions;
  final String? error;
  final String? busy;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          ...fields,
          if (error != null)
            Padding(
              padding: const EdgeInsets.only(top: 16),
              child: Text(error!, style: TextStyle(color: theme.colorScheme.error)),
            ),
          if (busy != null)
            Padding(
              padding: const EdgeInsets.only(top: 16),
              child: Row(
                children: [
                  const SizedBox.square(dimension: 20, child: CircularProgressIndicator(strokeWidth: 2)),
                  const SizedBox(width: 12),
                  Expanded(child: Text(busy!)),
                ],
              ),
            ),
          const SizedBox(height: 24),
          Wrap(alignment: WrapAlignment.end, spacing: 8, runSpacing: 8, children: actions),
        ],
      ),
    );
  }
}

class CloneScreen extends StatefulWidget {
  const CloneScreen({super.key});

  @override
  State<CloneScreen> createState() => _CloneScreenState();
}

/// "notes" for https://host/you/notes.git or git@host:you/notes.git.
String _repoName(String url) {
  final parts = url.trim().replaceAll(':', '/').split('/').where((p) => p.isNotEmpty);
  return parts.isEmpty ? '' : parts.last.replaceFirst(RegExp(r'\.git$'), '');
}

class _CloneScreenState extends State<CloneScreen> {
  final _remote = RemoteFormController();
  final _name = TextEditingController();
  final _authorName = TextEditingController();
  final _authorEmail = TextEditingController();
  final _storage = StorageLocationController();
  String? _error, _busy, _tested;

  @override
  void initState() {
    super.initState();
    AuthorFields.prefill(_authorName, _authorEmail);
  }

  @override
  void dispose() {
    for (final c in [_name, _authorName, _authorEmail]) {
      c.dispose();
    }
    _remote.dispose();
    _storage.dispose();
    super.dispose();
  }

  Future<void> _test() async {
    setState(() {
      _error = _tested = null;
      _busy = 'Connecting…';
    });
    try {
      final res = await AppScope.read(context).api.testRemote(TestRemoteRequest(remote: _remote.toRemote()));
      setState(
        () => _tested = res.branches.isEmpty
            ? 'Connected. The repository is empty; the first sync fills it.'
            : 'Connected. Branches: ${res.branches.join(', ')} (default ${res.defaultBranch}).',
      );
    } catch (e) {
      setState(() => _error = errorText(e));
    } finally {
      if (mounted) setState(() => _busy = null);
    }
  }

  Future<void> _clone() async {
    final state = AppScope.read(context);
    setState(() {
      _error = null;
      _busy = 'Cloning…';
    });
    try {
      await AuthorFields.remember(_authorName.text.trim(), _authorEmail.text.trim());
      final nb = await state.api.createNotebook(
        CreateNotebookRequest(
          name: _name.text.trim(),
          cloneRemote: _remote.toRemote(),
          targetPath: _storage.targetPath,
          author: Author(name: _authorName.text.trim(), email: _authorEmail.text.trim()),
        ),
        options: state.long,
      );
      await state.added(nb);
      if (mounted) Navigator.popUntil(context, (r) => r.isFirst);
    } catch (e) {
      setState(() => _error = errorText(e));
    } finally {
      if (mounted) setState(() => _busy = null);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: _remote,
      builder: (context, _) {
        final ready = _remote.url.text.trim().isNotEmpty && (!_remote.ssh || _remote.keyId.isNotEmpty);
        return _SetupForm(
          title: 'Clone a repository',
          error: _error,
          busy: _busy,
          fields: [
            RemoteForm(controller: _remote),
            if (_tested != null) Padding(padding: const EdgeInsets.only(top: 16), child: Text(_tested!)),
            const SizedBox(height: 24),
            TextField(
              controller: _name,
              decoration: const InputDecoration(
                labelText: 'Notebook name',
                helperText: 'Empty: the repository name',
                border: OutlineInputBorder(),
              ),
            ),
            StorageLocation(controller: _storage, name: _repoName(_remote.url.text)),
            const SizedBox(height: 24),
            AuthorFields(name: _authorName, email: _authorEmail),
          ],
          actions: [
            OutlinedButton(onPressed: ready && _busy == null ? _test : null, child: const Text('Test connection')),
            FilledButton(onPressed: ready && _busy == null ? _clone : null, child: const Text('Clone')),
          ],
        );
      },
    );
  }
}

class LocalNotebookScreen extends StatefulWidget {
  const LocalNotebookScreen({super.key});

  @override
  State<LocalNotebookScreen> createState() => _LocalNotebookScreenState();
}

class _LocalNotebookScreenState extends State<LocalNotebookScreen> {
  final _name = TextEditingController(text: 'Notes');
  final _authorName = TextEditingController();
  final _authorEmail = TextEditingController();
  final _storage = StorageLocationController();
  String? _error, _busy;

  @override
  void initState() {
    super.initState();
    AuthorFields.prefill(_authorName, _authorEmail);
  }

  @override
  void dispose() {
    for (final c in [_name, _authorName, _authorEmail]) {
      c.dispose();
    }
    _storage.dispose();
    super.dispose();
  }

  Future<void> _create() async {
    final state = AppScope.read(context);
    setState(() {
      _error = null;
      _busy = 'Creating…';
    });
    try {
      await AuthorFields.remember(_authorName.text.trim(), _authorEmail.text.trim());
      final nb = await state.api.createNotebook(
        CreateNotebookRequest(
          name: _name.text.trim(),
          empty: true,
          targetPath: _storage.targetPath,
          author: Author(name: _authorName.text.trim(), email: _authorEmail.text.trim()),
        ),
      );
      await state.added(nb);
      if (mounted) Navigator.popUntil(context, (r) => r.isFirst);
    } catch (e) {
      setState(() => _error = errorText(e));
    } finally {
      if (mounted) setState(() => _busy = null);
    }
  }

  @override
  Widget build(BuildContext context) {
    return _SetupForm(
      title: 'New notebook',
      error: _error,
      busy: _busy,
      fields: [
        TextField(
          controller: _name,
          decoration: const InputDecoration(labelText: 'Notebook name', border: OutlineInputBorder()),
          onChanged: (_) => setState(() {}),
        ),
        StorageLocation(controller: _storage, name: _name.text),
        const SizedBox(height: 24),
        AuthorFields(name: _authorName, email: _authorEmail),
      ],
      actions: [FilledButton(onPressed: _busy == null ? _create : null, child: const Text('Create'))],
    );
  }
}

class OpenFolderScreen extends StatefulWidget {
  const OpenFolderScreen({super.key});

  @override
  State<OpenFolderScreen> createState() => _OpenFolderScreenState();
}

class _OpenFolderScreenState extends State<OpenFolderScreen> with WidgetsBindingObserver {
  final _path = TextEditingController();
  bool _access = true;
  final _name = TextEditingController();
  final _authorName = TextEditingController();
  final _authorEmail = TextEditingController();
  String? _error, _busy;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    AuthorFields.prefill(_authorName, _authorEmail);
    _checkAccess();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    for (final c in [_path, _name, _authorName, _authorEmail]) {
      c.dispose();
    }
    super.dispose();
  }

  /// Android grants folder access in its settings; check on return.
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) _checkAccess();
  }

  Future<void> _checkAccess() async {
    final access = await Device.hasAllFilesAccess();
    if (mounted) setState(() => _access = access);
  }

  Future<void> _pick() async {
    final dir = await FilePicker.pickDirectory(dialogTitle: 'Folder with a git repository');
    if (dir == null) return;
    final path = Device.treeUriToPath(dir, await Device.sharedStorageDir() ?? '');
    if (path != null) setState(() => _path.text = path);
  }

  Future<void> _open() async {
    final state = AppScope.read(context);
    setState(() {
      _error = null;
      _busy = 'Opening…';
    });
    try {
      await AuthorFields.remember(_authorName.text.trim(), _authorEmail.text.trim());
      final nb = await state.api.createNotebook(
        CreateNotebookRequest(
          name: _name.text.trim(),
          existingPath: _path.text.trim(),
          author: Author(name: _authorName.text.trim(), email: _authorEmail.text.trim()),
        ),
      );
      await state.added(nb);
      if (mounted) Navigator.popUntil(context, (r) => r.isFirst);
    } catch (e) {
      setState(() => _error = errorText(e));
    } finally {
      if (mounted) setState(() => _busy = null);
    }
  }

  @override
  Widget build(BuildContext context) {
    return _SetupForm(
      title: 'Open a folder',
      error: _error,
      busy: _busy,
      fields: [
        if (!_access)
          Card.filled(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Android only lets Githeft use folders outside its own storage with the '
                    '"All files access" permission.',
                  ),
                  const SizedBox(height: 8),
                  FilledButton.tonal(onPressed: Device.requestAllFilesAccess, child: const Text('Grant access')),
                ],
              ),
            ),
          ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: _path,
                decoration: const InputDecoration(
                  labelText: 'Folder',
                  helperText: 'Must already be a git repository; notes stay where they are',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            if (!kIsWeb) ...[
              const SizedBox(width: 8),
              IconButton.filledTonal(onPressed: _pick, icon: const Icon(Icons.folder_open)),
            ],
          ],
        ),
        const SizedBox(height: 12),
        TextField(
          controller: _name,
          decoration: const InputDecoration(
            labelText: 'Notebook name',
            helperText: 'Empty: the folder name',
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 24),
        AuthorFields(name: _authorName, email: _authorEmail),
      ],
      actions: [FilledButton(onPressed: _busy == null ? _open : null, child: const Text('Open'))],
    );
  }
}
