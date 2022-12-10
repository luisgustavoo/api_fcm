import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:dotenv/dotenv.dart';
import 'package:googleapis_auth/auth_io.dart';
import 'package:shelf/shelf.dart' as shelf;
import 'package:shelf_router/shelf_router.dart';

class PushNotificationController {
  final env = DotEnv()..load();

  Router get router {
    return Router()..post('/send', sendPush);
  }

  Future<shelf.Response> sendPush(shelf.Request request) async {
    final client = await obtainAuthenticatedClient();
    final deviceToken = env['device_token'].toString();

    await Dio().post<dynamic>(
      'https://fcm.googleapis.com/v1/projects/job-timer-1/messages:send',
      data: <String, dynamic>{
        'message': {
          'token': deviceToken,
          'notification': {
            'body': 'This is an FCM notification message!',
            'title': 'FCM Message'
          }
        }
      },
      options: Options(
        headers: <String, dynamic>{
          'Content-type': 'application/json',
          'Authorization':
              '${client.credentials.accessToken.type} ${client.credentials.accessToken.data}',
        },
      ),
    );

    client.close();

    return shelf.Response.ok('OK');
  }

  Future<AuthClient> obtainAuthenticatedClient() async {
    final directory = Directory.current;

    final file = File(
      '${directory.path}/assets/job-timer-1-firebase-adminsdk-p6dtg-27928b5287.json',
    );

    final fileString = file.readAsStringSync();

    final map = jsonDecode(fileString) as Map<String, dynamic>;

    final accountCredentials = ServiceAccountCredentials.fromJson({
      'private_key_id': map['private_key_id'].toString(),
      'private_key': map['private_key'].toString(),
      'client_email': map['client_email'].toString(),
      'client_id': map['client_id'].toString(),
      'type': map['type'].toString(),
    });

    const scopes = ['https://www.googleapis.com/auth/firebase.messaging'];

    final client = await clientViaServiceAccount(accountCredentials, scopes);

    return client;
  }
}
