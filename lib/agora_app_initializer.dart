import 'package:agora/agora_app.dart';
import 'package:agora/common/manager/config_manager.dart';
import 'package:agora/common/manager/repository_manager.dart';
import 'package:agora/common/manager/service_manager.dart';
import 'package:agora/common/manager/storage_manager.dart';
import 'package:agora/firebase_options.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:matomo_tracker/matomo_tracker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AgoraInitializer {
  static void initializeApp(AgoraAppConfig appConfig) async {
    WidgetsFlutterBinding.ensureInitialized();
    Intl.defaultLocale = "fr_FR";
    initializeDateFormatting('fr_FR', null);

    await _setupNotification();
    await _setupMatomo();
    RepositoryManager.initRepositoryManager(baseUrl: appConfig.baseUrl);
    final sharedPref = await SharedPreferences.getInstance();
    final isFirstConnection = await StorageManager.getOnboardingStorageClient().isFirstTime();
    runApp(AgoraApp(sharedPref: sharedPref, shouldShowOnboarding: isFirstConnection));
  }

  static Future<void> _setupNotification() async {
    await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
    if (!kIsWeb) {
      await ServiceManager.getPushNotificationService().setupNotifications();
    }
  }

  static Future<void> _setupMatomo() async {
    final matomoConfig = ConfigManager.getMatomoConfig();
    await MatomoTracker.instance.initialize(
      siteId: matomoConfig.siteId,
      url: matomoConfig.url,
    );
  }
}

class AgoraAppConfig extends Equatable {
  final String baseUrl;

  AgoraAppConfig({required this.baseUrl});

  @override
  List<Object?> get props => [baseUrl];
}
