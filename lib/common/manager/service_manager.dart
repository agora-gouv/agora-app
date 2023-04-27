import 'package:agora/push_notification/push_notification_service.dart';
import 'package:get_it/get_it.dart';

class ServiceManager {
  static PushNotificationService getPushNotificationService() {
    if (GetIt.instance.isRegistered<FirebasePushNotificationService>()) {
      return GetIt.instance.get<FirebasePushNotificationService>();
    }
    final service = FirebasePushNotificationService();
    GetIt.instance.registerSingleton(service);
    return service;
  }
}
