import 'package:agora/agora_app.dart';
import 'package:agora/common/agora_http_client.dart';
import 'package:dio/dio.dart';
import 'package:dio_cache_interceptor/dio_cache_interceptor.dart';
import 'package:flutter/material.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

class AgoraInitializer {
  static void initializeApp() async {
    final agoraHttpClient = AgoraDioHttpClient(dio: initializeDio());
    runApp(AgoraApp(agoraDioHttpClient: agoraHttpClient));
  }

  static Dio initializeDio() {
    // final options = BaseOptions(baseUrl: "//todo http://agora");
    // final dio = Dio(options);
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
    return dio;
  }
}
