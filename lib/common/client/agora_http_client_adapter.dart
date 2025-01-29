import 'package:agora/common/helper/flavor_helper.dart';
import 'package:basic_utils/basic_utils.dart';
import 'package:dio_http2_adapter/dio_http2_adapter.dart';

class AgoraHttpClientAdapter extends Http2Adapter {
  AgoraHttpClientAdapter({required String baseUrl, required List<X509CertificateData> rootCertificate})
      : super(
          _buildConnectionManager(
            baseUrlHost: Uri.parse(baseUrl).host,
            rootCertificateX509: rootCertificate,
          ),
        );

  static ConnectionManager _buildConnectionManager({
    required String baseUrlHost,
    required List<X509CertificateData> rootCertificateX509,
  }) {
    return switch (FlavorHelper.getFlavor()) {
      AgoraFlavor.dev => ConnectionManager(),
      AgoraFlavor.local => ConnectionManager(
          onClientCreate: (_, config) {
            config.validateCertificate = (certificate, host, _) {
              return true;
            };
            config.onBadCertificate = (_) {
              return true;
            };
          },
        ),
      AgoraFlavor.sandbox => ConnectionManager(),
      AgoraFlavor.prod => ConnectionManager(
          onClientCreate: (_, config) {
            config.validateCertificate = (hostCertificate, host, _) {
              if (host == baseUrlHost && hostCertificate != null) {
                final serverX509 = X509Utils.x509CertificateFromPem(X509Utils.crlDerToPem(hostCertificate.der));
                return rootCertificateX509.any(
                  (certificate) => X509Utils.checkChain([serverX509, certificate]).isValid(),
                );
              }
              return true;
            };
          },
        ),
    };
  }
}
