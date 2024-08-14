import 'dart:async';
import 'dart:ui';

import 'package:agora/common/log/log.dart';
import 'package:app_links/app_links.dart';

class DeeplinkHelper {
  static const String _consultationPath = "consultations";
  static const String _qagPath = "qags";
  static final _uuidRegExp =
      RegExp(r'[0-9a-fA-F]{8}\b-[0-9a-fA-F]{4}\b-[0-9a-fA-F]{4}\b-[0-9a-fA-F]{4}\b-[0-9a-fA-F]{12}');
  late StreamSubscription<Uri> _sub;

  Future<void> onInitial({
    required Function(String consutlationId) onConsultationSuccessCallback,
    required Function(String qagId) onQagSuccessCallback,
  }) async {
    final appLinks = AppLinks();
    final uri = await appLinks.getInitialLink();
    if (uri != null) {
      Log.d("deeplink initiate uri : $uri");
      final featurePath = uri.pathSegments.first;
      final idOrSlug = uri.pathSegments.last;
      switch (featurePath) {
        case _consultationPath:
          onConsultationSuccessCallback(idOrSlug);
          break;
        case _qagPath:
          _handleDeeplink(
            id: idOrSlug,
            onMatchSuccessCallback: (id) => onQagSuccessCallback(id),
            onMatchFailedCallback: () => Log.e("deeplink initiate uri : no qag id match error"),
          );
          break;
        default:
          Log.e("deeplink initiate uri : unknown path error: ${uri.path}");
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
    final appLinks = AppLinks();

    _sub = appLinks.uriLinkStream.listen(
      (Uri uri) {
        final featurePath = uri.pathSegments.first;
        final idOrSlug = uri.pathSegments.last;
        switch (featurePath) {
          case _consultationPath:
            onConsultationSuccessCallback(idOrSlug);
            break;
          case _qagPath:
            _handleDeeplink(
              id: idOrSlug,
              onMatchSuccessCallback: (id) => onQagSuccessCallback(id),
              onMatchFailedCallback: () => Log.e("deeplink listen uri : no qag id match error"),
            );
            break;
          default:
            Log.e("deeplink listen uri : unknown path error: ${uri.path}");
            break;
        }
      },
      onError: (Object err) {
        Log.d("link error: $err");
      },
    );
  }

  void _handleDeeplink({
    required String id,
    required Function(String id) onMatchSuccessCallback,
    required VoidCallback onMatchFailedCallback,
  }) {
    final RegExpMatch? match = _uuidRegExp.firstMatch(id);
    if (match != null && match[0] != null) {
      onMatchSuccessCallback(match[0]!);
    } else {
      onMatchFailedCallback();
    }
  }

  void dispose() {
    _sub.cancel();
  }
}
