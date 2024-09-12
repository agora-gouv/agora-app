import 'package:agora/common/client/agora_http_client.dart';
import 'package:agora/common/client/agora_http_client_adapter.dart';
import 'package:agora/common/client/auth_interceptor.dart';
import 'package:agora/common/client/user_agent_builder.dart';
import 'package:agora/common/helper/flavor_helper.dart';
import 'package:agora/common/manager/helper_manager.dart';
import 'package:agora/common/manager/service_manager.dart';
import 'package:agora/common/manager/storage_manager.dart';
import 'package:agora/concertation/repository/concertation_repository.dart';
import 'package:agora/consultation/repository/consultation_repository.dart';
import 'package:agora/consultation/repository/mock_consultation_repository.dart';
import 'package:agora/login/repository/login_repository.dart';
import 'package:agora/login/repository/mocks_login_repository.dart';
import 'package:agora/profil/app_feedback/repository/app_feedback_repository.dart';
import 'package:agora/profil/app_feedback/repository/mocks_app_feedback_repository.dart';
import 'package:agora/profil/demographic/repository/demographic_repository.dart';
import 'package:agora/profil/demographic/repository/mocks_demographic_repository.dart';
import 'package:agora/profil/notification/repository/mocks_notification_repository.dart';
import 'package:agora/profil/notification/repository/notification_repository.dart';
import 'package:agora/profil/participation_charter/repository/mocks_participation_charter_repository.dart';
import 'package:agora/qag/repository/mocks_qag_repository.dart';
import 'package:agora/qag/repository/qag_repository.dart';
import 'package:agora/thematique/repository/thematique_repository.dart';
import 'package:agora/welcome/repository/mocks_welcome_repository.dart';
import 'package:agora/welcome/repository/welcome_repository.dart';
import 'package:dio/dio.dart';
import 'package:dio_cache_interceptor/dio_cache_interceptor.dart';
import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RepositoryManager {
  static const String _baseUrl = "baseUrl";
  static const String _noAuthenticationHttpClient = "noAuthenticationHttpClient";
  static const String _authenticatedHttpClient = "authenticatedHttpClient";
  static const String _noAuthenticationDio = "noAuthenticationDio";
  static const String _authenticatedDio = "authenticatedDio";

  static final userAgentBuilder = UserAgentBuilderImpl(
    appVersionHelper: HelperManager.getAppVersionHelper(),
    deviceInfoHelper: HelperManager.getDeviceInfoHelper(),
  );

  static void initRepositoryManager({required String baseUrl}) {
    GetIt.instance.registerSingleton(baseUrl, instanceName: _baseUrl);
  }

  static Dio _getDio({SharedPreferences? sharedPref}) {
    if (GetIt.instance.isRegistered<Dio>(instanceName: _authenticatedDio)) {
      return GetIt.instance.get<Dio>(instanceName: _authenticatedDio);
    }
    if (!GetIt.instance.isRegistered<String>(instanceName: _baseUrl)) {
      throw Exception("RepositoryManager has not been initialized");
    }
    final Dio dio = _createBaseDio();
    dio.interceptors.add(
      AuthInterceptor(
        repository: RepositoryManager.getLoginRepository(),
        loginStorageClient: StorageManager.getLoginStorageClient(sharedPref: sharedPref),
        pushNotificationService: ServiceManager.getPushNotificationService(),
        jwtHelper: HelperManager.getJwtHelper(),
        appVersionHelper: HelperManager.getAppVersionHelper(),
        platformHelper: HelperManager.getPlatformHelper(),
      ),
    );
    if (!kIsWeb && FlavorHelper.getFlavor() == AgoraFlavor.prod) {
      dio.httpClientAdapter = AgoraHttpClientAdapter(baseUrl: GetIt.instance.get<String>(instanceName: _baseUrl));
    }
    GetIt.instance.registerSingleton(dio, instanceName: _authenticatedDio);
    return dio;
  }

  static Dio _getDioWithoutAuth() {
    if (GetIt.instance.isRegistered<Dio>(instanceName: _noAuthenticationDio)) {
      return GetIt.instance.get<Dio>(instanceName: _noAuthenticationDio);
    }
    if (!GetIt.instance.isRegistered<String>(instanceName: _baseUrl)) {
      throw Exception("RepositoryManager has not been initialized");
    }
    final Dio dio = _createBaseDio();
    GetIt.instance.registerSingleton(dio, instanceName: _noAuthenticationDio);
    return dio;
  }

  static Dio _createBaseDio() {
    final dio = Dio(
      BaseOptions(
        baseUrl: GetIt.instance.get<String>(instanceName: _baseUrl),
        connectTimeout: Duration(seconds: 60),
        receiveTimeout: Duration(seconds: 60),
      ),
    );
    final dioLoggerInterceptor = PrettyDioLogger(
      requestHeader: true,
      requestBody: true,
      responseHeader: true,
      responseBody: true,
    );
    final dioCacheInterceptor = DioCacheInterceptor(
      options: CacheOptions(
        store: MemCacheStore(),
        policy: CachePolicy.request,
        maxStale: const Duration(days: 14),
      ),
    );
    dio.interceptors
      ..add(dioLoggerInterceptor)
      ..add(dioCacheInterceptor);
    return dio;
  }

  static AgoraDioHttpClient getAgoraDioHttpClientWithoutAuthentication() {
    if (GetIt.instance.isRegistered<AgoraDioHttpClient>(instanceName: _noAuthenticationHttpClient)) {
      return GetIt.instance.get<AgoraDioHttpClient>(instanceName: _noAuthenticationHttpClient);
    }
    final agoraDioHttpClient = AgoraDioHttpClient(
      dio: _getDioWithoutAuth(),
      userAgentBuilder: userAgentBuilder,
    );
    GetIt.instance.registerSingleton(agoraDioHttpClient, instanceName: _noAuthenticationHttpClient);
    return agoraDioHttpClient;
  }

  static AgoraDioHttpClient _getAgoraDioHttpClient({SharedPreferences? sharedPref}) {
    if (GetIt.instance.isRegistered<AgoraDioHttpClient>(instanceName: _authenticatedHttpClient)) {
      return GetIt.instance.get<AgoraDioHttpClient>(instanceName: _authenticatedHttpClient);
    }
    final agoraDioHttpClient = AgoraDioHttpClient(
      dio: _getDio(sharedPref: sharedPref),
      jwtHelper: HelperManager.getJwtHelper(),
      userAgentBuilder: userAgentBuilder,
    );
    GetIt.instance.registerSingleton(agoraDioHttpClient, instanceName: _authenticatedHttpClient);
    return agoraDioHttpClient;
  }

  static ThematiqueRepository getThematiqueRepository() {
    if (GetIt.instance.isRegistered<ThematiqueDioRepository>()) {
      return GetIt.instance.get<ThematiqueDioRepository>();
    }
    final repository = ThematiqueDioRepository(
      httpClient: _getAgoraDioHttpClient(),
      sentryWrapper: HelperManager.getSentryWrapper(),
    );
    GetIt.instance.registerSingleton(repository);
    return repository;
  }

  static ConsultationRepository getConsultationRepository() {
    if (GetIt.instance.isRegistered<MockConsultationRepository>()) {
      return GetIt.instance.get<MockConsultationRepository>();
    }
    final repository = MockConsultationRepository(
      httpClient: _getAgoraDioHttpClient(),
      sentryWrapper: HelperManager.getSentryWrapper(),
      storageClient: StorageManager.getConsultationQuestionStorageClient(),
    );
    GetIt.instance.registerSingleton(repository);
    return repository;
  }

  static AppFeedbackRepository getAppFeedbackRepository() {
    if (GetIt.instance.isRegistered<AppFeedbackRepository>()) {
      return GetIt.instance.get<AppFeedbackRepository>();
    }
    final repository = MockAppFeedbackRepository(
      httpClient: _getAgoraDioHttpClient(),
      sentryWrapper: HelperManager.getSentryWrapper(),
    );
    GetIt.instance.registerSingleton<AppFeedbackRepository>(repository);
    return repository;
  }

  static QagRepository getQagRepository() {
    if (GetIt.instance.isRegistered<MockQagRepository>()) {
      return GetIt.instance.get<MockQagRepository>();
    }
    final repository = MockQagRepository(
      httpClient: _getAgoraDioHttpClient(),
      sentryWrapper: HelperManager.getSentryWrapper(),
    );
    GetIt.instance.registerSingleton(repository);
    return repository;
  }

  static LoginRepository getLoginRepository() {
    if (GetIt.instance.isRegistered<MockLoginRepository>()) {
      return GetIt.instance.get<MockLoginRepository>();
    }
    final repository = MockLoginRepository(
      httpClient: getAgoraDioHttpClientWithoutAuthentication(),
      sentryWrapper: HelperManager.getSentryWrapper(),
    );
    GetIt.instance.registerSingleton(repository);
    return repository;
  }

  static MockParticipationCharterRepository getParticipationCharterRepository() {
    if (GetIt.instance.isRegistered<MockParticipationCharterRepository>()) {
      return GetIt.instance.get<MockParticipationCharterRepository>();
    }
    final repository = MockParticipationCharterRepository(
      httpClient: _getAgoraDioHttpClient(),
      sentryWrapper: HelperManager.getSentryWrapper(),
    );
    GetIt.instance.registerSingleton(repository);
    return repository;
  }

  static DemographicRepository getDemographicRepository() {
    if (GetIt.instance.isRegistered<MockDemographicRepository>()) {
      return GetIt.instance.get<MockDemographicRepository>();
    }
    final repository = MockDemographicRepository(
      httpClient: _getAgoraDioHttpClient(),
      sentryWrapper: HelperManager.getSentryWrapper(),
    );
    GetIt.instance.registerSingleton(repository);
    return repository;
  }

  static NotificationRepository getNotificationRepository() {
    if (GetIt.instance.isRegistered<MockNotificationRepository>()) {
      return GetIt.instance.get<MockNotificationRepository>();
    }
    final repository = MockNotificationRepository(
      httpClient: _getAgoraDioHttpClient(),
      sentryWrapper: HelperManager.getSentryWrapper(),
    );
    GetIt.instance.registerSingleton(repository);
    return repository;
  }

  static WelcomeRepository getWelcomeRepository({SharedPreferences? sharedPref}) {
    if (GetIt.instance.isRegistered<MocksWelcomeRepository>()) {
      return GetIt.instance.get<MocksWelcomeRepository>();
    }
    final repository = MocksWelcomeRepository(
      httpClient: _getAgoraDioHttpClient(sharedPref: sharedPref),
      sentryWrapper: HelperManager.getSentryWrapper(),
    );
    GetIt.instance.registerSingleton(repository);
    return repository;
  }

  static ConcertationDioRepository getConcertationRepository() {
    if (GetIt.instance.isRegistered<ConcertationDioRepository>()) {
      return GetIt.instance.get<ConcertationDioRepository>();
    }
    final repository = ConcertationDioRepository(
      httpClient: _getAgoraDioHttpClient(),
      sentryWrapper: HelperManager.getSentryWrapper(),
    );
    GetIt.instance.registerSingleton(repository);
    return repository;
  }
}
