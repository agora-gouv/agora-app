import 'package:agora/agora_app.dart';
import 'package:agora/common/helper/tracker_helper.dart';
import 'package:agora/common/manager/config_manager.dart';
import 'package:agora/common/manager/helper_manager.dart';
import 'package:agora/common/manager/repository_manager.dart';
import 'package:agora/common/manager/service_manager.dart';
import 'package:agora/common/manager/storage_manager.dart';
import 'package:agora/common/observer/event_observer.dart';
import 'package:agora/consultation/question/bloc/response/stock/consultation_question_response_hive.dart';
import 'package:basic_utils/basic_utils.dart';
import 'package:equatable/equatable.dart';
import 'package:error_stack/error_stack.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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

    HelperManager.initMainColorHelper(appConfig.appBarColor);

    Bloc.observer = EventObserver();

    final sharedPref = await SharedPreferences.getInstance();
    final isFirstConnection = await StorageManager.getOnboardingStorageClient().isFirstTime();

    await ErrorStack.init();

    await SentryFlutter.init(
      (options) => options
        ..dsn = appConfig.sentryDsn
        ..environment = appConfig.environmentName,
      appRunner: () => runApp(
        AgoraApp(
          sharedPref: sharedPref,
          shouldShowOnboarding: isFirstConnection,
          agoraAppIcon: appConfig.appIcon,
        ),
      ),
    );
  }

  static Future<List<X509CertificateData>> _readCertificate() async {
    // TODO pour tester on peut pinguer des sites qui utilisent Certigna ou LetsEncrypt
    final certignaCertificate =
        X509Utils.crlDerToPem((await rootBundle.load("assets/certificates/certigna-rootca.cer")).buffer.asUint8List());
    final letsEncryptCertificates = [
      (await rootBundle.loadString("assets/certificates/letsencrypt-isrg-root-x1.pem")),
      (await rootBundle.loadString("assets/certificates/letsencrypt-isrg-root-x2.pem")),
      (await rootBundle.loadString("assets/certificates/letsencrypt-e5.pem")),
      (await rootBundle.loadString("assets/certificates/letsencrypt-e6.pem")),
      (await rootBundle.loadString("assets/certificates/letsencrypt-r10.pem")),
      (await rootBundle.loadString("assets/certificates/letsencrypt-r11.pem")),
    ];

    final rawCertificates = [certignaCertificate, ...letsEncryptCertificates];
    final certificates =
        rawCertificates.map((rawCertificate) => X509Utils.x509CertificateFromPem(rawCertificate)).toList();

    return certificates;
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
  final String appIcon;
  final Color appBarColor;

  AgoraAppConfig({
    required this.baseUrl,
    required this.environmentName,
    required this.sentryDsn,
    required this.appIcon,
    required this.appBarColor,
  });

  @override
  List<Object?> get props => [baseUrl, environmentName, sentryDsn, appIcon, appBarColor];
}
