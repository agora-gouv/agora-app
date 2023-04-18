import 'package:agora/common/client/agora_http_client.dart';
import 'package:agora/infrastructure/consultation/repository/consultation_repository.dart';
import 'package:agora/infrastructure/consultation/repository/mocks_consultation_repository.dart';
import 'package:agora/infrastructure/qag/mocks_qag_repository.dart';
import 'package:agora/infrastructure/qag/qag_repository.dart';
import 'package:agora/infrastructure/thematique/thematique_repository.dart';
import 'package:dio/dio.dart';
import 'package:dio_cache_interceptor/dio_cache_interceptor.dart';
import 'package:get_it/get_it.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

class RepositoryManager {
  static Dio getDio() {
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

  static AgoraDioHttpClient getAgoraDioHttpClient() {
    if (GetIt.instance.isRegistered<AgoraDioHttpClient>()) {
      return GetIt.instance.get<AgoraDioHttpClient>();
    }
    final agoraDioHttpClient = AgoraDioHttpClient(dio: RepositoryManager.getDio());
    GetIt.instance.registerSingleton(agoraDioHttpClient);
    return agoraDioHttpClient;
  }

  static ThematiqueRepository getThematiqueRepository() {
    if (GetIt.instance.isRegistered<ThematiqueDioRepository>()) {
      return GetIt.instance.get<ThematiqueDioRepository>();
    }
    final repository = ThematiqueDioRepository(httpClient: RepositoryManager.getAgoraDioHttpClient());
    GetIt.instance.registerSingleton(repository);
    return repository;
  }

  static ConsultationRepository getConsultationRepository() {
    if (GetIt.instance.isRegistered<MockConsultationSuccessRepository>()) {
      return GetIt.instance.get<MockConsultationSuccessRepository>();
    }
    final repository = MockConsultationSuccessRepository(httpClient: RepositoryManager.getAgoraDioHttpClient());
    //final repository = ConsultationDioRepository(httpClient: RepositoryManager.getAgoraDioHttpClient());
    GetIt.instance.registerSingleton(repository);
    return repository;
  }

  static QagRepository getQagRepository() {
    if (GetIt.instance.isRegistered<MockQagSuccessRepository>()) {
      return GetIt.instance.get<MockQagSuccessRepository>();
    }
    final repository = MockQagSuccessRepository(httpClient: RepositoryManager.getAgoraDioHttpClient());
    // final repository = QagDioRepository(httpClient: RepositoryManager.getAgoraDioHttpClient());
    GetIt.instance.registerSingleton(repository);
    return repository;
  }
}
