import 'package:dio_http2_adapter/dio_http2_adapter.dart';

class AgoraHttpClientAdapter extends Http2Adapter {
  AgoraHttpClientAdapter({required String baseUrl})
      : super(_buildConnectionManager(baseUrlHost: Uri.parse(baseUrl).host));

  static ConnectionManager _buildConnectionManager({required String baseUrlHost}) {
    return ConnectionManager(
      onClientCreate: (_, config) {
        config.validateCertificate = (certificate, host, _) {
          if (host == baseUrlHost) {
            // TODO
          }
          return true;
        };
      },
    );
  }
}
