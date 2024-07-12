import 'package:agora/qag/details/bloc/qag_details_view_model.dart';
import 'package:agora/common/analytics/analytics_event_names.dart';
import 'package:agora/common/analytics/analytics_screen_names.dart';
import 'package:agora/common/helper/tracker_helper.dart';
import 'package:agora/common/strings/qag_strings.dart';
import 'package:agora/design/custom_view/agora_html.dart';
import 'package:agora/design/custom_view/agora_read_more_text.dart';
import 'package:agora/design/custom_view/agora_video_view.dart';
import 'package:agora/design/style/agora_colors.dart';
import 'package:agora/design/style/agora_spacings.dart';
import 'package:agora/design/style/agora_text_styles.dart';
import 'package:flutter/material.dart';

class QagDetailsResponseView extends StatelessWidget {
  final String qagId;
  final QagDetailsViewModel detailsViewModel;

  const QagDetailsResponseView({super.key, required this.qagId, required this.detailsViewModel});

  @override
  Widget build(BuildContext context) {
    final response = detailsViewModel.response!;
    return Container(
      width: double.infinity,
      color: AgoraColors.background,
      child: Padding(
        padding: const EdgeInsets.all(AgoraSpacings.horizontalPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Semantics(header: true, child: Text(QagStrings.governmentResponseTitle, style: AgoraTextStyles.medium17)),
            SizedBox(height: AgoraSpacings.base),
            AgoraVideoView(
              videoUrl: response.videoUrl,
              videoWidth: response.videoWidth,
              videoHeight: response.videoHeight,
              onVideoStartMoreThan5Sec: () {
                TrackerHelper.trackEvent(
                  eventName: "${AnalyticsEventNames.video} $qagId",
                  widgetName: AnalyticsScreenNames.qagDetailsPage,
                );
              },
              isTalkbackEnabled: MediaQuery.of(context).accessibleNavigation,
            ),
            SizedBox(height: AgoraSpacings.base),
            Semantics(
              header: true,
              child: RichText(
                textScaler: MediaQuery.textScalerOf(context),
                text: TextSpan(
                  style: AgoraTextStyles.light16.copyWith(color: AgoraColors.primaryGreyOpacity80),
                  children: [
                    TextSpan(text: QagStrings.by),
                    WidgetSpan(child: SizedBox(width: AgoraSpacings.x0_25)),
                    TextSpan(
                      text: response.author,
                      style: AgoraTextStyles.medium16.copyWith(color: AgoraColors.primaryGreyOpacity90),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: AgoraSpacings.x0_5),
            Padding(
              padding: const EdgeInsets.only(left: AgoraSpacings.horizontalPadding),
              child: Text(
                response.authorDescription,
                style: AgoraTextStyles.mediumItalic14.copyWith(color: AgoraColors.primaryGreyOpacity80),
              ),
            ),
            SizedBox(height: AgoraSpacings.x0_5),
            RichText(
              textScaler: MediaQuery.textScalerOf(context),
              text: TextSpan(
                style: AgoraTextStyles.light16.copyWith(color: AgoraColors.primaryGreyOpacity80),
                children: [
                  TextSpan(text: QagStrings.at),
                  WidgetSpan(child: SizedBox(width: AgoraSpacings.x0_25)),
                  TextSpan(
                    text: response.responseDate,
                    style: AgoraTextStyles.mediumItalic16.copyWith(color: AgoraColors.primaryGreyOpacity80),
                  ),
                ],
              ),
            ),
            SizedBox(height: AgoraSpacings.x1_5),
            RichText(
              textScaler: MediaQuery.textScalerOf(context),
              text: TextSpan(
                style: AgoraTextStyles.regularItalic14.copyWith(color: AgoraColors.primaryGreyOpacity80),
                children: [
                  TextSpan(text: QagStrings.answerTo),
                  WidgetSpan(child: SizedBox(width: AgoraSpacings.x0_25)),
                  TextSpan(
                    text: detailsViewModel.username,
                    style: AgoraTextStyles.mediumItalic14.copyWith(color: AgoraColors.primaryGreyOpacity80),
                  ),
                  WidgetSpan(child: SizedBox(width: AgoraSpacings.x0_25)),
                  TextSpan(text: QagStrings.at),
                  WidgetSpan(child: SizedBox(width: AgoraSpacings.x0_25)),
                  TextSpan(
                    text: detailsViewModel.date,
                    style: AgoraTextStyles.mediumItalic14.copyWith(color: AgoraColors.primaryGreyOpacity80),
                  ),
                ],
              ),
            ),
            SizedBox(height: AgoraSpacings.x1_5),
            Semantics(header: true, child: Text(QagStrings.transcription, style: AgoraTextStyles.medium18)),
            SizedBox(height: AgoraSpacings.x0_5),
            AgoraReadMoreText(response.transcription),
            ..._buildAdditionalInfo(),
            SizedBox(height: AgoraSpacings.x2),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildAdditionalInfo() {
    if (detailsViewModel.response!.additionalInfo != null) {
      final additionalInfo = detailsViewModel.response!.additionalInfo!;
      return [
        SizedBox(height: AgoraSpacings.x1_5),
        Semantics(header: true, child: Text(additionalInfo.title, style: AgoraTextStyles.medium18)),
        SizedBox(height: AgoraSpacings.base),
        AgoraHtml(data: additionalInfo.description),
      ];
    } else {
      return [];
    }
  }
}
