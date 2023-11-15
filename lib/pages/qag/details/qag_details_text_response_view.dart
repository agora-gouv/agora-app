import 'package:agora/bloc/qag/details/qag_details_view_model.dart';
import 'package:agora/common/helper/launch_url_helper.dart';
import 'package:agora/design/style/agora_colors.dart';
import 'package:agora/design/style/agora_html_styles.dart';
import 'package:agora/design/style/agora_spacings.dart';
import 'package:agora/design/style/agora_text_styles.dart';
import 'package:agora/pages/consultation/details/consultation_details_page.dart';
import 'package:agora/pages/qag/details/qag_details_page.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';

class QagDetailsTextResponseView extends StatelessWidget {
  final String qagId;
  final QagDetailsViewModel detailsViewModel;

  const QagDetailsTextResponseView({super.key, required this.qagId, required this.detailsViewModel});

  @override
  Widget build(BuildContext context) {
    final textResponse = detailsViewModel.textResponse!;
    return Container(
      width: double.infinity,
      color: AgoraColors.background,
      child: Padding(
        padding: const EdgeInsets.all(AgoraSpacings.horizontalPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Semantics(header: true, child: Text(textResponse.responseLabel, style: AgoraTextStyles.medium17)),
            SizedBox(height: AgoraSpacings.base),
            _AgoraHtml(data: textResponse.responseText),
            SizedBox(height: AgoraSpacings.x2),
          ],
        ),
      ),
    );
  }
}

class _AgoraHtml extends StatelessWidget {
  final String data;

  const _AgoraHtml({required this.data});

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
                ConsultationDetailsPage.routeName,
                arguments: ConsultationDetailsArguments(consultationId: extractIdFromUrl(url)),
              );
            } else {
              LaunchUrlHelper.webview(context, url);
            }
          },
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
