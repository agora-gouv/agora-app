import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:agora/common/extension/notification_message_type_extension.dart';
import 'package:agora/common/log/log.dart';
import 'package:agora/common/manager/config_manager.dart';
import 'package:agora/common/manager/service_manager.dart';
import 'package:agora/common/manager/storage_manager.dart';
import 'package:agora/common/navigator/navigator_key.dart';
import 'package:agora/pages/consultation/details/consultation_details_page.dart';
import 'package:agora/pages/qag/details/qag_details_page.dart';
import 'package:agora/push_notification/notification_message_type.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(options: ConfigManager.getFirebaseOptions());

  final pushNotificationService = ServiceManager.getPushNotificationService();
  await pushNotificationService.setupNotifications();
  saveNotificationMessage(message);
  Log.d("Handling a background message ${message.messageId}");
}

void saveNotificationMessage(RemoteMessage message) async {
  Log.d("notification : save ${jsonEncode(message.toMap())}");
  StorageManager.getPushNotificationStorageClient().saveMessage(jsonEncode(message.toMap()));
}

abstract class PushNotificationService {
  Future<void> setupNotifications();

  Future<void> showNotification(RemoteMessage message);

  void redirectionFromSavedNotificationMessage();

  Future<String> getMessagingToken();
}

class FirebasePushNotificationService extends PushNotificationService {
  final _messaging = FirebaseMessaging.instance;
  final String _channelId = 'high_importance_channel';
  late AndroidNotificationChannel channel;
  late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
  final int _fcmTokenErrorWaitDelayInSeconds = 5;

  @override
  Future<void> setupNotifications() async {
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    if (Platform.isAndroid) {
      await _createHighImportanceAndroidChannel();
    } else if (Platform.isIOS) {
      await _messaging.setForegroundNotificationPresentationOptions(alert: true, badge: true, sound: true);
    }

    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      Log.d("FirebaseMessaging - New notification while app is in foreground: ${message.notification?.title}");
      _redirectionFromNotificationMessage(message, true);
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      Log.d("FirebaseMessaging - New notification while app is in background: ${message.notification?.title}");
      saveNotificationMessage(message);
    });

    FirebaseMessaging.instance.getInitialMessage().then((RemoteMessage? message) {
      if (message != null) {
        Log.d("FirebaseMessaging - New notification while app is terminated: ${message.notification?.title}");
        saveNotificationMessage(message);
      }
    });
  }

  @override
  Future<String> getMessagingToken() async {
    await _messaging.requestPermission();
    try {
      return await _fetchMessagingToken();
    } catch (e) {
      Log.e("\nFirebase messaging token fetch error, waiting for APNs to be initialized...\n");
      await Future.delayed(Duration(seconds: _fcmTokenErrorWaitDelayInSeconds));
      return await _fetchMessagingToken();
    }
  }

  @override
  void redirectionFromSavedNotificationMessage() async {
    final message = await _redirect("notification : redirect with");
    if (message == null) {
      // retry redirect if waiting time is insufficient
      await Future.delayed(Duration(seconds: 1));
      _redirect("notification : retry redirect with");
    }
  }

  Future<String?> _redirect(String logMessage) async {
    final String? savedNotificationMessage = await StorageManager.getPushNotificationStorageClient().getMessage();
    Log.d("$logMessage $savedNotificationMessage");
    if (savedNotificationMessage != null) {
      final RemoteMessage message = RemoteMessage.fromMap(jsonDecode(savedNotificationMessage) as Map<String, dynamic>);
      _redirectionFromNotificationMessage(message, false);
      _clearNotificationMessage();
    }
    return savedNotificationMessage;
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

  void _redirectionFromNotificationMessage(RemoteMessage message, bool shouldDisplayMessage) {
    final messageType = (message.data["type"] as String).toNotificationMessageType();
    switch (messageType) {
      case NotificationMessageType.qagDetails:
        navigatorKey.currentState?.pushNamed(
          QagDetailsPage.routeName,
          arguments: QagDetailsArguments(
            qagId: message.data["qagId"] as String,
            notificationTitle: shouldDisplayMessage ? message.notification?.title : null,
            notificationDescription: shouldDisplayMessage ? message.notification?.body : null,
          ),
        );
        break;
      case NotificationMessageType.consultationDetails:
        navigatorKey.currentState?.pushNamed(
          ConsultationDetailsPage.routeName,
          arguments: ConsultationDetailsArguments(
            consultationId: message.data["consultationId"] as String,
            notificationTitle: shouldDisplayMessage ? message.notification?.title : null,
            notificationDescription: shouldDisplayMessage ? message.notification?.body : null,
          ),
        );
        break;
    }
  }

  void _clearNotificationMessage() async {
    StorageManager.getPushNotificationStorageClient().clearMessage();
    //await flutterLocalNotificationsPlugin.cancelAll();
  }

  Future<String> _fetchMessagingToken() async {
    final token = await _messaging.getToken();
    if (token == null) {
      throw Exception("No firebase messaging token found error");
    }
    Log.d("\nFirebase messaging token : $token\n");
    return token;
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
