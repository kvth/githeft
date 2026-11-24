import 'package:flutter/material.dart';

/// A text controller that colours Markdown syntax while keeping the text
/// exactly as typed: the editor works on the raw file content.
class MarkdownController extends TextEditingController {
  MarkdownController({super.text});

  static final _inline = RegExp(
    r'(`[^`\n]+`)' // code
    r'|(\*\*[^*\n]+\*\*|__[^_\n]+__)' // bold
    r'|((?<![\w*])\*[^*\s][^*\n]*\*(?!\w)|(?<!\w)_[^_\s][^_\n]*_(?!\w))' // italic
    r'|(\[\[[^\]\n]+\]\]|\[[^\]\n]*\]\([^)\n]*\)|https?://\S+)' // links
    r'|((?<=^|\s)#[\p{L}\p{N}_/-]*\p{L}[\p{L}\p{N}_/-]*)', // tags
    unicode: true,
  );
  static final _heading = RegExp(r'^#{1,6} ');
  static final _listMarker = RegExp(r'^(\s*)([-*+]|\d+[.)])( \[[ xX]\])?(?= )');

  /// Highlighting long texts on every keystroke would lag.
  static const _limit = 60000;

  @override
  TextSpan buildTextSpan({required BuildContext context, TextStyle? style, required bool withComposing}) {
    final base = style ?? const TextStyle();
    if (text.length > _limit) {
      return super.buildTextSpan(context: context, style: style, withComposing: withComposing);
    }
    final colors = Theme.of(context).colorScheme;
    final muted = base.copyWith(color: colors.onSurfaceVariant);
    final mono = base.copyWith(
      fontFamily: 'monospace',
      fontFamilyFallback: const ['Courier'],
      fontSize: (base.fontSize ?? 16) * 0.92,
    );
    final spans = <InlineSpan>[];

    final lines = text.split('\n');
    var inFence = false;
    var inFront = lines.isNotEmpty && lines.first.trimRight() == '---';
    for (var i = 0; i < lines.length; i++) {
      final line = lines[i];
      final nl = i < lines.length - 1 ? '\n' : '';
      if (inFront) {
        spans.add(TextSpan(text: line + nl, style: muted));
        if (i > 0 && (line.trimRight() == '---' || line.trimRight() == '...')) inFront = false;
        continue;
      }
      if (line.trimLeft().startsWith('```') || line.trimLeft().startsWith('~~~')) {
        inFence = !inFence;
        spans.add(
          TextSpan(
            text: line + nl,
            style: mono.copyWith(color: colors.onSurfaceVariant),
          ),
        );
        continue;
      }
      if (inFence) {
        spans.add(TextSpan(text: line + nl, style: mono));
        continue;
      }
      if (_heading.hasMatch(line)) {
        spans.add(
          TextSpan(
            text: line + nl,
            style: base.copyWith(fontWeight: FontWeight.bold, color: colors.primary),
          ),
        );
        continue;
      }
      var lineStyle = base;
      var rest = line;
      if (line.startsWith('>')) {
        lineStyle = base.copyWith(color: colors.onSurfaceVariant, fontStyle: FontStyle.italic);
      }
      final marker = _listMarker.firstMatch(line);
      if (marker != null) {
        spans.add(
          TextSpan(
            text: marker.group(0),
            style: base.copyWith(color: colors.primary, fontWeight: FontWeight.bold),
          ),
        );
        rest = line.substring(marker.end);
        if ((marker.group(3) ?? '').toLowerCase().contains('x')) {
          lineStyle = lineStyle.copyWith(color: colors.onSurfaceVariant, decoration: TextDecoration.lineThrough);
        }
      }
      _inlineSpans(rest, lineStyle, mono, colors, spans);
      if (nl.isNotEmpty) spans.add(TextSpan(text: nl, style: base));
    }
    return TextSpan(style: base, children: spans);
  }

  void _inlineSpans(String s, TextStyle style, TextStyle mono, ColorScheme colors, List<InlineSpan> out) {
    var pos = 0;
    for (final m in _inline.allMatches(s)) {
      if (m.start > pos) out.add(TextSpan(text: s.substring(pos, m.start), style: style));
      final t = m.group(0)!;
      final TextStyle st;
      if (m.group(1) != null) {
        st = mono.copyWith(backgroundColor: colors.surfaceContainerHighest);
      } else if (m.group(2) != null) {
        st = style.copyWith(fontWeight: FontWeight.bold);
      } else if (m.group(3) != null) {
        st = style.copyWith(fontStyle: FontStyle.italic);
      } else if (m.group(4) != null) {
        st = style.copyWith(color: colors.primary, decoration: TextDecoration.underline);
      } else {
        st = style.copyWith(color: colors.tertiary);
      }
      out.add(TextSpan(text: t, style: st));
      pos = m.end;
    }
    if (pos < s.length) out.add(TextSpan(text: s.substring(pos), style: style));
  }

