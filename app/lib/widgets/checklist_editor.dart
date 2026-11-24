import 'package:flutter/material.dart';

/// Edits a note as a checklist: "- [ ] item" lines become checkboxes, other
/// lines stay plain text. It reads and writes the Markdown in [controller]
/// line by line, so markers, indentation and other lines are kept as they
/// are.
class ChecklistEditor extends StatefulWidget {
  const ChecklistEditor({super.key, required this.controller});

  final TextEditingController controller;

  @override
  State<ChecklistEditor> createState() => _ChecklistEditorState();
}

class _Line {
  _Line(this.prefix, this.checked, String text) : text = TextEditingController(text: text);

  /// "- " or "  * " before the checkbox; for plain lines empty.
  String prefix;

  /// Null for lines that are no checklist items.
  bool? checked;
  final TextEditingController text;
  final focus = FocusNode();
  final key = UniqueKey();

  bool get isItem => checked != null;

  String serialize() => isItem ? '$prefix[${checked! ? 'x' : ' '}] ${text.text}' : text.text;

  void dispose() {
    text.dispose();
    focus.dispose();
  }
}

final _item = RegExp(r'^(\s*[-*+]\s+)\[([ xX])\]\s?(.*)$');

class _ChecklistEditorState extends State<ChecklistEditor> {
  final _lines = <_Line>[];
  bool _trailingNewline = false;

  @override
  void initState() {
    super.initState();
    _parse(widget.controller.text);
    widget.controller.addListener(_external);
  }

  @override
  void dispose() {
    widget.controller.removeListener(_external);
    for (final l in _lines) {
      l.dispose();
    }
    super.dispose();
  }

  void _parse(String text) {
    _disposeLater(List.of(_lines));
    _lines.clear();
    _trailingNewline = text.endsWith('\n');
    final body = _trailingNewline ? text.substring(0, text.length - 1) : text;
    for (final line in body.isEmpty ? <String>[] : body.split('\n')) {
      final m = _item.firstMatch(line);
      _lines.add(m == null ? _Line('', null, line) : _Line(m.group(1)!, m.group(2)!.trim().isNotEmpty, m.group(3)!));
    }
  }

  String _serialize() => _lines.map((l) => l.serialize()).join('\n') + (_trailingNewline ? '\n' : '');

  /// The text changed from outside (a save merged other edits): start over.
  void _external() {
    if (widget.controller.text != _serialize()) setState(() => _parse(widget.controller.text));
  }

  void _write() {
    final text = _serialize();
    if (text != widget.controller.text) widget.controller.text = text;
  }

  String get _defaultPrefix => _lines.where((l) => l.isItem).firstOrNull?.prefix ?? '- ';

  void _insertItem(int index, {String text = ''}) {
    final line = _Line(_defaultPrefix, false, text);
    setState(() => _lines.insert(index, line));
    _write();
    WidgetsBinding.instance.addPostFrameCallback((_) => line.focus.requestFocus());
  }

  void _remove(_Line line) {
    setState(() => _lines.remove(line));
    _disposeLater([line]);
    _write();
  }

  /// Lines leave the tree with the next frame; their controllers go after.
  void _disposeLater(List<_Line> lines) {
    if (lines.isEmpty) return;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      for (final l in lines) {
        l.dispose();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final done = _lines.where((l) => l.checked == true).length;
    final total = _lines.where((l) => l.isItem).length;
    return Column(
      children: [
        if (total > 0)
          LinearProgressIndicator(
            value: done / total,
            minHeight: 3,
            backgroundColor: theme.colorScheme.surfaceContainer,
          ),
        Expanded(
          child: ReorderableListView.builder(
            buildDefaultDragHandles: false,
            padding: const EdgeInsets.only(bottom: 88),
            itemCount: _lines.length,
            onReorder: (from, to) {
              setState(() {
                if (to > from) to--;
                _lines.insert(to, _lines.removeAt(from));
              });
              _write();
            },
            itemBuilder: (context, i) => _row(context, i),
            footer: ListTile(
              leading: const Icon(Icons.add),
              title: const Text('Add item'),
              onTap: () => _insertItem(_lines.length),
            ),
          ),
        ),
      ],
    );
  }

  Widget _row(BuildContext context, int i) {
    final line = _lines[i];
    final theme = Theme.of(context);
    if (!line.isItem) {
      final heading = line.text.text.startsWith('#');
      return Padding(
        key: line.key,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: TextField(
          controller: line.text,
          focusNode: line.focus,
          style: heading
              ? theme.textTheme.titleLarge?.copyWith(color: theme.colorScheme.primary)
              : theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurfaceVariant),
          decoration: const InputDecoration(border: InputBorder.none, isDense: true),
          onChanged: (_) => _write(),
        ),
      );
    }
    return Row(
      key: line.key,
      children: [
        Padding(
          padding: EdgeInsets.only(left: 4 + 16.0 * (line.prefix.length - line.prefix.trimLeft().length) / 2),
          child: Checkbox(
            value: line.checked,
            onChanged: (v) {
              setState(() => line.checked = v ?? false);
              _write();
            },
          ),
        ),
        Expanded(
          child: TextField(
            controller: line.text,
            focusNode: line.focus,
            textInputAction: TextInputAction.next,
            style: theme.textTheme.bodyLarge?.copyWith(
              decoration: line.checked! ? TextDecoration.lineThrough : null,
              color: line.checked! ? theme.colorScheme.onSurfaceVariant : null,
            ),
            decoration: const InputDecoration(border: InputBorder.none, isDense: true, hintText: 'Item'),
            onChanged: (_) => _write(),
            onSubmitted: (_) => _insertItem(i + 1),
          ),
        ),
        IconButton(tooltip: 'Remove', icon: const Icon(Icons.close, size: 18), onPressed: () => _remove(line)),
        ReorderableDragStartListener(
          index: i,
          child: const Padding(padding: EdgeInsets.all(12), child: Icon(Icons.drag_handle, size: 20)),
        ),
      ],
    );
  }
}
