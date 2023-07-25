import 'package:agora/common/helper/launch_url_helper.dart';
import 'package:agora/design/style/agora_html_styles.dart';
import 'package:agora/design/style/agora_text_styles.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';

class AgoraHtml extends StatelessWidget {
  final String data;

  const AgoraHtml({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    if (kIsWeb) {
      return HtmlWidget(
        data,
        textStyle: AgoraTextStyles.light14,
      );
    } else {
      return MediaQuery(
        data: MediaQueryData(textScaleFactor: 1),
        child: Html(
          data: data,
          style: AgoraHtmlStyles.htmlStyle(context),
          onLinkTap: (url, _, __, ___) async {
            LaunchUrlHelper.webview(context, url);
          },
        ),
      );
    }
  }
}
