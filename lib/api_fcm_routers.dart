import 'package:dio/dio.dart';
import 'package:shelf/shelf.dart' as shelf;
import 'package:shelf_router/shelf_router.dart';

class ApiFcmRouters {
  Future<shelf.Response> sendPush(shelf.Request request) async {
    await Dio().post<dynamic>(
      'POST https://fcm.googleapis.com/v1/projects/job-timer1/messages:send',
    );
    return shelf.Response.ok('OK');
  }

  Router get routers {
    return Router()..get('/send', sendPush);
  }
}
