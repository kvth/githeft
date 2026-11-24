// Connects the app to the Go core. On Android and Linux the core is
// libgitheft.so, loaded into the app and serving gRPC on a Unix socket; on
// the web it is `githeft serve`, reached with gRPC-Web on the page's origin.
export 'backend_native.dart' if (dart.library.js_interop) 'backend_web.dart';
