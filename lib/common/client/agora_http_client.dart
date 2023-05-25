import 'package:agora/common/helper/jwt_helper.dart';
import 'package:dio/dio.dart';

abstract class AgoraHttpClient {
  Future<Response<T>> get<T>(
    String path, {
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

  AgoraDioHttpClient({required this.dio, this.jwtHelper});

  @override
  Future<Response<T>> get<T>(
    String path, {
    Map<String, dynamic> queryParameters = const {},
    Map<String, dynamic> headers = const {},
  }) async {
    return dio.get<T>(
      path,
      queryParameters: queryParameters,
      options: Options(headers: buildInitialHeaders()..addAll(headers)),
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
      options: Options(headers: buildInitialHeaders()..addAll(headers)),
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
      options: Options(headers: buildInitialHeaders()..addAll(headers)),
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
      options: Options(headers: buildInitialHeaders()..addAll(headers)),
      data: data,
    );
  }

  Map<String, dynamic> buildInitialHeaders() {
    if (jwtHelper != null) {
      return {
        "accept": "application/json",
        "Authorization": "Bearer ${jwtHelper!.getJwtToken()}",
      };
    } else {
      return {
        "accept": "application/json",
      };
    }
  }
}
