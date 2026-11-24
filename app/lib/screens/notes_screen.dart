import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../gen/githeft/v1/githeft.pbgrpc.dart';
import '../state.dart';
import '../widgets/note_preview.dart' show NoteImage;
import '../widgets/note_views.dart';
import '../widgets/sync_button.dart';
import 'editor_screen.dart';
import 'settings_screen.dart';
import 'setup_screen.dart';

enum _Mode { all, folder, tag }

/// The notes of the open notebook: all of them, one folder or one tag.
class NotesScreen extends StatefulWidget {
  const NotesScreen({super.key});

  @override
  State<NotesScreen> createState() => _NotesScreenState();
}

class _NotesScreenState extends State<NotesScreen> {
  _Mode _mode = _Mode.all;
  String _folder = '';
  String _tag = '';
  SortOrder _sort = SortOrder.SORT_ORDER_MODIFIED_DESC;
  NotesView _view = NotesView.list;
  final _search = TextEditingController();
  bool _searching = false;

  List<NoteSummary> _notes = [];
  List<Folder> _folders = [];
  bool _loading = true;
  String? _error;

  String? _loadedNotebook;
  int _loadedVersion = -1;
  int _request = 0;

  @override
  void initState() {
    super.initState();
    SharedPreferences.getInstance().then((p) {
      final saved = SortOrder.valueOf(p.getInt('sort') ?? 0);
      if (saved != null && saved != SortOrder.SORT_ORDER_UNSPECIFIED && mounted) {
        setState(() => _sort = saved);
        _reload();
      }
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final state = AppScope.of(context);
    final id = state.current?.id;
    if (id != _loadedNotebook) {
      _mode = _Mode.all;
      _folder = _tag = '';
      _loadView(id);
    }
    if (state.notice case final notice?) {
      state.notice = null;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(notice), duration: const Duration(seconds: 8)));
        }
      });
    }
    if (id != _loadedNotebook || state.notesVersion != _loadedVersion) {
      _loadedNotebook = id;
      _loadedVersion = state.notesVersion;
      _reload();
    }
  }

  /// Each notebook remembers its view.
  Future<void> _loadView(String? id) async {
    final prefs = await SharedPreferences.getInstance();
    final name = prefs.getString('view.$id');
    final view = NotesView.values.where((v) => v.name == name).firstOrNull ?? NotesView.list;
    if (mounted && id == AppScope.read(context).current?.id) setState(() => _view = view);
  }

  Future<void> _setView(NotesView view) async {
    setState(() => _view = view);
    final id = AppScope.read(context).current?.id;
    (await SharedPreferences.getInstance()).setString('view.$id', view.name);
  }

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  Future<void> _reload() async {
    final state = AppScope.read(context);
    final nb = state.current;
    if (nb == null) return;
    final request = ++_request;
    NoteImage.clearCache();
    try {
      final res = await state.api.listNotes(
        ListNotesRequest(
          notebookId: nb.id,
          folder: _mode == _Mode.folder ? _folder : '',
          recursive: _mode != _Mode.folder,
          tag: _mode == _Mode.tag ? _tag : '',
          query: _searching ? _search.text : '',
          sort: _sort,
        ),
      );
      if (request != _request || !mounted) return;
      setState(() {
        _notes = res.notes;
        _folders = _mode == _Mode.folder ? res.folders : [];
        _loading = false;
        _error = null;
      });
    } catch (e) {
      if (request != _request || !mounted) return;
      setState(() {
        _loading = false;
        _error = errorText(e);
      });
    }
  }

  void _show(_Mode mode, {String folder = '', String tag = ''}) {
    setState(() {
      _mode = mode;
      _folder = folder;
      _tag = tag;
    });
    _reload();
  }

  Future<void> _open(NoteSummary? note, {NoteType type = NoteType.NOTE_TYPE_MARKDOWN}) async {
    final state = AppScope.read(context);
    final changed = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (_) => EditorScreen(
          notebook: state.current!,
          path: note?.path,
          folder: _mode == _Mode.folder ? _folder : '',
          tags: _mode == _Mode.tag ? [_tag] : const [],
          type: type,
        ),
      ),
    );
    if (changed == true) {
      state.changed();
    } else {
      _reload();
    }
  }

  /// The pen button: a journal entry in the journal and calendar views, a
  /// note elsewhere. Holding it offers all kinds.
  void _new() => _open(
    null,
    type: _view == NotesView.journal || _view == NotesView.calendar
        ? NoteType.NOTE_TYPE_JOURNAL
        : NoteType.NOTE_TYPE_MARKDOWN,
  );

  Future<void> _newMenu() async {
    final type = await showModalBottomSheet<NoteType>(
      context: context,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.description_outlined),
              title: const Text('Note'),
              onTap: () => Navigator.pop(context, NoteType.NOTE_TYPE_MARKDOWN),
            ),
            ListTile(
              leading: const Icon(Icons.event_note_outlined),
              title: const Text('Journal entry'),
              subtitle: const Text('Named by date and time, no title needed'),
              onTap: () => Navigator.pop(context, NoteType.NOTE_TYPE_JOURNAL),
            ),
            ListTile(
              leading: const Icon(Icons.checklist),
              title: const Text('Checklist'),
              onTap: () => Navigator.pop(context, NoteType.NOTE_TYPE_CHECKLIST),
            ),
          ],
        ),
      ),
    );
    if (type != null) await _open(null, type: type);
  }

  Future<void> _noteActions(NoteSummary note) async {
    final action = await showModalBottomSheet<String>(
      context: context,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(title: Text(note.title), subtitle: Text(note.path)),
            ListTile(
              leading: Icon(note.pinned ? Icons.push_pin : Icons.push_pin_outlined),
              title: Text(note.pinned ? 'Unpin' : 'Pin to top'),
              onTap: () => Navigator.pop(context, 'pin'),
            ),
            ListTile(
              leading: const Icon(Icons.drive_file_rename_outline),
              title: const Text('Rename or move'),
              onTap: () => Navigator.pop(context, 'rename'),
            ),
            ListTile(
              leading: const Icon(Icons.delete_outline),
              title: const Text('Delete'),
              onTap: () => Navigator.pop(context, 'delete'),
            ),
          ],
        ),
      ),
    );
    if (!mounted) return;
    switch (action) {
      case 'pin':
        final state = AppScope.read(context);
        try {
          await state.api.updateNoteMeta(
            UpdateNoteMetaRequest(notebookId: state.current!.id, path: note.path, pinned: !note.pinned),
          );
          state.changed();
        } catch (e) {
          if (mounted) showError(context, e);
        }
      case 'rename':
        await renameNote(context, note.path);
      case 'delete':
        await deleteNote(context, note.path, note.title);
    }
  }

  Future<void> _newFolder() async {
    final state = AppScope.read(context);
    final name = await promptText(context, title: 'New folder', label: 'Name', action: 'Create');
    if (name == null || name.trim().isEmpty) return;
    final path = _folder.isEmpty ? name.trim() : '$_folder/${name.trim()}';
    try {
      await state.api.createFolder(CreateFolderRequest(notebookId: state.current!.id, path: path));
      state.changed();
    } catch (e) {
      if (mounted) showError(context, e);
    }
  }

  String get _title {
    final nb = AppScope.of(context).current!;
    return switch (_mode) {
      _Mode.all => nb.name,
      _Mode.folder => _folder.isEmpty ? '${nb.name} /' : _folder.split('/').last,
      _Mode.tag => '#$_tag',
    };
  }

  @override
  Widget build(BuildContext context) {
    final state = AppScope.of(context);
    final theme = Theme.of(context);
    return PopScope(
      canPop: _mode == _Mode.all && !_searching,
      onPopInvokedWithResult: (didPop, _) {
        if (didPop) return;
        if (_searching) {
          setState(() {
            _searching = false;
            _search.clear();
          });
          _reload();
        } else if (_mode == _Mode.folder && _folder.isNotEmpty) {
          _show(_Mode.folder, folder: _folder.contains('/') ? _folder.substring(0, _folder.lastIndexOf('/')) : '');
        } else {
          _show(_Mode.all);
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: _searching
              ? TextField(
                  controller: _search,
                  autofocus: true,
                  decoration: const InputDecoration(hintText: 'Search notes', border: InputBorder.none),
                  onChanged: (_) => _reload(),
                )
              : Text(_title),
          actions: [
            IconButton(
              tooltip: _searching ? 'Close search' : 'Search',
              icon: Icon(_searching ? Icons.close : Icons.search),
              onPressed: () {
                setState(() {
                  _searching = !_searching;
                  _search.clear();
                });
                _reload();
              },
            ),
            const SyncButton(),
            PopupMenuButton<Object>(
              tooltip: 'View and sorting',
              icon: Icon(_view.icon),
              onSelected: (v) async {
                if (v is NotesView) {
                  await _setView(v);
                } else if (v is SortOrder) {
                  setState(() => _sort = v);
                  (await SharedPreferences.getInstance()).setInt('sort', v.value);
                  _reload();
                }
              },
              itemBuilder: (_) => [
                for (final v in NotesView.values)
                  CheckedPopupMenuItem(value: v, checked: v == _view, child: Text(v.label)),
                const PopupMenuDivider(),
                for (final (order, label) in const [
                  (SortOrder.SORT_ORDER_MODIFIED_DESC, 'Last modified'),
                  (SortOrder.SORT_ORDER_CREATED_DESC, 'Created'),
                  (SortOrder.SORT_ORDER_TITLE_ASC, 'Title'),
                  (SortOrder.SORT_ORDER_PATH_ASC, 'File name'),
                ])
                  CheckedPopupMenuItem(value: order, checked: order == _sort, child: Text('Sort: $label')),
              ],
            ),
          ],
        ),
        drawer: _Drawer(
          mode: _mode,
          onAll: () => _show(_Mode.all),
          onFolders: () => _show(_Mode.folder),
          onTag: (t) => _show(_Mode.tag, tag: t),
        ),
        floatingActionButton: GestureDetector(
          onLongPress: _newMenu,
          child: FloatingActionButton(
            tooltip: 'New note (hold for journal entry or checklist)',
            onPressed: _new,
            child: Icon(
              _view == NotesView.journal || _view == NotesView.calendar ? Icons.edit_calendar_outlined : Icons.edit,
            ),
          ),
        ),
        body: RefreshIndicator(
          onRefresh: () async {
            await state.sync();
            await _reload();
          },
          child: _body(theme),
        ),
      ),
    );
  }

  Widget _body(ThemeData theme) {
    if (_loading) return const Center(child: CircularProgressIndicator());
    final actions = NoteActions(open: (n) => _open(n), more: _noteActions);
    if (_view == NotesView.calendar && !_searching) {
      return CalendarView(
        notes: _notes,
        actions: actions,
        onNewToday: () => _open(null, type: NoteType.NOTE_TYPE_JOURNAL),
      );
    }
    final top = <Widget>[
      if (_error != null)
        Padding(
          padding: const EdgeInsets.all(16),
          child: Text(_error!, style: TextStyle(color: theme.colorScheme.error)),
        ),
      if (_mode == _Mode.folder) ...[
        if (_folder.isNotEmpty)
          ListTile(
            leading: const Icon(Icons.arrow_upward),
            title: Text(_folder),
            onTap: () => _show(
              _Mode.folder,
              folder: _folder.contains('/') ? _folder.substring(0, _folder.lastIndexOf('/')) : '',
            ),
          ),
        for (final f in _folders)
          ListTile(
            leading: const Icon(Icons.folder_outlined),
            title: Text(f.path.split('/').last),
            trailing: Text('${f.noteCount}'),
            onTap: () => _show(_Mode.folder, folder: f.path),
          ),
        ListTile(
          leading: const Icon(Icons.create_new_folder_outlined),
          title: const Text('New folder'),
          onTap: _newFolder,
        ),
        if (_notes.isNotEmpty || _folders.isNotEmpty) const Divider(height: 1),
      ],
      if (_notes.isEmpty && _error == null)
        Padding(
          padding: const EdgeInsets.all(32),
          child: Center(
            child: Text(
              _searching ? 'No notes found' : 'No notes yet. Write one with the pen button.',
              style: theme.textTheme.bodyLarge?.copyWith(color: theme.colorScheme.onSurfaceVariant),
              textAlign: TextAlign.center,
            ),
          ),
        ),
    ];
    return CustomScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      slivers: [
        SliverList.list(children: top),
        ...noteSlivers(
          context,
          _view == NotesView.calendar ? NotesView.list : _view,
          _notes,
          actions,
          byCreated: _sort == SortOrder.SORT_ORDER_CREATED_DESC,
        ),
        const SliverToBoxAdapter(child: SizedBox(height: 88)),
      ],
    );
  }
}

