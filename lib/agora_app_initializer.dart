import 'package:agora/agora_app.dart';
import 'package:agora/bloc/consultation/question/response/stock/consultation_question_response_hive.dart';
import 'package:agora/common/helper/tracker_helper.dart';
import 'package:agora/common/manager/config_manager.dart';
import 'package:agora/common/manager/repository_manager.dart';
import 'package:agora/common/manager/service_manager.dart';
import 'package:agora/common/manager/storage_manager.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:matomo_tracker/matomo_tracker.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AgoraInitializer {
  static void initializeApp(AgoraAppConfig appConfig) async {
    WidgetsFlutterBinding.ensureInitialized();
    Intl.defaultLocale = "fr_FR";
    initializeDateFormatting('fr_FR', null);

    await _setupNotification();
    await _setupMatomo();
    RepositoryManager.initRepositoryManager(
      baseUrl: appConfig.baseUrl,
      rootCertificate: await _readCertificate(),
    );

    await Hive.initFlutter();
    Hive.registerAdapter(ConsultationQuestionResponsesHiveAdapter());

    final sharedPref = await SharedPreferences.getInstance();
    final isFirstConnection = await StorageManager.getOnboardingStorageClient().isFirstTime();
    await SentryFlutter.init(
          (options) => options
        ..dsn = appConfig.sentryDsn
        ..environment = appConfig.environmentName,
      appRunner: () => runApp(AgoraApp(sharedPref: sharedPref, shouldShowOnboarding: isFirstConnection)),
    );
  }

  static Future<Uint8List> _readCertificate() async {
    return (await rootBundle.load("assets/certificates/certignaservicesrootca.cer")).buffer.asUint8List();
  }

  static Future<void> _setupNotification() async {
    if (!kIsWeb) {
      await Firebase.initializeApp(options: ConfigManager.getFirebaseOptions());
      await ServiceManager.getPushNotificationService().setupNotifications();
    }
  }

  static Future<void> _setupMatomo() async {
    final matomoConfig = ConfigManager.getMatomoConfig();

    await MatomoTracker.instance.initialize(
      siteId: matomoConfig.siteId,
      url: matomoConfig.url,
    );

    TrackerHelper.trackDimension();
  }
}

class AgoraAppConfig extends Equatable {
  final String baseUrl;
  final String environmentName;
  final String sentryDsn;

  AgoraAppConfig({
    required this.baseUrl,
    required this.environmentName,
    required this.sentryDsn,
  });

  @override
  List<Object?> get props => [baseUrl, environmentName, sentryDsn];
}
