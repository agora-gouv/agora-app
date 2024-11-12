import 'package:agora/common/client/agora_http_client.dart';
import 'package:agora/common/client/user_agent_builder.dart';
import 'package:agora/common/helper/jwt_helper.dart';
import 'package:dio/dio.dart';
import 'package:dio_cache_interceptor/dio_cache_interceptor.dart';
import 'package:http_mock_adapter/http_mock_adapter.dart';

class DioUtils {
  static final _dio = Dio(BaseOptions());
  static final userAgentBuilder = FakeUserAgentBuilder();

  static DioAdapter dioAdapter() {
    return DioAdapter(dio: _dio);
  }

  static AgoraDioHttpClient agoraDioHttpClient() {
    return AgoraDioHttpClient(
      dio: _dio,
      jwtHelper: JwtHelperImpl()..setJwtToken("jwtToken"),
      userAgentBuilder: userAgentBuilder,
      cacheOptions: CacheOptions(
        store: MemCacheStore(),
        policy: CachePolicy.request,
        maxStale: const Duration(days: 14),
      ),
    );
  }
}
