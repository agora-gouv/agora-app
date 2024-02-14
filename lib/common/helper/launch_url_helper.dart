import 'package:agora/common/helper/platform_helper.dart';
import 'package:agora/pages/webview/webview_page.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

/// see https://pub.dev/packages/url_launcher
/// see https://pub.dev/packages/webview_flutter
class LaunchUrlHelper {
  static void webview(BuildContext context, String? url) {
    if (url != null) {
      if (PlatformStaticHelper.isIOS() || kIsWeb) {
        launchUrlFromAgora(url: url);
      } else if (PlatformStaticHelper.isAndroid()) {
        if (url.endsWith(".pdf")) {
          launchUrlFromAgora(
            url: "https://docs.google.com/gview?embedded=true&url=$url",
            launchMode: LaunchMode.externalApplication,
          );
        } else {
          Navigator.pushNamed(context, WebviewPage.routeName, arguments: WebviewArguments(url: url));
        }
      }
    }
  }

  static void launchStore() {
    final isAndroid = PlatformStaticHelper.isAndroid();
    final isIos = PlatformStaticHelper.isIOS();
    if (isAndroid || isIos) {
      final appId = isAndroid ? "fr.gouv.agora" : "6449599025";
      final url = isAndroid ? "market://details?id=$appId" : "https://apps.apple.com/app/id$appId";
      launchUrlFromAgora(url: url, launchMode: LaunchMode.externalApplication);
    }
  }

  static void launchUrlFromAgora({required String url, LaunchMode launchMode = LaunchMode.inAppWebView}) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: launchMode);
    }
  }

  static Future<void> mailtoAgora() async {
    final uri = Uri.parse('mailto:contact@agora.gouv.fr');
    launchUrl(uri);
  }
}
