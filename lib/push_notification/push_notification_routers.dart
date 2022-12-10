import 'package:api_fcm/push_notification/controllers/push_notification_controller.dart';
import 'package:shelf_router/shelf_router.dart';

class PushNotificationRouters {
  static Router routers() {
    final controller = PushNotificationController();
    return Router()..mount('/push-notification', controller.router);
  }
}
