import 'package:dio_http2_adapter/dio_http2_adapter.dart';

class AgoraHttpClientAdapter extends Http2Adapter {
  AgoraHttpClientAdapter({required String baseUrl})
      : super(
          ConnectionManager(),
        );
}