  /// Wraps the selection in [before] and [after], or inserts both with the
  /// cursor between them.
  void wrap(String before, [String? after]) {
    after ??= before;
    final sel = selection.isValid ? selection : TextSelection.collapsed(offset: text.length);
    final selected = sel.textInside(text);
    final replaced = text.replaceRange(sel.start, sel.end, '$before$selected$after');
    value = TextEditingValue(
      text: replaced,
      selection: selected.isEmpty
          ? TextSelection.collapsed(offset: sel.start + before.length)
          : TextSelection(
              baseOffset: sel.start + before.length,
              extentOffset: sel.start + before.length + selected.length,
            ),
    );
  }

  /// Inserts [s] at the cursor, replacing a selection.
  void insert(String s) {
    final sel = selection.isValid ? selection : TextSelection.collapsed(offset: text.length);
    value = TextEditingValue(
      text: text.replaceRange(sel.start, sel.end, s),
      selection: TextSelection.collapsed(offset: sel.start + s.length),
    );
  }

  /// Ticks or unticks the [index]-th "- [ ]" item of the text.
  void toggleCheckbox(int index) {
    final m = RegExp(r'^(\s*[-*+]\s+)\[([ xX])\]', multiLine: true).allMatches(text).elementAtOrNull(index);
    if (m == null) return;
    final at = m.start + m.group(1)!.length + 1;
    final checked = m.group(2)!.trim().isNotEmpty;
    value = value.copyWith(text: text.replaceRange(at, at + 1, checked ? ' ' : 'x'));
  }

  /// Puts [prefix] in front of the current line, or removes it if it is
  /// there already (for headings, lists and checkboxes).
  void toggleLinePrefix(String prefix) {
    final sel = selection.isValid ? selection : TextSelection.collapsed(offset: text.length);
    final start = sel.start == 0 ? 0 : text.lastIndexOf('\n', sel.start - 1) + 1;
    final line = text.substring(start);
    String replaced;
    int delta;
    if (line.startsWith(prefix)) {
      replaced = text.replaceRange(start, start + prefix.length, '');
      delta = -prefix.length;
    } else {
      replaced = text.replaceRange(start, start, prefix);
      delta = prefix.length;
    }
    value = TextEditingValue(
      text: replaced,
      selection: TextSelection(
        baseOffset: (sel.baseOffset + delta).clamp(start, replaced.length),
        extentOffset: (sel.extentOffset + delta).clamp(start, replaced.length),
      ),
    );
  }

  /// Continues a list when Enter is pressed at the end of a list item, and
  /// ends it on an empty item. Returns whether it handled the change.
  bool continueList(TextEditingValue old) {
    final v = value;
    if (v.text.length != old.text.length + 1 || !v.selection.isCollapsed) return false;
    final pos = v.selection.baseOffset;
    if (pos == 0 || v.text[pos - 1] != '\n') return false;
    final lineStart = pos - 1 == 0 ? 0 : v.text.lastIndexOf('\n', pos - 2) + 1;
    final prev = v.text.substring(lineStart, pos - 1);
    final m = _listMarker.firstMatch(prev);
    if (m == null) return false;
    if (prev.substring(m.end).trim().isEmpty) {
      // Enter on an empty item ends the list.
      final t = v.text.replaceRange(lineStart, pos, '');
      value = TextEditingValue(
        text: t,
        selection: TextSelection.collapsed(offset: lineStart),
      );
      return true;
    }
    var marker = m.group(2)!;
    final number = int.tryParse(marker.substring(0, marker.length - 1));
    if (number != null) marker = '${number + 1}${marker[marker.length - 1]}';
    final next = '${m.group(1)}$marker${m.group(3) != null ? ' [ ]' : ''} ';
    final t = v.text.replaceRange(pos, pos, next);
    value = TextEditingValue(
      text: t,
      selection: TextSelection.collapsed(offset: pos + next.length),
    );
    return true;
  }
}
