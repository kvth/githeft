import 'dart:ffi';
import 'dart:io';

import 'package:ffi/ffi.dart';
import 'package:grpc/grpc.dart';
import 'package:path_provider/path_provider.dart';

import '../gen/githeft/v1/githeft.pbgrpc.dart';

typedef _StartC = Pointer<Utf8> Function(Pointer<Utf8>, Pointer<Utf8>, Int32);
typedef _StartDart = Pointer<Utf8> Function(Pointer<Utf8>, Pointer<Utf8>, int);
typedef _FreeC = Void Function(Pointer<Utf8>);
typedef _FreeDart = void Function(Pointer<Utf8>);

/// The core's data directory: notebooks, keys, config and log.
String? dataDirectory;

DynamicLibrary _open() {
  if (Platform.isAndroid) return DynamicLibrary.open('libgitheft.so');
  // Next to the other libraries of the bundle: <bundle>/lib/libgitheft.so.
  final exe = File(Platform.resolvedExecutable).parent.path;
  for (final p in ['$exe/lib/libgitheft.so', 'libgitheft.so']) {
    try {
      return DynamicLibrary.open(p);
    } on ArgumentError {
      continue;
    }
  }
  throw StateError('libgitheft.so not found next to $exe');
}

/// Starts the core and returns a client for it.
Future<GitheftClient> connectBackend() async {
  final dataDir = Platform.environment['GITHEFT_DATA'] ?? (await getApplicationSupportDirectory()).path;
  // Linux allows several app windows; each gets its own socket.
  dataDirectory = dataDir;
  final socket = Platform.isAndroid ? '$dataDir/githeft.sock' : '$dataDir/githeft-$pid.sock';

  final lib = _open();
  final start = lib.lookupFunction<_StartC, _StartDart>('GitheftStart');
  final free = lib.lookupFunction<_FreeC, _FreeDart>('GitheftFree');
  final dirC = dataDir.toNativeUtf8();
  final sockC = socket.toNativeUtf8();
  try {
    // Notebooks may live outside the app's storage; on Android the system
    // only lets the core in there after the all-files permission.
    final err = start(dirC, sockC, 1);
    if (err != nullptr) {
      final msg = err.toDartString();
      free(err);
      throw StateError('Starting the core failed: $msg');
    }
  } finally {
    malloc.free(dirC);
    malloc.free(sockC);
  }

  final channel = ClientChannel(
    InternetAddress(socket, type: InternetAddressType.unix),
    port: 0,
    options: const ChannelOptions(
      // The socket path is no valid HTTP authority.
      credentials: ChannelCredentials.insecure(authority: 'githeft'),
      idleTimeout: Duration(minutes: 5),
    ),
  );
  return GitheftClient(channel);
}
