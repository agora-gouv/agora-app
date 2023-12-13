import 'dart:typed_data';

import 'package:basic_utils/basic_utils.dart';
import 'package:dio_http2_adapter/dio_http2_adapter.dart';

class AgoraHttpClientAdapter extends Http2Adapter {
  AgoraHttpClientAdapter({required String baseUrl, required Uint8List rootCertificate})
      : super(
          _buildConnectionManager(
            baseUrlHost: Uri.parse(baseUrl).host,
            rootCertificateX509: X509Utils.x509CertificateFromPem(X509Utils.crlDerToPem(rootCertificate)),
          ),
        );

  static ConnectionManager _buildConnectionManager({
    required String baseUrlHost,
    required X509CertificateData rootCertificateX509,
  }) {
    return ConnectionManager(
      onClientCreate: (_, config) {
        config.validateCertificate = (certificate, host, _) {
          if (host == baseUrlHost && certificate != null) {
            final serverX509 = X509Utils.x509CertificateFromPem(X509Utils.crlDerToPem(certificate.der));
            return rootCertificateX509.signature == serverX509.signature;
          }
          return true;
        };
      },
    );
  }
}
