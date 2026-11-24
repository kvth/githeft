// What differs between Android, Linux and the web beyond the core itself:
// shared content from other apps, the background sync job and folders in
// shared storage.
export 'platform_native.dart' if (dart.library.js_interop) 'platform_web.dart';
