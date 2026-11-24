import 'dart:typed_data';

import 'shared_content.dart';

export 'shared_content.dart';

/// The web version: the server does the background sync (`githeft serve
/// -sync-every`) and owns the folders.
class Device {
  static bool get isAndroid => false;
  static bool get isLinux => false;
  static bool get isWeb => true;

  /// Folders can be opened by path (on the server).
  static bool get canOpenFolders => true;

  static Future<SharedContent?> takeShare() async => null;
  static void onShared(void Function(SharedContent) handler) {}

  static bool get backgroundSyncSupported => false;
  static Future<void> scheduleBackgroundSync(int minutes) async {}

  static Future<bool> hasAllFilesAccess() async => true;
  static Future<void> requestAllFilesAccess() async {}
  static Future<String?> sharedStorageDir() async => null;
  static String? treeUriToPath(Uri uri, String storageDir) => null;

  static Future<Uint8List> readFile(String path) => throw UnsupportedError('no files on the web');
}
