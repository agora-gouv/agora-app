import 'package:agora/common/client/agora_http_client.dart';
import 'package:agora/infrastructure/consultation/consultation_repository.dart';
import 'package:agora/infrastructure/consultation/mocks_consultation_repository.dart';
import 'package:agora/infrastructure/thematique/mocks_thematique_repository.dart';
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
    final dio = Dio();
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
    if (GetIt.instance.isRegistered<MockThematiqueSuccessRepository>()) {
      return GetIt.instance.get<MockThematiqueSuccessRepository>();
    }
    final repository = MockThematiqueSuccessRepository();
    // final repository = ThematiqueDioRepository(httpClient: SingletonManager.getAgoraDioHttpClient());
    GetIt.instance.registerSingleton(repository);
    return repository;
  }

  static ConsultationRepository getConsultationRepository() {
    if (GetIt.instance.isRegistered<MockConsultationSuccessRepository>()) {
      return GetIt.instance.get<MockConsultationSuccessRepository>();
    }
    final repository = MockConsultationSuccessRepository();
    // final repository = ConsultationDioRepository(httpClient: SingletonManager.getAgoraDioHttpClient());
    GetIt.instance.registerSingleton(repository);
    return repository;
  }
}
