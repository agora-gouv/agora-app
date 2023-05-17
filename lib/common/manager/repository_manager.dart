import 'package:agora/common/client/agora_http_client.dart';
import 'package:agora/infrastructure/consultation/repository/consultation_repository.dart';
import 'package:agora/infrastructure/consultation/repository/mocks_consultation_repository.dart';
import 'package:agora/infrastructure/demographic/demographic_repository.dart';
import 'package:agora/infrastructure/demographic/mocks_demographic_repository.dart';
import 'package:agora/infrastructure/login/login_repository.dart';
import 'package:agora/infrastructure/login/mocks_login_repository.dart';
import 'package:agora/infrastructure/qag/mocks_qag_repository.dart';
import 'package:agora/infrastructure/qag/qag_repository.dart';
import 'package:agora/infrastructure/thematique/thematique_repository.dart';
import 'package:dio/dio.dart';
import 'package:dio_cache_interceptor/dio_cache_interceptor.dart';
import 'package:get_it/get_it.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

class RepositoryManager {
  static Dio _getDio() {
    if (GetIt.instance.isRegistered<Dio>()) {
      return GetIt.instance.get<Dio>();
    }
    final dio = Dio(BaseOptions(baseUrl: "https://agora-dev.osc-secnum-fr1.scalingo.io"));
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
    GetIt.instance.registerSingleton(dio);
    return dio;
  }

  static AgoraDioHttpClient _getAgoraDioHttpClient() {
    if (GetIt.instance.isRegistered<AgoraDioHttpClient>()) {
      return GetIt.instance.get<AgoraDioHttpClient>();
    }
    final agoraDioHttpClient = AgoraDioHttpClient(dio: _getDio());
    GetIt.instance.registerSingleton(agoraDioHttpClient);
    return agoraDioHttpClient;
  }

  static ThematiqueRepository getThematiqueRepository() {
    if (GetIt.instance.isRegistered<ThematiqueDioRepository>()) {
      return GetIt.instance.get<ThematiqueDioRepository>();
    }
    final repository = ThematiqueDioRepository(httpClient: _getAgoraDioHttpClient());
    GetIt.instance.registerSingleton(repository);
    return repository;
  }

  static ConsultationRepository getConsultationRepository() {
    if (GetIt.instance.isRegistered<MockConsultationRepository>()) {
      return GetIt.instance.get<MockConsultationRepository>();
    }
    final repository = MockConsultationRepository(httpClient: _getAgoraDioHttpClient());
    GetIt.instance.registerSingleton(repository);
    return repository;
  }

  static QagRepository getQagRepository() {
    if (GetIt.instance.isRegistered<MockQagRepository>()) {
      return GetIt.instance.get<MockQagRepository>();
    }
    final repository = MockQagRepository(httpClient: _getAgoraDioHttpClient());
    GetIt.instance.registerSingleton(repository);
    return repository;
  }

  static LoginRepository getLoginRepository() {
    if (GetIt.instance.isRegistered<MockLoginRepository>()) {
      return GetIt.instance.get<MockLoginRepository>();
    }
    final repository = MockLoginRepository(httpClient: _getAgoraDioHttpClient());
    GetIt.instance.registerSingleton(repository);
    return repository;
  }

  static DemographicRepository getDemographicRepository() {
    if (GetIt.instance.isRegistered<MockDemographicRepository>()) {
      return GetIt.instance.get<MockDemographicRepository>();
    }
    final repository = MockDemographicRepository(httpClient: _getAgoraDioHttpClient());
    GetIt.instance.registerSingleton(repository);
    return repository;
  }
}
