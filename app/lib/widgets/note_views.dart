import 'package:fixnum/fixnum.dart';
import 'package:flutter/material.dart';

import '../gen/githeft/v1/githeft.pbgrpc.dart';

/// How the notes list looks.
enum NotesView {
  list('List', Icons.view_list_outlined),
  journal('Journal', Icons.event_note_outlined),
  grid('Grid', Icons.grid_view_outlined),
  cards('Cards', Icons.view_agenda_outlined),
  calendar('Calendar', Icons.calendar_month_outlined);

  const NotesView(this.label, this.icon);
  final String label;
  final IconData icon;
}

String _two(int v) => v.toString().padLeft(2, '0');

const _weekdays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
const _months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
const _monthNames = [
  'January', 'February', 'March', 'April', 'May', 'June', //
  'July', 'August', 'September', 'October', 'November', 'December',
];

DateTime fromUnix(Int64 t) => DateTime.fromMillisecondsSinceEpoch(t.toInt() * 1000);

/// Time today, day and month this year, else the full date.
String formatDate(int unixSeconds) {
  if (unixSeconds <= 0) return '';
  final d = DateTime.fromMillisecondsSinceEpoch(unixSeconds * 1000);
  final now = DateTime.now();
  if (d.year == now.year && d.month == now.month && d.day == now.day) return '${_two(d.hour)}:${_two(d.minute)}';
  if (d.year == now.year) return '${d.day}.${d.month}.';
  return '${d.day}.${d.month}.${d.year}';
}

/// "Tue 24 Nov 2026, 17:05"
String formatDateTime(DateTime d) =>
    '${_weekdays[d.weekday - 1]} ${d.day} ${_months[d.month - 1]} ${d.year}, ${_two(d.hour)}:${_two(d.minute)}';

/// "Tuesday 24 November 2026" style header for journal days.
String formatDay(DateTime d) {
  const long = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'];
  return '${long[d.weekday - 1]}, ${d.day} ${_monthNames[d.month - 1]} ${d.year}';
}

/// The callbacks every view needs.
class NoteActions {
  const NoteActions({required this.open, required this.more});

  final ValueChanged<NoteSummary> open;
  final ValueChanged<NoteSummary> more;
}

/// The slivers for [notes] in [view] (all views but the calendar): pinned
/// notes first, then the others; the journal view groups them by day.
List<Widget> noteSlivers(
  BuildContext context,
  NotesView view,
  List<NoteSummary> notes,
  NoteActions actions, {
  bool byCreated = false,
}) {
  final pinned = notes.where((n) => n.pinned).toList();
  final others = notes.where((n) => !n.pinned).toList();
  final slivers = <Widget>[];
  void section(String title) => slivers.add(SliverToBoxAdapter(child: SectionHeader(title)));
  void add(List<NoteSummary> list) {
    switch (view) {
      case NotesView.grid:
        slivers.add(
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            sliver: SliverGrid.builder(
              gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 220,
                mainAxisExtent: 190,
                crossAxisSpacing: 4,
                mainAxisSpacing: 4,
              ),
              itemCount: list.length,
              itemBuilder: (_, i) => NoteGridTile(note: list[i], actions: actions),
            ),
          ),
        );
      case NotesView.cards:
        slivers.add(
          SliverList.builder(
            itemCount: list.length,
            itemBuilder: (_, i) => NoteCard(note: list[i], actions: actions),
          ),
        );
      case NotesView.journal:
        DateTime? day;
        final children = <Widget>[];
        for (final n in list) {
          final d = fromUnix(byCreated ? n.created : n.modified);
          final nd = DateTime(d.year, d.month, d.day);
          if (nd != day) {
            day = nd;
            children.add(SectionHeader(formatDay(nd)));
          }
          children.add(NoteTile(note: n, actions: actions, journal: true));
        }
        slivers.add(SliverList.list(children: children));
      default:
        slivers.add(
          SliverList.builder(
            itemCount: list.length,
            itemBuilder: (_, i) => NoteTile(note: list[i], actions: actions),
          ),
        );
    }
  }

  if (pinned.isNotEmpty) {
    section('Pinned');
    add(pinned);
    if (others.isNotEmpty && view != NotesView.journal) section('Others');
  }
  add(others);
  return slivers;
}

class SectionHeader extends StatelessWidget {
  const SectionHeader(this.title, {super.key});

  final String title;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
      child: Text(title, style: theme.textTheme.titleSmall?.copyWith(color: theme.colorScheme.primary)),
    );
  }
}

