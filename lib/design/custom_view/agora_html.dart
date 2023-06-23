import 'package:agora/common/helper/launch_url_helper.dart';
import 'package:agora/design/style/agora_html_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';

class AgoraHtml extends StatelessWidget {
  final String data;

  const AgoraHtml({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Html(
      data: data,
      style: AgoraHtmlStyles.htmlStyle,
      onLinkTap: (url, _, __, ___) async {
        LaunchUrlHelper.webview(context, url);
      },
    );
  }
}
