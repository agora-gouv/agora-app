import 'dart:io';

import 'package:agora/pages/webview/webview_page.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class LaunchUrlHelper {
  static void webview(BuildContext context, String? url) {
    if (url != null) {
      if (Platform.isIOS) {
        _launch(url: url);
      } else if (Platform.isAndroid) {
        if (url.endsWith(".pdf")) {
          _launch(
            url: "https://docs.google.com/gview?embedded=true&url=$url",
            launchMode: LaunchMode.externalApplication,
          );
        } else {
          Navigator.pushNamed(context, WebviewPage.routeName, arguments: WebviewArguments(url: url));
        }
      }
    }
  }

  static void _launch({required String url, LaunchMode launchMode = LaunchMode.inAppWebView}) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: launchMode);
    }
  }
}
