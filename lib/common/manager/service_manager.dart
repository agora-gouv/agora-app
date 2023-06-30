import 'package:agora/push_notification/push_notification_service.dart';
import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';

class ServiceManager {
  static PushNotificationService getPushNotificationService() {
    if (kIsWeb) {
      if (GetIt.instance.isRegistered<NotImportantFirebasePushNotificationService>()) {
        return GetIt.instance.get<NotImportantFirebasePushNotificationService>();
      }
      final service = NotImportantFirebasePushNotificationService();
      GetIt.instance.registerSingleton(service);
      return service;
    } else {
      if (GetIt.instance.isRegistered<FirebasePushNotificationService>()) {
        return GetIt.instance.get<FirebasePushNotificationService>();
      }
      final service = FirebasePushNotificationService();
      GetIt.instance.registerSingleton(service);
      return service;
    }
  }
}