class _Drawer extends StatelessWidget {
  const _Drawer({required this.mode, required this.onAll, required this.onFolders, required this.onTag});

  final _Mode mode;
  final VoidCallback onAll, onFolders;
  final ValueChanged<String> onTag;

  @override
  Widget build(BuildContext context) {
    final state = AppScope.of(context);
    final nb = state.current!;
    void go(VoidCallback f) {
      Navigator.pop(context);
      f();
    }

    return NavigationDrawer(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(28, 16, 16, 8),
          child: Text('Notebooks', style: Theme.of(context).textTheme.titleSmall),
        ),
        for (final n in state.notebooks)
          ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 28),
            leading: Icon(n.id == nb.id ? Icons.book : Icons.book_outlined),
            title: Text(n.name),
            subtitle: Text(
              n.hasRemote() ? n.remote.url : 'Only on this device',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            selected: n.id == nb.id,
            onTap: () => go(() => state.select(n)),
          ),
        ListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: 28),
          leading: const Icon(Icons.add),
          title: const Text('Add notebook'),
          onTap: () => go(() => Navigator.push(context, MaterialPageRoute(builder: (_) => const SetupScreen()))),
        ),
        const Divider(),
        ListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: 28),
          leading: const Icon(Icons.notes),
          title: const Text('All notes'),
          selected: mode == _Mode.all,
          onTap: () => go(onAll),
        ),
        ListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: 28),
          leading: const Icon(Icons.folder_outlined),
          title: const Text('Folders'),
          selected: mode == _Mode.folder,
          onTap: () => go(onFolders),
        ),
        ListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: 28),
          leading: const Icon(Icons.tag),
          title: const Text('Tags'),
          selected: mode == _Mode.tag,
          onTap: () async {
            Navigator.pop(context);
            final tag = await Navigator.push<String>(context, MaterialPageRoute(builder: (_) => const TagsScreen()));
            if (tag != null) onTag(tag);
          },
        ),
        const Divider(),
        ListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: 28),
          leading: const Icon(Icons.settings_outlined),
          title: const Text('Settings'),
          onTap: () => go(() => Navigator.push(context, MaterialPageRoute(builder: (_) => const SettingsScreen()))),
        ),
      ],
    );
  }
}

