import 'package:agora/agora_app.dart';
import 'package:agora/common/manager/service_manager.dart';
import 'package:agora/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AgoraInitializer {
  static void initializeApp() async {
    WidgetsFlutterBinding.ensureInitialized();
    Intl.defaultLocale = "fr_FR";
    initializeDateFormatting('fr_FR', null);

    final sharedPref = await SharedPreferences.getInstance();
    await _setupNotification();
    runApp(AgoraApp(sharedPref: sharedPref));
  }

  static Future<void> _setupNotification() async {
    await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
    if (!kIsWeb) {
      await ServiceManager.getPushNotificationService().setupNotifications();
    }
  }
}
