import 'dart:io';

import 'package:agora/pages/webview/webview_page.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class LaunchUrlHelper {
  static void webview(BuildContext context, String? url) {
    if (url != null) {
      if (Platform.isIOS) {
        _launch(url);
      } else {
        Navigator.pushNamed(context, WebviewPage.routeName, arguments: WebviewArguments(url: url));
      }
    }
  }

  static void _launch(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.inAppWebView);
    }
  }
}
