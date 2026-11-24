import 'dart:async';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as p;

import '../gen/githeft/v1/githeft.pbgrpc.dart';
import '../platform/platform.dart';
import '../state.dart';
import '../widgets/checklist_editor.dart';
import '../widgets/markdown_controller.dart';
import '../widgets/note_picker.dart';
import '../widgets/note_preview.dart';
import '../widgets/note_views.dart' show formatDateTime;
import 'notes_screen.dart' show deleteNote, renameNote, showError;

/// Edits one note: as Markdown, as a checklist or as a journal entry. The
/// text is saved (and committed) when leaving the editor and when the app
/// goes to the background; the notes list then syncs.
class EditorScreen extends StatefulWidget {
  const EditorScreen({
    super.key,
    required this.notebook,
    this.path,
    this.folder = '',
    this.tags = const [],
    this.type = NoteType.NOTE_TYPE_MARKDOWN,
    this.initialText = '',
    this.initialFiles = const [],
  });

  final Notebook notebook;

  /// Null for a new note.
  final String? path;

  /// Folder, tags, type and content of a new note; the files (shared from
  /// another app) are attached to it.
  final String folder;
  final List<String> tags;
  final NoteType type;
  final String initialText;
  final List<String> initialFiles;

  @override
  State<EditorScreen> createState() => _EditorScreenState();
}

class _EditorScreenState extends State<EditorScreen> with WidgetsBindingObserver {
  final _text = MarkdownController();
  final _focus = FocusNode();
  TextEditingValue _last = TextEditingValue.empty;

  String? _path;
  Note? _note;
  List<String>? _tags; // set when changed in this editor
  late NoteType _type;
  List<NoteSummary> _backlinks = [];
  bool _raw = false;
  bool _preview = false;
  bool _loading = true;
  bool _savedSomething = false;
  bool _saving = false;
  bool _attaching = false;
  String? _error;

  /// What the editor started from, to merge with changes made meanwhile.
  String _baseRevision = '', _baseContent = '';