Widget _typeIcon(BuildContext context, NoteSummary n) {
  final colors = Theme.of(context).colorScheme;
  if (n.conflict) return Icon(Icons.call_split, size: 18, color: colors.error);
  return switch (n.type) {
    NoteType.NOTE_TYPE_CHECKLIST => Icon(Icons.checklist, size: 18, color: colors.primary),
    NoteType.NOTE_TYPE_JOURNAL => Icon(Icons.event_note_outlined, size: 18, color: colors.primary),
    _ => const SizedBox.shrink(),
  };
}

String _meta(NoteSummary n) =>
    [if (n.path.contains('/')) n.path.substring(0, n.path.lastIndexOf('/')), ...n.tags.map((t) => '#$t')].join('  ');

/// A row in the list and journal views.
class NoteTile extends StatelessWidget {
  const NoteTile({super.key, required this.note, required this.actions, this.journal = false});

  final NoteSummary note;
  final NoteActions actions;

  /// Journal view: the time instead of the date, the excerpt first.
  final bool journal;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final muted = theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant);
    final icon = _typeIcon(context, note);
    final when = journal
        ? () {
            final d = fromUnix(note.type == NoteType.NOTE_TYPE_JOURNAL ? note.created : note.modified);
            return '${_two(d.hour)}:${_two(d.minute)}';
          }()
        : formatDate(note.modified.toInt());
    final showTitle = !(journal && note.type == NoteType.NOTE_TYPE_JOURNAL);
    final meta = _meta(note);
    return InkWell(
      onTap: () => actions.open(note),
      onLongPress: () => actions.more(note),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                if (icon is! SizedBox) Padding(padding: const EdgeInsets.only(right: 6), child: icon),
                Expanded(
                  child: showTitle
                      ? Text(
                          note.title,
                          style: theme.textTheme.titleMedium,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        )
                      : Text(
                          note.excerpt,
                          style: theme.textTheme.bodyLarge,
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                        ),
                ),
                const SizedBox(width: 8),
                if (note.pinned) Icon(Icons.push_pin, size: 14, color: theme.colorScheme.onSurfaceVariant),
                Text(when, style: muted),
              ],
            ),
            if (showTitle && note.excerpt.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 2),
                child: Text(
                  note.excerpt,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.bodyMedium,
                ),
              ),
            if (meta.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Text(meta, style: muted, maxLines: 1, overflow: TextOverflow.ellipsis),
              ),
          ],
        ),
      ),
    );
  }
}

/// A tile in the grid view.
class NoteGridTile extends StatelessWidget {
  const NoteGridTile({super.key, required this.note, required this.actions});

