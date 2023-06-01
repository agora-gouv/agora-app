import 'dart:async';
import 'dart:ui';

import 'package:agora/common/log/log.dart';
import 'package:uni_links/uni_links.dart';

class DeeplinkTestHelper {
  static const String consultationHost = "consultation.gouv.fr";
  static const String qagHost = "qag.gouv.fr";
  static final uuidRegExp =
      RegExp(r'[0-9a-fA-F]{8}\b-[0-9a-fA-F]{4}\b-[0-9a-fA-F]{4}\b-[0-9a-fA-F]{4}\b-[0-9a-fA-F]{12}');

  StreamSubscription<Uri?>? _sub;

  Future<void> onInitial({
    required Function(String consutlationId) onConsultationSuccessCallback,
    required Function(String qagId) onQagSuccessCallback,
  }) async {
    final uri = await getInitialUri();
    if (uri != null) {
      Log.d("deeplink initiate uri : $uri");
      switch (uri.host) {
        case consultationHost:
          _handleDeeplink(
            uri: uri,
            onMatchSuccessCallback: (id) => onConsultationSuccessCallback(id),
            onMatchFailedCallback: () => Log.e("deeplink initiate uri : no consultation id match error"),
          );
          break;
        case qagHost:
          _handleDeeplink(
            uri: uri,
            onMatchSuccessCallback: (id) => onQagSuccessCallback(id),
            onMatchFailedCallback: () => Log.e("deeplink initiate uri : no qag id match error"),
          );
          break;
        default:
          Log.e("deeplink initiate uri : unknown host error");
          break;
      }
    } else {
      Log.d("deeplink initiate uri : null uri error");
    }
  }

  Future<void> onGetUriLinkStream({
    required Function(String consutlationId) onConsultationSuccessCallback,
    required Function(String qagId) onQagSuccessCallback,
  }) async {
    _sub = uriLinkStream.listen(
      (Uri? uri) {
        if (uri != null) {
          switch (uri.host) {
            case consultationHost:
              _handleDeeplink(
                uri: uri,
                onMatchSuccessCallback: (id) => onConsultationSuccessCallback(id),
                onMatchFailedCallback: () => Log.e("deeplink listen uri : no consultation id match error"),
              );
              break;
            case qagHost:
              _handleDeeplink(
                uri: uri,
                onMatchSuccessCallback: (id) => onQagSuccessCallback(id),
                onMatchFailedCallback: () => Log.e("deeplink listen uri : no qag id match error"),
              );
              break;
            default:
              Log.e("deeplink listen uri : unknown host error");
              break;
          }
        } else {
          Log.d("deeplink listen uri : null uri error");
        }
      },
      onError: (Object err) {
        Log.d("link error: $err");
      },
    );
  }

  void _handleDeeplink({
    required Uri uri,
    required Function(String id) onMatchSuccessCallback,
    required VoidCallback onMatchFailedCallback,
  }) {
    final RegExpMatch? match = uuidRegExp.firstMatch(uri.toString());
    if (match != null && match[0] != null) {
      onMatchSuccessCallback(match[0]!);
    } else {
      onMatchFailedCallback();
    }
  }

  void dispose() {
    _sub?.cancel();
  }
}
