import 'dart:io';

import 'package:flutter/services.dart';

import '../backend/backend_native.dart' show dataDirectory;
import 'shared_content.dart';

export 'shared_content.dart';

const _channel = MethodChannel('githeft/platform');

/// Android and Linux.
class Device {
  static bool get isAndroid => Platform.isAndroid;
  static bool get isLinux => Platform.isLinux;
  static bool get isWeb => false;

  /// Folders can be opened by path; on Android after granting the
  /// all-files permission.
  static bool get canOpenFolders => true;

  /// What another app shared when it started Githeft, once.
  static Future<SharedContent?> takeShare() async {
    if (!isAndroid) return null;
    final m = await _channel.invokeMethod<Map<Object?, Object?>>('takeShare');
    return m == null ? null : SharedContent.fromMap(m);
  }

  /// Shares that arrive while the app runs.
  static void onShared(void Function(SharedContent) handler) {
    if (!isAndroid) return;
    _channel.setMethodCallHandler((call) async {
      if (call.method == 'shared') handler(SharedContent.fromMap(call.arguments as Map<Object?, Object?>));
    });
  }

  static bool get backgroundSyncSupported => isAndroid || isLinux;

  /// Syncs every [minutes] while the app is closed, or stops that for 0:
  /// WorkManager on Android, a systemd user timer on Linux.
  static Future<void> scheduleBackgroundSync(int minutes) async {
    if (isAndroid) {
      await _channel.invokeMethod('scheduleSync', {'minutes': minutes});
    } else if (isLinux) {
      await _systemdTimer(minutes);
    }
  }

  static Future<void> _systemdTimer(int minutes) async {
    final home = Platform.environment['HOME'];
    if (home == null) throw StateError('HOME is not set');
    final units = Directory('${Platform.environment['XDG_CONFIG_HOME'] ?? '$home/.config'}/systemd/user');
    final service = File('${units.path}/githeft-sync.service');
    final timer = File('${units.path}/githeft-sync.timer');
    Future<void> systemctl(List<String> args) async {
      final r = await Process.run('systemctl', ['--user', ...args]);
      if (r.exitCode != 0) throw StateError('systemctl ${args.join(' ')}: ${r.stderr}');
    }

    if (minutes <= 0) {
      if (await timer.exists()) {
        await systemctl(['disable', '--now', 'githeft-sync.timer']);
        await timer.delete();
        if (await service.exists()) await service.delete();
        await systemctl(['daemon-reload']);
      }
      return;
    }
    final cli = '${File(Platform.resolvedExecutable).parent.path}/githeft-cli';
    if (!await File(cli).exists()) throw StateError('$cli is missing next to the app');
    await units.create(recursive: true);
    await service.writeAsString('''
[Unit]
Description=Sync Githeft notebooks
After=network-online.target

[Service]
Type=oneshot
ExecStart="$cli" -data "$dataDirectory" sync -auto
''');
    await timer.writeAsString('''
[Unit]
Description=Sync Githeft notebooks every $minutes minutes

[Timer]
OnBootSec=5min
OnUnitActiveSec=${minutes}min
Persistent=true

[Install]
WantedBy=timers.target
''');
    await systemctl(['daemon-reload']);
    await systemctl(['enable', '--now', 'githeft-sync.timer']);
  }

  static Future<bool> hasAllFilesAccess() async {
    if (!isAndroid) return true;
    return await _channel.invokeMethod<bool>('hasAllFilesAccess') ?? false;
  }

  /// Opens Android's settings page for the all-files permission.
  static Future<void> requestAllFilesAccess() async {
    if (isAndroid) await _channel.invokeMethod('requestAllFilesAccess');
  }

  /// /storage/emulated/0 on Android.
  static Future<String?> sharedStorageDir() async {
    if (!isAndroid) return null;
    return _channel.invokeMethod<String>('sharedStorageDir');
  }

  /// Turns the folder URI Android's picker returns into a path:
  /// content://…/tree/primary%3ADocuments%2FNotes is
  /// /storage/emulated/0/Documents/Notes.
  static String? treeUriToPath(Uri uri, String storageDir) {
    if (uri.scheme == 'file') return uri.toFilePath();
    final i = uri.pathSegments.indexOf('tree');
    if (i < 0 || i + 1 >= uri.pathSegments.length) return null;
    final id = Uri.decodeComponent(uri.pathSegments[i + 1]);
    final colon = id.indexOf(':');
    if (colon < 0) return null;
    final volume = id.substring(0, colon), rest = id.substring(colon + 1);
    final root = volume == 'primary' ? storageDir : '/storage/$volume';
    return rest.isEmpty ? root : '$root/$rest';
  }

  static Future<Uint8List> readFile(String path) => File(path).readAsBytes();
}
