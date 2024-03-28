import 'package:agora/common/helper/launch_url_helper.dart';
import 'package:agora/design/style/agora_html_styles.dart';
import 'package:agora/design/style/agora_text_styles.dart';
import 'package:agora/pages/consultation/dynamic/dynamic_consultation_page.dart';
import 'package:agora/pages/qag/details/qag_details_page.dart';
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
        data: MediaQueryData(textScaler: MediaQuery.of(context).textScaler),
        child: Html(
          data: data,
          style: AgoraHtmlStyles.htmlStyle(context),
          onLinkTap: (url, _, __) async {
            if (url != null && isQagUrl(url)) {
              Navigator.pushNamed(
                context,
                QagDetailsPage.routeName,
                arguments: QagDetailsArguments(
                  qagId: extractIdFromUrl(url),
                  reload: QagReload.qagsPage,
                ),
              );
            } else if (url != null && isConsultationUrl(url)) {
              Navigator.pushNamed(
                context,
                DynamicConsultationPage.routeName,
                arguments: DynamicConsultationPageArguments(consultationId: extractIdFromUrl(url)),
              );
            } else {
              LaunchUrlHelper.webview(context, url);
            }
          },
          extensions: [_ExcludeSemanticsHtmlExtension()],
        ),
      );
    }
  }

  bool isQagUrl(String url) {
    return url.startsWith("https://agora.beta.gouv.fr/qags/");
  }

  bool isConsultationUrl(String url) {
    return url.startsWith("https://agora.beta.gouv.fr/consultations/");
  }

  String extractIdFromUrl(String url) {
    return url.split("/").last;
  }

  bool isDeeplinkUrl(String url) {
    return url.startsWith("https://agora.beta.gouv.fr/qags/") ||
        url.startsWith("https://agora.beta.gouv.fr/consultations/");
  }
}

class _ExcludeSemanticsHtmlExtension extends HtmlExtension {
  @override
  Set<String> get supportedTags => {"noa11y"};

  @override
  InlineSpan build(ExtensionContext context) {
    return TextSpan(text: context.innerHtml, semanticsLabel: "");
  }
}
