import 'package:agora/common/client/user_agent_builder.dart';
import 'package:agora/common/helper/jwt_helper.dart';
import 'package:dio/dio.dart';

abstract class AgoraHttpClient {
  Future<Response<T>> get<T>(
    String path, {
    data,
    required Map<String, dynamic> queryParameters,
    required Map<String, dynamic> headers,
  });

  Future<Response<T>> put<T>(String path, {data, required Map<String, dynamic> headers});

  Future<Response<T>> post<T>(String path, {data, required Map<String, dynamic> headers});

  Future<Response<T>> delete<T>(String path, {data, required Map<String, dynamic> headers});
}

class AgoraDioHttpClient extends AgoraHttpClient {
  final Dio dio;
  final JwtHelper? jwtHelper;
  final UserAgentBuilder userAgentBuilder;

  AgoraDioHttpClient({required this.dio, this.jwtHelper, required this.userAgentBuilder});

  @override
  Future<Response<T>> get<T>(
    String path, {
    data,
    Map<String, dynamic> queryParameters = const {},
    Map<String, dynamic> headers = const {},
  }) async {
    return dio.get<T>(
      path,
      queryParameters: queryParameters,
      options: Options(
        headers: await buildInitialHeaders()
          ..addAll(headers),
      ),
      data: data,
    );
  }

  @override
  Future<Response<T>> put<T>(
    String path, {
    data,
    Map<String, dynamic> headers = const {},
  }) async {
    return dio.put<T>(
      path,
      options: Options(
        headers: await buildInitialHeaders()
          ..addAll(headers),
      ),
      data: data,
    );
  }

  @override
  Future<Response<T>> post<T>(
    String path, {
    data,
    Map<String, dynamic> headers = const {},
  }) async {
    return dio.post<T>(
      path,
      options: Options(
        headers: await buildInitialHeaders()
          ..addAll(headers),
      ),
      data: data,
    );
  }

  @override
  Future<Response<T>> delete<T>(
    String path, {
    data,
    Map<String, dynamic> headers = const {},
  }) async {
    return dio.delete<T>(
      path,
      options: Options(
        headers: await buildInitialHeaders()
          ..addAll(headers),
      ),
      data: data,
    );
  }

  Future<Map<String, dynamic>> buildInitialHeaders() async {
    final userAgent = await userAgentBuilder.getUserAgent();
    if (jwtHelper != null) {
      if (userAgent == null) {
        return {
          "accept": "application/json",
          "charset": "UTF-8",
          "Authorization": "Bearer ${jwtHelper!.getJwtToken()}",
        };
      } else {
        return {
          "accept": "application/json",
          "charset": "UTF-8",
          "User-Agent": userAgent,
          "Authorization": "Bearer ${jwtHelper!.getJwtToken()}",
        };
      }
    } else {
      if (userAgent == null) {
        return {
          "accept": "application/json",
          "charset": "UTF-8",
        };
      } else {
        return {
          "accept": "application/json",
          "User-Agent": userAgent,
          "charset": "UTF-8",
        };
      }
    }
  }
}
