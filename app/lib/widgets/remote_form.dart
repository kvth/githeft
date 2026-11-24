import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

import '../gen/githeft/v1/githeft.pbgrpc.dart';
import '../state.dart';

/// user@host:path or ssh://…
bool isSshUrl(String url) => url.startsWith('ssh://') || RegExp(r'^[\w.-]+@[\w.-]+:').hasMatch(url.trim());

/// The values of a [RemoteForm].
class RemoteFormController extends ChangeNotifier {
  RemoteFormController([Remote? remote]) {
    url.text = remote?.url ?? '';
    username.text = remote?.username ?? '';
    branch.text = remote?.branch ?? '';
    keyId = remote?.sshKeyId ?? '';
    hasStoredPassword = remote?.passwordStored ?? false;
    url.addListener(notifyListeners);
  }

  final url = TextEditingController();
  final username = TextEditingController();
  final password = TextEditingController();
  final branch = TextEditingController();
  String keyId = '';
  SshKey? key;
  bool hasStoredPassword = false;

  bool get ssh => isSshUrl(url.text);

  Remote toRemote() {
    final u = url.text.trim();
    return Remote(
      url: u,
      authType: ssh
          ? AuthType.AUTH_TYPE_SSH
          : (username.text.isNotEmpty || password.text.isNotEmpty || hasStoredPassword)
          ? AuthType.AUTH_TYPE_HTTPS
          : AuthType.AUTH_TYPE_NONE,
      sshKeyId: ssh ? keyId : '',
      username: ssh ? '' : username.text.trim(),
      password: ssh ? '' : password.text,
      branch: branch.text.trim(),
    );
  }

  void setKey(SshKey k) {
    key = k;
    keyId = k.id;
    notifyListeners();
  }

  @override
  void dispose() {
    for (final c in [url, username, password, branch]) {
      c.dispose();
    }
    super.dispose();
  }
}

/// Clone URL plus credentials: an SSH key for SSH URLs, user name and
/// password or token for HTTPS.
class RemoteForm extends StatefulWidget {
  const RemoteForm({super.key, required this.controller});

  final RemoteFormController controller;

  @override
  State<RemoteForm> createState() => _RemoteFormState();
}

class _RemoteFormState extends State<RemoteForm> {
  bool _busy = false;
  bool _showPassword = false;

  RemoteFormController get c => widget.controller;

  @override
  void initState() {
    super.initState();
    c.addListener(_changed);
    if (c.keyId.isNotEmpty && c.key == null) _loadKey();
  }

  @override
  void dispose() {
    c.removeListener(_changed);
    super.dispose();
  }

  void _changed() => setState(() {});

  Future<void> _loadKey() async {
    try {
      c.setKey(await AppScope.read(context).api.getSshKey(GetSshKeyRequest(id: c.keyId)));
    } catch (_) {
      // The key is gone; the user has to pick a new one.
      c.keyId = '';
      _changed();
    }
  }

  Future<void> _generate(SshKeyType type) async {
    setState(() => _busy = true);
    try {
      final key = await AppScope.read(
        context,
      ).api.generateSshKey(GenerateSshKeyRequest(type: type, comment: 'githeft'));
      c.setKey(key);
    } catch (e) {
      _snack(errorText(e));
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _import() async {
    final imported = await showDialog<SshKey>(context: context, builder: (_) => const _ImportKeyDialog());
    if (imported != null) c.setKey(imported);
  }

  void _snack(String text) {
    if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));
  }

