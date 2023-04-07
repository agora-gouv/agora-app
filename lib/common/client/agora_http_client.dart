import 'package:dio/dio.dart';

abstract class AgoraHttpClient {
  Future<Response<T>> post<T>(String path, {data});

  Future<Response<T>> put<T>(String path, {data});

  Future<Response<T>> get<T>(String path);
}

class AgoraDioHttpClient extends AgoraHttpClient {
  final Dio dio;

  AgoraDioHttpClient({required this.dio});

  @override
  Future<Response<T>> get<T>(String path) async {
    return dio.get<T>(
      path,
      options: Options(
        headers: {
          "accept": "application/json",
        },
      ),
    );
  }

  @override
  Future<Response<T>> post<T>(String path, {data}) async {
    return dio.post<T>(
      path,
      options: Options(
        headers: {
          "accept": "application/json",
        },
      ),
      data: data,
    );
  }

  @override
  Future<Response<T>> put<T>(String path, {data}) async {
    return dio.put<T>(
      path,
      options: Options(
        headers: {
          "accept": "application/json",
        },
      ),
      data: data,
    );
  }
}