  String get _folder => _path == null ? widget.folder : p.posix.dirname(_path!).replaceFirst(RegExp(r'^\.$'), '');

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _path = widget.path;
    _type = widget.type;
    if (widget.tags.isNotEmpty) _tags = List.of(widget.tags);
    _text.addListener(_onText);
    _load();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _text.dispose();
    _focus.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused || state == AppLifecycleState.hidden) {
      unawaited(_save());
    }
  }

  void _onText() {
    if (_text.value.text != _last.text) {
      final old = _last;
      _last = _text.value;
      if (_text.continueList(old)) _last = _text.value;
    } else {
      _last = _text.value;
    }
  }

  Future<void> _load() async {
    final path = _path;
    if (path == null) {
      _text.text = widget.initialText;
      setState(() => _loading = false);
      if (widget.initialFiles.isNotEmpty) {
        await _attachFiles([
          for (final f in widget.initialFiles)
            (p.basename(f).replaceFirst(RegExp(r'^\d+-\d+-'), ''), Device.readFile(f)),
        ]);
      }
      if (_type != NoteType.NOTE_TYPE_CHECKLIST) _focus.requestFocus();
      return;
    }
    try {
      final note = await AppScope.read(context).api.getNote(GetNoteRequest(notebookId: widget.notebook.id, path: path));
      _setNote(note);
      setState(() {
        _loading = false;
        _preview = note.body.trim().isNotEmpty && _type != NoteType.NOTE_TYPE_CHECKLIST;
      });
      unawaited(_loadBacklinks());
    } catch (e) {
      setState(() {
        _loading = false;
        _error = errorText(e);
      });
    }
  }

  Future<void> _loadBacklinks() async {
    final path = _path;
    if (path == null) return;
    try {
      final res = await AppScope.read(
        context,
      ).api.getBacklinks(GetBacklinksRequest(notebookId: widget.notebook.id, path: path));
      if (mounted) setState(() => _backlinks = res.notes);
    } catch (_) {}
  }

  void _setNote(Note note) {
    _note = note;
    _path = note.summary.path;
    _type = note.summary.type;
    _baseRevision = note.revision;
    _baseContent = _raw ? note.raw : note.body;
    _text.value = TextEditingValue(text: _baseContent);
    _last = _text.value;
  }

  bool get _dirty => _text.text != _baseContent || _tags != null;

  /// Saves if anything changed. Returns false when saving failed.
  Future<bool> _save() async {
    if (!_dirty || _saving || _error != null) return true;
    if (_path == null && _text.text.trim().isEmpty) return true;
    final state = AppScope.read(context);
    _saving = true;
    final content = _text.text;
    try {
      final res = await state.api.saveNote(
        SaveNoteRequest(
          notebookId: widget.notebook.id,
          path: _path ?? '',
          folder: widget.folder,
          content: content,
          raw: _raw,
          baseRevision: _baseRevision,
          baseContent: _baseContent,
          tags: _tags == null ? null : TagList(tags: _tags),
          type: _path == null ? _type : null,
        ),
      );
      _savedSomething = true;
      _tags = null;
      _note = res.note;
      _path = res.note.summary.path;
      _baseRevision = res.note.revision;
      final saved = _raw ? res.note.raw : res.note.body;
      // Typing may have continued while saving; only take over the saved
      // text (e.g. merged with a sync) if it did not.
      if (_text.text == content && saved != content) {
        final sel = _text.selection;
        _text.value = TextEditingValue(
          text: saved,
          selection: sel.isValid && sel.end <= saved.length ? sel : TextSelection.collapsed(offset: saved.length),
        );
      }
      _baseContent = saved;
      if (mounted) {
        setState(() {});
        if (res.conflictCopy.isNotEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'The note changed elsewhere in the same place. The other version is in ${res.conflictCopy}.',
              ),
            ),
          );
        }
      }
      return true;
    } catch (e) {
      if (mounted) showError(context, e);
      return false;
    } finally {
      _saving = false;
    }
  }

  Future<void> _close() async {
    if (await _save() && mounted) Navigator.pop(context, _savedSomething);
  }

  Future<void> _editTags() async {
    final current = _tags ?? _frontMatterTags();
    final controller = TextEditingController(text: current.join(', '));
    final res = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Tags'),
        content: TextField(
          controller: controller,
          autofocus: true,
          decoration: const InputDecoration(
            hintText: 'work, ideas',
            helperText: 'Comma separated, stored in the front matter. #tags in the text count too.',
            helperMaxLines: 2,
          ),
          onSubmitted: (v) => Navigator.pop(context, v),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          FilledButton(onPressed: () => Navigator.pop(context, controller.text), child: const Text('Set')),
        ],
      ),
    );
    controller.dispose();
    if (res == null) return;
    setState(() {
      _tags = res.split(',').map((t) => t.trim().replaceFirst(RegExp('^#'), '')).where((t) => t.isNotEmpty).toList();
    });
  }

  /// Tags from the front matter only: inline #tags are part of the text.
  List<String> _frontMatterTags() {
    final raw = _note?.raw ?? '';
    final m = RegExp(r'^tags:\s*\[(.*)\]\s*$', multiLine: true).firstMatch(raw.split('\n---').first);
    if (m == null) return [];
    return m
        .group(1)!
        .split(',')
        .map((t) => t.trim().replaceAll(RegExp('^["\']|["\']\$'), ''))
        .where((t) => t.isNotEmpty)
        .toList();
  }

  Future<void> _toggleRaw() async {
    if (!await _save()) return;
    setState(() => _raw = !_raw);
    if (_note != null) _setNote(_note!);
  }

  /// Saves first, so the note exists, then changes its front matter.
  Future<void> _updateMeta({bool? pinned, NoteType? type}) async {
    if (_path == null && _text.text.trim().isEmpty) {
      if (type != null) setState(() => _type = type);
      if (pinned != null) showError(context, 'Write something first');
      return;
    }
    if (!await _save() || !mounted) return;
    final state = AppScope.read(context);
    try {
      final note = await state.api.updateNoteMeta(
        UpdateNoteMetaRequest(notebookId: widget.notebook.id, path: _path, pinned: pinned, type: type),
      );
      _savedSomething = true;
      setState(() => _setNote(note));
    } catch (e) {
      if (mounted) showError(context, e);
    }
  }

  Future<void> _menu(String action) async {
    switch (action) {
      case 'raw':
        await _toggleRaw();
      case 'pin':
        await _updateMeta(pinned: !(_note?.summary.pinned ?? false));
      case 'checklist':
        await _updateMeta(
          type: _type == NoteType.NOTE_TYPE_CHECKLIST ? NoteType.NOTE_TYPE_MARKDOWN : NoteType.NOTE_TYPE_CHECKLIST,
        );
      case 'rename':
        if (_path == null || !await _save() || !mounted) return;
        final note = await renameNote(context, _path!);
        if (note != null) {
          _savedSomething = true;
          setState(() => _setNote(note));
        }
      case 'delete':
        if (_path == null) {
          _text.clear();
          _baseContent = '';
          if (mounted) Navigator.pop(context, false);
          return;
        }
        if (await deleteNote(context, _path!, _note?.summary.title ?? _path!) && mounted) {
          _baseContent = _text.text;
          _tags = null;
          Navigator.pop(context, true);
        }
    }
  }

  /// Asks for images (camera or gallery on Android, files elsewhere) and
  /// attaches them.
  Future<void> _pickImages() async {
    final picked = <(String, Future<Uint8List>)>[];
    if (Device.isAndroid) {
      final source = await showModalBottomSheet<ImageSource>(
        context: context,
        builder: (context) => SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.photo_camera_outlined),
                title: const Text('Take photo'),
                onTap: () => Navigator.pop(context, ImageSource.camera),
              ),
              ListTile(
                leading: const Icon(Icons.photo_library_outlined),
                title: const Text('From gallery'),
                onTap: () => Navigator.pop(context, ImageSource.gallery),
              ),
            ],
          ),
        ),
      );
      if (source == null) return;
      final picker = ImagePicker();
      final files = source == ImageSource.camera
          ? [?await picker.pickImage(source: source, maxWidth: 2560, maxHeight: 2560, imageQuality: 85)]
          : await picker.pickMultiImage(maxWidth: 2560, maxHeight: 2560, imageQuality: 85);
      for (final f in files) {
        picked.add((f.name, f.readAsBytes()));
      }
    } else {
      final files = await FilePicker.pickFiles(type: FileType.image);
      for (final f in files) {
        picked.add((f.name, f.readAsBytes()));
      }
    }
    await _attachFiles(picked);
  }

  /// Stores files next to the note and inserts links to them at the cursor.
  Future<void> _attachFiles(List<(String, Future<Uint8List>)> files) async {
    if (files.isEmpty) return;
    final state = AppScope.read(context);
    setState(() => _attaching = true);
    try {
      for (final (name, bytes) in files) {
        final res = await state.api.addAttachment(
          AddAttachmentRequest(
            notebookId: widget.notebook.id,
            notePath: _path ?? '',
            folder: _path == null ? widget.folder : '',
            fileName: name,
            data: await bytes,
          ),
          options: state.long,
        );
        _savedSomething = true;
        final sel = _text.selection;
        final atLineStart = !sel.isValid || sel.start == 0 || _text.text[sel.start - 1] == '\n';
        if (!sel.isValid) _text.selection = TextSelection.collapsed(offset: _text.text.length);
        _text.insert('${atLineStart ? '' : '\n'}${res.markdown}\n');
      }
    } catch (e) {
      if (mounted) showError(context, e);
    } finally {
      if (mounted) setState(() => _attaching = false);
    }
  }

  Future<void> _insertNoteLink() async {
    final note = await pickNote(context);
    if (note == null) return;
    _text.insert('[[${p.posix.basenameWithoutExtension(note.path)}]]');
  }

  /// Follows a link in the preview: to an existing note, or offers to
  /// create it.
  Future<void> _openLink(String target) async {
    final state = AppScope.read(context);
    final from = _path ?? p.posix.join(_folder, 'new.md');
    try {
      final res = await state.api.resolveLink(
        ResolveLinkRequest(notebookId: widget.notebook.id, fromPath: from, target: target),
      );
      if (!mounted) return;
      if (res.path.isNotEmpty) {
        await _openOther(path: res.path);
        return;
      }
      final name = p.posix.basenameWithoutExtension(Uri.decodeComponent(target));
      final create = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('No note “$name”'),
          content: const Text('Create it?'),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancel')),
            FilledButton(onPressed: () => Navigator.pop(context, true), child: const Text('Create')),
          ],
        ),
      );
      if (create == true) await _openOther(newTitle: name);
    } catch (e) {
      if (mounted) showError(context, e);
    }
  }

  Future<void> _openOther({String? path, String? newTitle}) async {
    if (!await _save() || !mounted) return;
    final changed = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (_) => EditorScreen(
          notebook: widget.notebook,
          path: path,
          folder: _folder,
          initialText: newTitle == null ? '' : '# $newTitle\n\n',
        ),
      ),
    );
    if (changed == true) {
      _savedSomething = true;
      unawaited(_loadBacklinks());
    }
  }

  String get _title {
    if (_note != null) return _note!.summary.title;
    if (_type == NoteType.NOTE_TYPE_JOURNAL) return formatDateTime(DateTime.now());
    if (_type == NoteType.NOTE_TYPE_CHECKLIST) return 'New checklist';
    return _path == null ? 'New note' : p.posix.basename(_path!);
  }

  @override
  Widget build(BuildContext context) {
    final checklist = _type == NoteType.NOTE_TYPE_CHECKLIST && !_raw;
    final pinned = _note?.summary.pinned ?? false;
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) _close();
      },
      child: CallbackShortcuts(
        bindings: {
          const SingleActivator(LogicalKeyboardKey.keyS, control: true): () => _save(),
          const SingleActivator(LogicalKeyboardKey.keyB, control: true): () => _text.wrap('**'),
          const SingleActivator(LogicalKeyboardKey.keyI, control: true): () => _text.wrap('*'),
          const SingleActivator(LogicalKeyboardKey.keyE, control: true): () => setState(() => _preview = !_preview),
          const SingleActivator(LogicalKeyboardKey.keyK, control: true): _insertNoteLink,
        },
        child: Scaffold(
          appBar: AppBar(
            leading: BackButton(onPressed: _close),
            title: Text(_title, maxLines: 1, overflow: TextOverflow.ellipsis),
            actions: [
              if (pinned) const Padding(padding: EdgeInsets.all(8), child: Icon(Icons.push_pin, size: 20)),
              if (!checklist)
                IconButton(
                  tooltip: _preview ? 'Edit' : 'Preview',
                  icon: Icon(_preview ? Icons.edit_outlined : Icons.visibility_outlined),
                  onPressed: _loading || _error != null ? null : () => setState(() => _preview = !_preview),
                ),
              if (!_raw)
                IconButton(
                  tooltip: 'Tags',
                  icon: Badge(isLabelVisible: _tags != null, smallSize: 6, child: const Icon(Icons.label_outline)),
                  onPressed: _loading || _error != null ? null : _editTags,
                ),
              PopupMenuButton<String>(
                onSelected: _menu,
                itemBuilder: (_) => [
                  PopupMenuItem(value: 'pin', child: Text(pinned ? 'Unpin' : 'Pin to top')),
                  CheckedPopupMenuItem(
                    value: 'checklist',
                    checked: _type == NoteType.NOTE_TYPE_CHECKLIST,
                    child: const Text('Checklist'),
                  ),
                  CheckedPopupMenuItem(value: 'raw', checked: _raw, child: const Text('Edit whole file')),
                  if (_path != null) const PopupMenuItem(value: 'rename', child: Text('Rename or move')),
                  PopupMenuItem(value: 'delete', child: Text(_path == null ? 'Discard' : 'Delete')),
                ],
              ),
            ],
            bottom: _attaching
                ? const PreferredSize(preferredSize: Size.fromHeight(3), child: LinearProgressIndicator(minHeight: 3))
                : null,
          ),
          body: _body(checklist),
        ),
      ),
    );
  }

  Widget _body(bool checklist) {
    if (_loading) return const Center(child: CircularProgressIndicator());
    if (_error != null) {
      return Center(
        child: Padding(padding: const EdgeInsets.all(24), child: Text(_error!)),
      );
    }
    if (checklist) return ChecklistEditor(controller: _text);
    if (_preview) {
      return GestureDetector(
        onDoubleTap: () => setState(() => _preview = false),
        child: NotePreview(
          notebookId: widget.notebook.id,
          folder: _folder,
          text: _text.text,
          backlinks: _backlinks,
          onOpenLink: _openLink,
          onOpenNote: (n) => _openOther(path: n.path),
          onToggleCheckbox: (i) => setState(() => _text.toggleCheckbox(i)),
        ),
      );
    }
    final theme = Theme.of(context);
    return Column(
      children: [
        Expanded(
          child: TextField(
            controller: _text,
            focusNode: _focus,
            expands: true,
            maxLines: null,
            minLines: null,
            keyboardType: TextInputType.multiline,
            textCapitalization: TextCapitalization.sentences,
            textAlignVertical: TextAlignVertical.top,
            style: theme.textTheme.bodyLarge,
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
              hintText: _path != null
                  ? null
                  : _type == NoteType.NOTE_TYPE_JOURNAL
                  ? 'What happened today?'
                  : '# Title\n\nWrite here…',
            ),
          ),
        ),
        _Toolbar(controller: _text, onImage: _pickImages, onNoteLink: _insertNoteLink),
      ],
    );
  }
}

