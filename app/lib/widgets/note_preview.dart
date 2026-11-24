import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_markdown_plus/flutter_markdown_plus.dart';
import 'package:markdown/markdown.dart' as md;
import 'package:path/path.dart' as p;
import 'package:url_launcher/url_launcher.dart';

import '../gen/githeft/v1/githeft.pbgrpc.dart';
import '../state.dart';

/// [[Target]] and [[Target|label]] become links with the href wiki:Target.
class WikiLinkSyntax extends md.InlineSyntax {
  WikiLinkSyntax() : super(r'\[\[([^\]|\n]+)(?:\|([^\]\n]+))?\]\]');

  @override
  bool onMatch(md.InlineParser parser, Match match) {
    final target = match[1]!.trim();
    final el = md.Element.text('a', (match[2] ?? match[1]!).trim())
      ..attributes['href'] = 'wiki:${Uri.encodeComponent(target)}';
    parser.addNode(el);
    return true;
  }
}

/// The rendered note: images from the notebook, links to other notes and
/// the notes that link here.
class NotePreview extends StatelessWidget {
  const NotePreview({
    super.key,
    required this.notebookId,
    required this.folder,
    required this.text,
    required this.backlinks,
    required this.onOpenLink,
    required this.onOpenNote,
    this.onToggleCheckbox,
  });

  final String notebookId;

  /// Folder of the note, for relative image paths.
  final String folder;
  final String text;
  final List<NoteSummary> backlinks;

  /// A link to another note: a wiki link target or a relative href.
  final ValueChanged<String> onOpenLink;
  final ValueChanged<NoteSummary> onOpenNote;

  /// Tapping the n-th checkbox of the note.
  final ValueChanged<int>? onToggleCheckbox;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    var checkbox = 0;
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 88),
      children: [
        MarkdownBody(
          data: text,
          selectable: onToggleCheckbox == null,
          inlineSyntaxes: [WikiLinkSyntax()],
          imageBuilder: (uri, title, alt) => NoteImage(notebookId: notebookId, folder: folder, uri: uri, alt: alt),
          checkboxBuilder: onToggleCheckbox == null
              ? null
              : (value) {
                  final index = checkbox++;
                  return Padding(
                    padding: const EdgeInsets.only(right: 4),
                    child: SizedBox.square(
                      dimension: 22,
                      child: Checkbox(value: value, onChanged: (_) => onToggleCheckbox!(index)),
                    ),
                  );
                },
          onTapLink: (text, href, title) {
            if (href == null) return;
            if (href.startsWith('wiki:')) {
              onOpenLink(Uri.decodeComponent(href.substring(5)));
              return;
            }
            final uri = Uri.tryParse(href);
            if (uri != null && uri.hasScheme) {
              launchUrl(uri, mode: LaunchMode.externalApplication);
            } else if (!href.startsWith('#')) {
              onOpenLink(href);
            }
          },
        ),
        if (backlinks.isNotEmpty) ...[
          const SizedBox(height: 24),
          const Divider(),
          Text(
            backlinks.length == 1 ? '1 note links here' : '${backlinks.length} notes link here',
            style: theme.textTheme.titleSmall?.copyWith(color: theme.colorScheme.primary),
          ),
          for (final n in backlinks)
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.link),
              title: Text(n.title),
              subtitle: n.excerpt.isEmpty ? null : Text(n.excerpt, maxLines: 1, overflow: TextOverflow.ellipsis),
              onTap: () => onOpenNote(n),
            ),
        ],
      ],
    );
  }
}

/// An image in a note: from the web, or a file in the notebook relative to
/// the note's folder, fetched through the core.
class NoteImage extends StatelessWidget {
  const NoteImage({super.key, required this.notebookId, required this.folder, required this.uri, this.alt});

  final String notebookId;
  final String folder;
  final Uri uri;
  final String? alt;

  static final _cache = <String, Future<GetFileResponse>>{};

  /// Forget cached images, e.g. after a sync changed them.
  static void clearCache() => _cache.clear();

  @override
  Widget build(BuildContext context) {
    Widget broken(Object? e) => Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          const Icon(Icons.broken_image_outlined),
          const SizedBox(width: 8),
          Flexible(child: Text(alt?.isNotEmpty == true ? alt! : uri.toString())),
        ],
      ),
    );
    if (uri.scheme == 'http' || uri.scheme == 'https') {
      return Image.network(uri.toString(), errorBuilder: (_, e, _) => broken(e));
    }
    final rel = p.posix.normalize(p.posix.join(folder, Uri.decodeComponent(uri.path)));
    if (rel.startsWith('..')) return broken(null);
    final key = '$notebookId/$rel';
    final future = _cache.putIfAbsent(
      key,
      () => AppScope.read(context).api.getFile(GetFileRequest(notebookId: notebookId, path: rel)),
    );
    return FutureBuilder<GetFileResponse>(
      future: future,
      builder: (context, snap) {
        if (snap.hasError) {
          _cache.remove(key);
          return broken(snap.error);
        }
        if (!snap.hasData) return const SizedBox(height: 120, child: Center(child: CircularProgressIndicator()));
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Image.memory(
            Uint8List.fromList(snap.data!.data),
            semanticLabel: alt,
            errorBuilder: (_, e, _) => broken(e),
          ),
        );
      },
    );
  }
}
