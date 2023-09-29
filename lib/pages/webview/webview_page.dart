import 'package:agora/design/custom_view/agora_scaffold.dart';
import 'package:agora/design/custom_view/agora_toolbar.dart';
import 'package:agora/design/style/agora_colors.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebviewArguments {
  final String url;

  WebviewArguments({required this.url});
}

class WebviewPage extends StatelessWidget {
  static const routeName = "/webviewPage";

  @override
  Widget build(BuildContext context) {
    final arguments = ModalRoute.of(context)!.settings.arguments as WebviewArguments;
    return AgoraScaffold(
      child: Column(
        children: [
          AgoraToolbar(),
          Expanded(
            child: Stack(
              children: [
                Center(child: CircularProgressIndicator()),
                WebViewWidget(
                  controller: WebViewController()
                    ..setJavaScriptMode(JavaScriptMode.unrestricted)
                    ..setBackgroundColor(AgoraColors.white)
                    ..loadRequest(Uri.parse(arguments.url)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
