import 'package:flutter/material.dart';

import '../gen/githeft/v1/githeft.pbgrpc.dart';
import '../state.dart';

/// Lets the user search for a note and pick it, e.g. to link to it.
Future<NoteSummary?> pickNote(BuildContext context, {String title = 'Link to note'}) {
  return showDialog<NoteSummary>(
    context: context,
    builder: (_) => _NotePicker(title: title),
  );
}

class _NotePicker extends StatefulWidget {
  const _NotePicker({required this.title});

  final String title;

  @override
  State<_NotePicker> createState() => _NotePickerState();
}

class _NotePickerState extends State<_NotePicker> {
  final _query = TextEditingController();
  List<NoteSummary> _notes = [];
  int _request = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _search());
  }

  @override
  void dispose() {
    _query.dispose();
    super.dispose();
  }

  Future<void> _search() async {
    final state = AppScope.read(context);
    final request = ++_request;
    try {
      final res = await state.api.listNotes(
        ListNotesRequest(notebookId: state.current!.id, recursive: true, query: _query.text),
      );
      if (mounted && request == _request) setState(() => _notes = res.notes);
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.title),
      contentPadding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
      content: SizedBox(
        width: 480,
        height: 420,
        child: Column(
          children: [
            TextField(
              controller: _query,
              autofocus: true,
              decoration: const InputDecoration(prefixIcon: Icon(Icons.search), hintText: 'Search notes'),
              onChanged: (_) => _search(),
            ),
            Expanded(
              child: ListView(
                children: [
                  for (final n in _notes)
                    ListTile(
                      title: Text(n.title, maxLines: 1, overflow: TextOverflow.ellipsis),
                      subtitle: Text(n.path, maxLines: 1, overflow: TextOverflow.ellipsis),
                      onTap: () => Navigator.pop(context, n),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
      actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel'))],
    );
  }
}