class TagsScreen extends StatefulWidget {
  const TagsScreen({super.key});

  @override
  State<TagsScreen> createState() => _TagsScreenState();
}

class _TagsScreenState extends State<TagsScreen> {
  List<Tag>? _tags;
  String? _error;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_tags != null || _error != null) return;
    final state = AppScope.read(context);
    state.api
        .listTags(ListTagsRequest(notebookId: state.current!.id))
        .then((res) => setState(() => _tags = res.tags), onError: (Object e) => setState(() => _error = errorText(e)));
  }

  @override
  Widget build(BuildContext context) {
    final tags = _tags;
    return Scaffold(
      appBar: AppBar(title: const Text('Tags')),
      body: _error != null
          ? Center(child: Text(_error!))
          : tags == null
          ? const Center(child: CircularProgressIndicator())
          : tags.isEmpty
          ? const Center(child: Text('No tags. Add #tags to notes or tags: in their front matter.'))
          : ListView(
              children: [
                for (final t in tags)
                  ListTile(
                    leading: const Icon(Icons.tag),
                    title: Text(t.name),
                    trailing: Text('${t.noteCount}'),
                    onTap: () => Navigator.pop(context, t.name),
                  ),
              ],
            ),
    );
  }
}

void showError(BuildContext context, Object e) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(errorText(e))));
}

