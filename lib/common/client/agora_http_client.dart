import 'package:dio/dio.dart';

abstract class AgoraHttpClient {
  Future<Response<T>> get<T>(String path, {Map<String, dynamic> headers});

  Future<Response<T>> post<T>(String path, {data, Map<String, dynamic> headers});

  Future<Response<T>> delete<T>(String path, {Map<String, dynamic> headers});
}

class AgoraDioHttpClient extends AgoraHttpClient {
  final Dio dio;

  AgoraDioHttpClient({required this.dio});

  @override
  Future<Response<T>> get<T>(String path, {Map<String, dynamic> headers = const {}}) async {
    return dio.get<T>(
      path,
      options: Options(
        headers: {
          "accept": "application/json",
        }..addAll(headers),
      ),
    );
  }

  @override
  Future<Response<T>> post<T>(String path, {data, Map<String, dynamic> headers = const {}}) async {
    return dio.post<T>(
      path,
      options: Options(
        headers: {
          "accept": "application/json",
        }..addAll(headers),
      ),
      data: data,
    );
  }

  @override
  Future<Response<T>> delete<T>(String path, {data, Map<String, dynamic> headers = const {}}) async {
    return dio.delete<T>(
      path,
      options: Options(
        headers: {
          "accept": "application/json",
        }..addAll(headers),
      ),
      data: data,
    );
  }
}
