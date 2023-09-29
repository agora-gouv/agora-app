import 'dart:async';

import 'package:agora/push_notification/push_notification_service.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class FakePushNotificationService extends PushNotificationService {
  @override
  Future<void> setupNotifications() async {}

  @override
  Future<String> getMessagingToken() async {
    return "fcmToken";
  }

  @override
  void redirectionFromSavedNotificationMessage() {}

  @override
  Future<void> showNotification(RemoteMessage message) async {}
}
