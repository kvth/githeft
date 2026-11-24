import 'package:grpc/grpc_web.dart';

import '../gen/githeft/v1/githeft.pbgrpc.dart';

/// Talks gRPC-Web to the `githeft serve` that served this page.
Future<GitheftClient> connectBackend() async {
  final origin = Uri.base.replace(path: '/', query: '', fragment: '');
  return GitheftClient(GrpcWebClientChannel.xhr(origin));
}
