import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

import '../platform/platform.dart';

/// Where a new notebook's files go: the app's own storage (the default), or
/// a folder other apps see too. On Android that is shared storage, e.g.
/// Documents/Githeft/notes, which needs the all-files permission.
class StorageLocationController extends ChangeNotifier {
  bool shared = false;
  final path = TextEditingController();

  /// For CreateNotebookRequest.targetPath; empty for the app's storage.
  String get targetPath => shared ? path.text.trim() : '';

  @override
  void dispose() {
    path.dispose();
    super.dispose();
  }
}

class StorageLocation extends StatefulWidget {
  const StorageLocation({super.key, required this.controller, required this.name});

  final StorageLocationController controller;

  /// Suggested folder name, e.g. the repository name.
  final String name;

  @override
  State<StorageLocation> createState() => _StorageLocationState();
}

class _StorageLocationState extends State<StorageLocation> with WidgetsBindingObserver {
  bool _access = true;
  String? _root;

  StorageLocationController get c => widget.controller;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _check();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didUpdateWidget(StorageLocation old) {
    super.didUpdateWidget(old);
    if (old.name != widget.name) _suggest();
  }

  /// The permission is granted in Android's settings; check on return.
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) _check();
  }

  Future<void> _check() async {
    final access = await Device.hasAllFilesAccess();
    final root = Device.isAndroid ? await Device.sharedStorageDir() : null;
    if (!mounted) return;
    setState(() {
      _access = access;
      _root = root;
    });
    _suggest();
  }

  void _suggest() {
    final name = widget.name.trim().isEmpty ? 'notes' : widget.name.trim();
    if (Device.isAndroid &&
        _root != null &&
        (c.path.text.isEmpty || c.path.text.startsWith('$_root/Documents/Githeft/'))) {
      c.path.text = '$_root/Documents/Githeft/$name';
    }
  }

  Future<void> _pick() async {
    final dir = await FilePicker.pickDirectory(dialogTitle: 'Parent folder');
    if (dir == null) return;
    final parent = Device.treeUriToPath(dir, _root ?? '');
    if (parent == null) return;
    final name = widget.name.trim().isEmpty ? 'notes' : widget.name.trim();
    setState(() => c.path.text = '$parent/$name');
  }

  @override
  Widget build(BuildContext context) {
    if (Device.isWeb) return const SizedBox.shrink();
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SwitchListTile(
          contentPadding: EdgeInsets.zero,
          title: Text(Device.isAndroid ? 'Keep in shared storage' : 'Choose the folder'),
          subtitle: Text(
            Device.isAndroid
                ? 'Other apps (file managers, Markdown editors) see the notes too'
                : 'Instead of the app\'s data folder',
          ),
          value: c.shared,
          onChanged: (v) => setState(() => c.shared = v),
        ),
        if (c.shared) ...[
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
                  controller: c.path,
                  decoration: const InputDecoration(
                    labelText: 'Folder',
                    helperText: 'Must not exist yet or be empty',
                    border: OutlineInputBorder(),
                  ),
                  style: theme.textTheme.bodySmall,
                ),
              ),
              const SizedBox(width: 8),
              IconButton.filledTonal(onPressed: _pick, icon: const Icon(Icons.folder_open)),
            ],
          ),
        ],
      ],
    );
  }
}