  /// Where the git host takes deploy keys, for the common hosts.
  Uri? _deployKeyPage() {
    final m = RegExp(r'^(?:ssh://)?[\w.-]+@([\w.-]+)[:/](?:\d+/)?(.+?)(?:\.git)?/?$').firstMatch(c.url.text.trim());
    if (m == null) return null;
    final host = m.group(1)!, repo = m.group(2)!;
    return switch (host) {
      'github.com' => Uri.parse('https://github.com/$repo/settings/keys/new'),
      'gitlab.com' => Uri.parse('https://gitlab.com/$repo/-/settings/repository#js-deploy-keys-settings'),
      'codeberg.org' => Uri.parse('https://codeberg.org/$repo/settings/keys'),
      _ => null,
    };
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final ssh = c.ssh;
    final url = c.url.text.trim();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TextField(
          controller: c.url,
          keyboardType: TextInputType.url,
          autocorrect: false,
          decoration: const InputDecoration(
            labelText: 'Clone URL',
            hintText: 'https://github.com/you/notes.git',
            helperText: 'HTTPS (https://…) or SSH (git@host:you/notes.git)',
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 16),
        if (url.isNotEmpty && ssh) ...[
          Text('SSH key', style: theme.textTheme.titleMedium),
          const SizedBox(height: 8),
          if (c.key == null) ...[
            Text(
              'Githeft signs in with an SSH key. Generate one on this device, or use a key you already have.',
              style: theme.textTheme.bodyMedium,
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                FilledButton.icon(
                  onPressed: _busy ? null : () => _generate(SshKeyType.SSH_KEY_TYPE_ED25519),
                  icon: _busy
                      ? const SizedBox.square(dimension: 16, child: CircularProgressIndicator(strokeWidth: 2))
                      : const Icon(Icons.key),
                  label: const Text('Generate key'),
                ),
                OutlinedButton(
                  onPressed: _busy ? null : () => _generate(SshKeyType.SSH_KEY_TYPE_RSA),
                  child: const Text('Generate RSA key'),
                ),
                OutlinedButton(onPressed: _busy ? null : _import, child: const Text('Use existing key')),
              ],
            ),
          ] else ...[
            Text(
              'Add this public key to the repository as a deploy key with write access '
              '(or to your account\'s SSH keys):',
              style: theme.textTheme.bodyMedium,
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: theme.colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(8),
              ),
              child: SelectableText(c.key!.publicKey, style: const TextStyle(fontFamily: 'monospace', fontSize: 12)),
            ),
            const SizedBox(height: 4),
            Text(c.key!.fingerprint, style: theme.textTheme.bodySmall),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                FilledButton.tonalIcon(
                  onPressed: () {
                    Clipboard.setData(ClipboardData(text: c.key!.publicKey));
                    _snack('Public key copied');
                  },
                  icon: const Icon(Icons.copy),
                  label: const Text('Copy key'),
                ),
                if (_deployKeyPage() case final page?)
                  OutlinedButton.icon(
                    onPressed: () => launchUrl(page, mode: LaunchMode.externalApplication),
                    icon: const Icon(Icons.open_in_new),
                    label: const Text('Open deploy keys page'),
                  ),
                TextButton(
                  onPressed: () {
                    c.key = null;
                    c.keyId = '';
                    _changed();
                  },
                  child: const Text('Use another key'),
                ),
              ],
            ),
          ],
        ],
        if (url.isNotEmpty && !ssh) ...[
          TextField(
            controller: c.username,
            autocorrect: false,
            decoration: const InputDecoration(
              labelText: 'User name',
              helperText: 'Can stay empty with an access token',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: c.password,
            obscureText: !_showPassword,
            autocorrect: false,
            enableSuggestions: false,
            decoration: InputDecoration(
              labelText: 'Password or access token',
              helperText: c.hasStoredPassword
                  ? 'Leave empty to keep the stored one'
                  : 'GitHub, GitLab and Codeberg want a token with read and write access to the repository',
              helperMaxLines: 3,
              border: const OutlineInputBorder(),
              suffixIcon: IconButton(
                icon: Icon(_showPassword ? Icons.visibility_off : Icons.visibility),
                onPressed: () => setState(() => _showPassword = !_showPassword),
              ),
            ),
          ),
        ],
        if (url.isNotEmpty) ...[
          const SizedBox(height: 12),
          TextField(
            controller: c.branch,
            autocorrect: false,
            decoration: const InputDecoration(
              labelText: 'Branch',
              helperText: 'Empty: the repository\'s default branch',
              border: OutlineInputBorder(),
            ),
          ),
        ],
      ],
    );
  }
}

class _ImportKeyDialog extends StatefulWidget {
  const _ImportKeyDialog();

  @override
  State<_ImportKeyDialog> createState() => _ImportKeyDialogState();
}

class _ImportKeyDialogState extends State<_ImportKeyDialog> {
  final _key = TextEditingController();
  final _passphrase = TextEditingController();
  String? _error;
  bool _busy = false;

  @override
  void dispose() {
    _key.dispose();
    _passphrase.dispose();
    super.dispose();
  }

  Future<void> _pickFile() async {
    final file = await FilePicker.pickFile(dialogTitle: 'Private key');
    if (file != null) _key.text = String.fromCharCodes(await file.readAsBytes());
  }

  Future<void> _save() async {
    setState(() {
      _busy = true;
      _error = null;
    });
    try {
      final key = await AppScope.read(
        context,
      ).api.importSshKey(ImportSshKeyRequest(privateKey: _key.text, passphrase: _passphrase.text));
      if (mounted) Navigator.pop(context, key);
    } catch (e) {
      setState(() => _error = errorText(e));
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Use existing SSH key'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _key,
              minLines: 4,
              maxLines: 8,
              autocorrect: false,
              style: const TextStyle(fontFamily: 'monospace', fontSize: 12),
              decoration: const InputDecoration(
                labelText: 'Private key',
                hintText: '-----BEGIN OPENSSH PRIVATE KEY-----',
                border: OutlineInputBorder(),
              ),
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: TextButton.icon(
                onPressed: _pickFile,
                icon: const Icon(Icons.file_open),
                label: const Text('Load from file'),
              ),
            ),
            TextField(
              controller: _passphrase,
              obscureText: true,
              decoration: const InputDecoration(labelText: 'Passphrase (if any)', border: OutlineInputBorder()),
            ),
            if (_error != null)
              Padding(
                padding: const EdgeInsets.only(top: 12),
                child: Text(_error!, style: TextStyle(color: Theme.of(context).colorScheme.error)),
              ),
          ],
        ),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
        FilledButton(onPressed: _busy ? null : _save, child: const Text('Use key')),
      ],
    );
  }
}
