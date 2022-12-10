import 'package:api_fcm/push_notification/push_notification_routers.dart';
import 'package:shelf_router/shelf_router.dart';

class ApiFcmRouters {
  Router get routers {
    return PushNotificationRouters.routers();
  }
}