class _Toolbar extends StatelessWidget {
  const _Toolbar({required this.controller, required this.onImage, required this.onNoteLink});

  final MarkdownController controller;
  final VoidCallback onImage, onNoteLink;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    Widget button(IconData icon, String tip, VoidCallback onPressed) =>
        IconButton(icon: Icon(icon), tooltip: tip, onPressed: onPressed, visualDensity: VisualDensity.compact);
    return Material(
      color: theme.colorScheme.surfaceContainer,
      child: SafeArea(
        top: false,
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              button(Icons.title, 'Heading', () => controller.toggleLinePrefix('# ')),
              button(Icons.format_bold, 'Bold', () => controller.wrap('**')),
              button(Icons.format_italic, 'Italic', () => controller.wrap('*')),
              button(Icons.check_box_outlined, 'Checkbox', () => controller.toggleLinePrefix('- [ ] ')),
              button(Icons.format_list_bulleted, 'List', () => controller.toggleLinePrefix('- ')),
              button(Icons.image_outlined, 'Image', onImage),
              button(Icons.note_alt_outlined, 'Link to note', onNoteLink),
              button(Icons.link, 'Link', () => controller.wrap('[', '](https://)')),
              button(Icons.format_list_numbered, 'Numbered list', () => controller.toggleLinePrefix('1. ')),
              button(Icons.format_quote, 'Quote', () => controller.toggleLinePrefix('> ')),
              button(Icons.code, 'Code', () => controller.wrap('`')),
              button(Icons.tag, 'Tag', () => controller.wrap('#', '')),
            ],
          ),
        ),
      ),
    );
  }
}