  final NoteSummary note;
  final NoteActions actions;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final icon = _typeIcon(context, note);
    return Card.outlined(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => actions.open(note),
        onLongPress: () => actions.more(note),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  if (icon is! SizedBox) Padding(padding: const EdgeInsets.only(right: 4), child: icon),
                  Expanded(
                    child: Text(
                      note.title,
                      style: theme.textTheme.titleSmall,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  if (note.pinned) const Icon(Icons.push_pin, size: 14),
                ],
              ),
              const SizedBox(height: 6),
              Expanded(
                child: Text(note.excerpt, style: theme.textTheme.bodySmall, overflow: TextOverflow.fade),
              ),
              const SizedBox(height: 4),
              Text(
                formatDate(note.modified.toInt()),
                style: theme.textTheme.labelSmall?.copyWith(color: theme.colorScheme.onSurfaceVariant),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// A card in the cards view: more of the text and the tags as chips.
class NoteCard extends StatelessWidget {
  const NoteCard({super.key, required this.note, required this.actions});

  final NoteSummary note;
  final NoteActions actions;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final icon = _typeIcon(context, note);
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => actions.open(note),
        onLongPress: () => actions.more(note),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  if (icon is! SizedBox) Padding(padding: const EdgeInsets.only(right: 6), child: icon),
                  Expanded(child: Text(note.title, style: theme.textTheme.titleMedium)),
                  if (note.pinned) const Icon(Icons.push_pin, size: 16),
                ],
              ),
              if (note.excerpt.isNotEmpty) ...[
                const SizedBox(height: 8),
                Text(note.excerpt, style: theme.textTheme.bodyMedium, maxLines: 6, overflow: TextOverflow.ellipsis),
              ],
              const SizedBox(height: 8),
              Wrap(
                spacing: 6,
                runSpacing: 4,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  Text(
                    formatDate(note.modified.toInt()),
                    style: theme.textTheme.labelSmall?.copyWith(color: theme.colorScheme.onSurfaceVariant),
                  ),
                  for (final t in note.tags)
                    Chip(label: Text('#$t'), visualDensity: VisualDensity.compact, padding: EdgeInsets.zero),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// A month of the notes, by creation day, with the notes of the chosen day
/// below.
class CalendarView extends StatefulWidget {
  const CalendarView({super.key, required this.notes, required this.actions, required this.onNewToday});

  final List<NoteSummary> notes;
  final NoteActions actions;

  /// Writing an entry for today.
  final VoidCallback onNewToday;

  @override
  State<CalendarView> createState() => _CalendarViewState();
}

class _CalendarViewState extends State<CalendarView> {
  late DateTime _month;
  late DateTime _day;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _month = DateTime(now.year, now.month);
    _day = DateTime(now.year, now.month, now.day);
  }

  DateTime _dayOf(NoteSummary n) {
    final d = fromUnix(n.created);
    return DateTime(d.year, d.month, d.day);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final counts = <DateTime, int>{};
    for (final n in widget.notes) {
      counts.update(_dayOf(n), (c) => c + 1, ifAbsent: () => 1);
    }
    final first = _month;
    final lead = first.weekday - 1; // Monday first
    final days = DateUtils.getDaysInMonth(first.year, first.month);
    final today = DateUtils.dateOnly(DateTime.now());
    final dayNotes = widget.notes.where((n) => _dayOf(n) == _day).toList();

    Widget cell(int i) {
      final dayNumber = i - lead + 1;
      if (dayNumber < 1 || dayNumber > days) return const SizedBox.shrink();
      final d = DateTime(first.year, first.month, dayNumber);
      final count = counts[d] ?? 0;
      final selected = d == _day;
      return InkWell(
        customBorder: const CircleBorder(),
        onTap: () => setState(() => _day = d),
        child: Container(
          margin: const EdgeInsets.all(2),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: selected ? theme.colorScheme.primary : null,
            border: d == today && !selected ? Border.all(color: theme.colorScheme.primary) : null,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '$dayNumber',
                style: TextStyle(
                  color: selected ? theme.colorScheme.onPrimary : null,
                  fontWeight: count > 0 ? FontWeight.bold : null,
                ),
              ),
              if (count > 0)
                Container(
                  width: 5,
                  height: 5,
                  margin: const EdgeInsets.only(top: 2),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: selected ? theme.colorScheme.onPrimary : theme.colorScheme.tertiary,
                  ),
                ),
            ],
          ),
        ),
      );
    }

    return CustomScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      slivers: [
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Row(
              children: [
                IconButton(
                  tooltip: 'Previous month',
                  icon: const Icon(Icons.chevron_left),
                  onPressed: () => setState(() => _month = DateTime(_month.year, _month.month - 1)),
                ),
                Expanded(
                  child: Text(
                    '${_monthNames[_month.month - 1]} ${_month.year}',
                    textAlign: TextAlign.center,
                    style: theme.textTheme.titleMedium,
                  ),
                ),
                IconButton(
                  tooltip: 'Next month',
                  icon: const Icon(Icons.chevron_right),
                  onPressed: () => setState(() => _month = DateTime(_month.year, _month.month + 1)),
                ),
              ],
            ),
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          sliver: SliverGrid.count(
            crossAxisCount: 7,
            childAspectRatio: 1.1,
            children: [
              for (final w in _weekdays) Center(child: Text(w.substring(0, 2), style: theme.textTheme.labelSmall)),
              for (var i = 0; i < lead + days; i++) cell(i),
            ],
          ),
        ),
        SliverToBoxAdapter(
          child: Row(
            children: [
              Expanded(child: SectionHeader(formatDay(_day))),
              if (_day == today)
                TextButton.icon(
                  onPressed: widget.onNewToday,
                  icon: const Icon(Icons.add, size: 18),
                  label: const Text('Entry'),
                ),
            ],
          ),
        ),
        if (dayNotes.isEmpty)
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Text('Nothing written on this day.', style: TextStyle(color: theme.colorScheme.onSurfaceVariant)),
            ),
          ),
        SliverList.builder(
          itemCount: dayNotes.length,
          itemBuilder: (_, i) => NoteTile(note: dayNotes[i], actions: widget.actions, journal: true),
        ),
        const SliverToBoxAdapter(child: SizedBox(height: 88)),
      ],
    );
  }
}
