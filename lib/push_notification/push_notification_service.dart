import 'dart:async';
import 'dart:io';

import 'package:agora/common/client/service_manager.dart';
import 'package:agora/common/log/log.dart';
import 'package:agora/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  final pushNotificationService = ServiceManager.getPushNotificationService();
  await pushNotificationService.setupNotifications();
  // await pushNotificationService.showNotification(message);
  Log.d("Handling a background message ${message.messageId}");
}

abstract class PushNotificationService {
  Future<void> setupNotifications();

  Future<void> showNotification(RemoteMessage message);

  Future<String> getMessagingToken();
}

class FirebasePushNotificationService extends PushNotificationService {
  final _messaging = FirebaseMessaging.instance;
  final String _channelId = 'high_importance_channel';
  late AndroidNotificationChannel channel;
  late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

  @override
  Future<void> setupNotifications() async {
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    if (Platform.isAndroid) {
      await _createHighImportanceAndroidChannel();
    } else if (Platform.isIOS) {
      await _messaging.setForegroundNotificationPresentationOptions(alert: true, badge: true, sound: true);
    }

    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      Log.d('FirebaseMessaging - New notification while app is in foreground: ${message.notification?.title}');
      await ServiceManager.getPushNotificationService().showNotification(message);
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      Log.d('FirebaseMessaging - New notification while app is in background: ${message.notification?.title}');
    });

    FirebaseMessaging.instance.getInitialMessage().then((RemoteMessage? message) {
      if (message != null) {
        Log.d('FirebaseMessaging - New notification while app is terminated: ${message.notification?.title}');
      }
    });
  }

  @override
  Future<String> getMessagingToken() async {
    final token = await _messaging.getToken();
    if (token == null) {
      throw Exception("No firebase messaging token found error");
    }
    Log.d("\nFirebase messaging token : $token\n");
    return token;
  }

  @override
  Future<void> showNotification(RemoteMessage message) async {
    final RemoteNotification? notification = message.notification;
    final AndroidNotification? android = notification?.android;
    if (notification != null && android != null && !kIsWeb) {
      flutterLocalNotificationsPlugin.show(
        notification.hashCode,
        notification.title,
        notification.body,
        NotificationDetails(
          android: AndroidNotificationDetails(
            channel.id,
            channel.name,
            channelDescription: channel.description,
            icon: 'launch_background',
          ),
        ),
      );
    }
  }

  Future<void> _createHighImportanceAndroidChannel() async {
    channel = AndroidNotificationChannel(
      _channelId,
      _channelId,
      importance: Importance.high,
    );

    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);
  }
}
