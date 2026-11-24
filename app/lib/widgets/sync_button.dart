import 'package:flutter/material.dart';

import '../gen/githeft/v1/githeft.pbgrpc.dart';
import '../screens/settings_screen.dart';
import '../state.dart';

/// Shows the sync state of the open notebook; tapping syncs, or explains
/// the last error.
class SyncButton extends StatelessWidget {
  const SyncButton({super.key});

  @override
  Widget build(BuildContext context) {
    final state = AppScope.of(context);
    final st = state.status;
    final colors = Theme.of(context).colorScheme;
    if (state.syncing) {
      return const Padding(
        padding: EdgeInsets.all(14),
        child: SizedBox.square(dimension: 20, child: CircularProgressIndicator(strokeWidth: 2)),
      );
    }
    final (icon, color, tip) = switch (st?.state) {
      SyncState.SYNC_STATE_ERROR => (Icons.sync_problem, colors.error, 'Sync failed'),
      SyncState.SYNC_STATE_LOCAL_ONLY => (Icons.cloud_off_outlined, null, 'Only on this device'),
      _ when (st?.ahead ?? 0) > 0 || (st?.pendingChanges ?? 0) > 0 => (
        Icons.cloud_upload_outlined,
        null,
        'Changes not synced yet',
      ),
      _ => (Icons.cloud_done_outlined, null, _lastSync(st)),
    };
    return IconButton(
      tooltip: tip,
      icon: Icon(icon, color: color),
      onPressed: () async {
        if (st?.state == SyncState.SYNC_STATE_LOCAL_ONLY) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('This notebook has no git remote.'),
              action: SnackBarAction(
                label: 'Add one',
                onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const SettingsScreen())),
              ),
            ),
          );
          return;
        }
        if (st?.state == SyncState.SYNC_STATE_ERROR) {
          final retry = await showDialog<bool>(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('Sync failed'),
              content: SingleChildScrollView(child: SelectableText(st!.error)),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context, false);
                    Navigator.push(context, MaterialPageRoute(builder: (_) => const SettingsScreen()));
                  },
                  child: const Text('Remote settings'),
                ),
                FilledButton(onPressed: () => Navigator.pop(context, true), child: const Text('Try again')),
              ],
            ),
          );
          if (retry != true) return;
        }
        final res = await state.sync();
        if (!context.mounted || res == null) return;
        final messenger = ScaffoldMessenger.of(context);
        if (res.state == SyncState.SYNC_STATE_ERROR) {
          messenger.showSnackBar(SnackBar(content: Text(res.error)));
        }
      },
    );
  }

  static String _lastSync(SyncStatus? st) {
    final t = st?.lastSync.toInt() ?? 0;
    if (t == 0) return 'Sync';
    final d = DateTime.fromMillisecondsSinceEpoch(t * 1000);
    return 'Synced at ${d.hour.toString().padLeft(2, '0')}:${d.minute.toString().padLeft(2, '0')}';
  }
}
