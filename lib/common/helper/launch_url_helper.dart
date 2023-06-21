import 'dart:io';

import 'package:agora/design/style/agora_colors.dart';
import 'package:agora/pages/webview/webview_page.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';

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

  static WebViewController webViewController({
    required String url,
    Color backgroundColor = AgoraColors.white,
  }) {
    String finalUrl;
    if (url.endsWith(".pdf")) {
      finalUrl = "https://docs.google.com/gview?embedded=true&url=$url";
    } else {
      finalUrl = url;
    }
    return WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(backgroundColor)
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            // Update loading bar.
          },
        ),
      )
      ..loadRequest(Uri.parse(finalUrl));
  }
}
