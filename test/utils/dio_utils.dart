import 'package:agora/common/client/agora_http_client.dart';
import 'package:agora/common/helper/jwt_helper.dart';
import 'package:dio/dio.dart';
import 'package:http_mock_adapter/http_mock_adapter.dart';

class DioUtils {
  static final _dio = Dio(BaseOptions());

  static DioAdapter dioAdapter() {
    return DioAdapter(dio: _dio);
  }

  static AgoraDioHttpClient agoraDioHttpClient() {
    return AgoraDioHttpClient(
      dio: _dio,
      jwtHelper: JwtHelper()..setJwtToken("jwtToken"),
    );
  }
}