Future<String?> promptText(
  BuildContext context, {
  required String title,
  required String label,
  required String action,
  String initial = '',
}) {
  final controller = TextEditingController(text: initial);
  return showDialog<String>(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(title),
      content: TextField(
        controller: controller,
        autofocus: true,
        decoration: InputDecoration(labelText: label),
        onSubmitted: (v) => Navigator.pop(context, v),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
        FilledButton(onPressed: () => Navigator.pop(context, controller.text), child: Text(action)),
      ],
    ),
  ).whenComplete(controller.dispose);
}

/// Asks for a new path and renames; returns the renamed note.
Future<Note?> renameNote(BuildContext context, String path) async {
  final state = AppScope.read(context);
  final newPath = await promptText(
    context,
    title: 'Rename or move',
    label: 'Path in the notebook',
    action: 'Rename',
    initial: path,
  );
  if (newPath == null || newPath.trim().isEmpty || newPath.trim() == path) return null;
  try {
    final note = await state.api.renameNote(
      RenameNoteRequest(notebookId: state.current!.id, path: path, newPath: newPath.trim()),
    );
    state.changed();
    return note;
  } catch (e) {
    if (context.mounted) showError(context, e);
    return null;
  }
}

/// Asks and deletes; returns whether the note is gone.
Future<bool> deleteNote(BuildContext context, String path, String title) async {
  final state = AppScope.read(context);
  final yes = await showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('Delete note?'),
      content: Text(
        '“$title” is removed here and, after the next sync, everywhere. Git history keeps the old version.',
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancel')),
        FilledButton(onPressed: () => Navigator.pop(context, true), child: const Text('Delete')),
      ],
    ),
  );
  if (yes != true) return false;
  try {
    await state.api.deleteNote(DeleteNoteRequest(notebookId: state.current!.id, path: path));
    state.changed();
    return true;
  } catch (e) {
    if (context.mounted) showError(context, e);
    return false;
  }
}
