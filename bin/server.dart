import 'dart:developer';
import 'dart:io';

import 'package:api_fcm/api_fcm_routers.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart';

// Configure routes.

void main(List<String> args) async {
  // Use any available host or container IP (usually `0.0.0.0`).
  final ip = InternetAddress.anyIPv4;

  // Configure a pipeline that logs requests.
  final handler = const Pipeline()
      .addMiddleware(logRequests())
      .addHandler(ApiFcmRouters().routers);

  // For running in containers, we respect the PORT environment variable.
  final port = int.parse(Platform.environment['PORT'] ?? '8080');
  final server = await serve(handler, ip, port);
  log('Server listening on port ${server.port}');
}
