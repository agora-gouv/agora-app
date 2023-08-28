import 'package:agora/bloc/consultation/summary/consultation_summary_view_model.dart';
import 'package:agora/common/analytics/analytics_event_names.dart';
import 'package:agora/common/analytics/analytics_screen_names.dart';
import 'package:agora/common/helper/share_helper.dart';
import 'package:agora/common/helper/tracker_helper.dart';
import 'package:agora/common/strings/consultation_strings.dart';
import 'package:agora/design/custom_view/agora_collapse_view.dart';
import 'package:agora/design/custom_view/agora_html.dart';
import 'package:agora/design/custom_view/agora_read_more_text.dart';
import 'package:agora/design/custom_view/agora_video_view.dart';
import 'package:agora/design/custom_view/button/agora_button.dart';
import 'package:agora/design/style/agora_button_style.dart';
import 'package:agora/design/style/agora_colors.dart';
import 'package:agora/design/style/agora_spacings.dart';
import 'package:agora/design/style/agora_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ConsultationSummaryEtEnsuiteTabContent extends StatelessWidget {
  final String consultationTitle;
  final String consultationId;
  final ConsultationSummaryEtEnsuiteViewModel etEnsuiteViewModel;
  final VoidCallback onBackToConsultationClick;
  final ScrollController nestedScrollController;

  const ConsultationSummaryEtEnsuiteTabContent({
    super.key,
    required this.consultationTitle,
    required this.consultationId,
    required this.etEnsuiteViewModel,
    required this.onBackToConsultationClick,
    required this.nestedScrollController,
  });

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      nestedScrollController.animateTo(
        nestedScrollController.position.minScrollExtent,
        duration: const Duration(milliseconds: 600),
        curve: Curves.fastOutSlowIn,
      );
    });
    final video = etEnsuiteViewModel.video;
    final conclusion = etEnsuiteViewModel.conclusion;
    return SingleChildScrollView(
      physics: BouncingScrollPhysics(),
      child: ConstrainedBox(
        constraints: BoxConstraints(minHeight: MediaQuery.of(context).size.height),
        child: Container(
          color: AgoraColors.background,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildStepHeadband(),
              SizedBox(height: AgoraSpacings.x1_5),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: AgoraSpacings.horizontalPadding),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AgoraHtml(data: etEnsuiteViewModel.description),
                    if (etEnsuiteViewModel.explanationsTitle != null) ...[
                      SizedBox(height: AgoraSpacings.x1_5),
                      Text(
                        etEnsuiteViewModel.explanationsTitle!,
                        style: AgoraTextStyles.medium16.copyWith(color: AgoraColors.primaryBlue),
                      ),
                    ],
                  ],
                ),
              ),
              SizedBox(height: AgoraSpacings.x0_5),
              ..._getTogglableSection(etEnsuiteViewModel.explanations),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AgoraSpacings.horizontalPadding,
                  vertical: AgoraSpacings.x1_5,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (video != null) ...[
                      Text(video.title, style: AgoraTextStyles.medium16.copyWith(color: AgoraColors.primaryBlue)),
                      SizedBox(height: AgoraSpacings.x0_5),
                      AgoraHtml(data: video.intro),
                      SizedBox(height: AgoraSpacings.base),
                      AgoraVideoView(
                        videoUrl: video.videoUrl,
                        videoWidth: video.videoWidth,
                        videoHeight: video.videoHeight,
                        onVideoStartMoreThan5Sec: () {
                          TrackerHelper.trackEvent(
                            eventName: "${AnalyticsEventNames.video} $consultationId",
                            widgetName: AnalyticsScreenNames.consultationSummaryEtEnsuitePage,
                          );
                        },
                      ),
                      SizedBox(height: AgoraSpacings.x1_5),
                      AgoraReadMoreText(video.transcription),
                      SizedBox(height: AgoraSpacings.base),
                    ],
                    if (conclusion != null) ...[
                      SizedBox(height: AgoraSpacings.base),
                      Text(conclusion.title, style: AgoraTextStyles.medium16.copyWith(color: AgoraColors.primaryBlue)),
                      SizedBox(height: AgoraSpacings.x0_5),
                      AgoraHtml(data: conclusion.description),
                      SizedBox(height: AgoraSpacings.base),
                    ],
                    SizedBox(height: AgoraSpacings.base),
                    Divider(color: AgoraColors.divider, thickness: 1),
                    SizedBox(height: AgoraSpacings.x1_5),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Flexible(
                          child: AgoraButton(
                            label: ConsultationStrings.returnToHome,
                            style: AgoraButtonStyle.lightGreyWithBorderButtonStyle,
                            onPressed: () => onBackToConsultationClick(),
                          ),
                        ),
                        SizedBox(width: AgoraSpacings.base),
                        AgoraButton(
                          label: ConsultationStrings.share,
                          icon: "ic_share_white.svg",
                          style: AgoraButtonStyle.primaryButtonStyle,
                          onPressed: () async {
                            TrackerHelper.trackClick(
                              clickName: AnalyticsEventNames.shareConsultationResults,
                              widgetName: "${AnalyticsScreenNames.consultationSummaryEtEnsuitePage} $consultationId",
                            );
                            ShareHelper.shareConsultation(
                              context: context,
                              title: consultationTitle,
                              id: consultationId,
                            );
                          },
                        ),
                      ],
                    ),
                    SizedBox(height: AgoraSpacings.x2_5),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SvgPicture.asset("assets/ic_bell.svg", excludeFromSemantics: true),
                        SizedBox(width: AgoraSpacings.x0_75),
                        Expanded(
                          child: Text(
                            ConsultationStrings.notificationInformation,
                            style: AgoraTextStyles.light14,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: AgoraSpacings.base),
                    // AgoraButton(
                    //   label: ConsultationStrings.refuseNotification,
                    //   style: AgoraButtonStyle.greyButtonStyle,
                    //   onPressed: () {
                    //     // TODO activate notification
                    //   },
                    // ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStepHeadband() {
    return Container(
      color: AgoraColors.stoicWhite,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AgoraSpacings.horizontalPadding,
          vertical: AgoraSpacings.base,
        ),
        child: Row(
          children: [
            SvgPicture.asset(etEnsuiteViewModel.image, width: 115, excludeFromSemantics: true),
            SizedBox(width: AgoraSpacings.base),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    etEnsuiteViewModel.step,
                    style: AgoraTextStyles.medium15.copyWith(color: AgoraColors.primaryBlue),
                    semanticsLabel: etEnsuiteViewModel.stepSemanticsLabel,
                  ),
                  Text(etEnsuiteViewModel.title, style: AgoraTextStyles.medium18),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  List<Widget> _getTogglableSection(List<ConsultationSummaryEtEnsuiteExplanationViewModel> explanations) {
    return explanations.map(
      (explanation) {
        if (explanation.isTogglable) {
          return AgoraCollapseView(
            title: explanation.title,
            collapseContent: Container(
              color: AgoraColors.white,
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: AgoraSpacings.horizontalPadding,
                  vertical: AgoraSpacings.x1_5,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(width: double.infinity),
                    ..._getCollapseContent(explanation),
                  ],
                ),
              ),
            ),
          );
        } else {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AgoraSpacings.horizontalPadding,
                  vertical: AgoraSpacings.x0_5,
                ),
                child: Text(explanation.title, style: AgoraTextStyles.medium16),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: AgoraSpacings.horizontalPadding),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: _getCollapseContent(explanation),
                ),
              ),
            ],
          );
        }
      },
    ).toList();
  }

  List<Widget> _getCollapseContent(ConsultationSummaryEtEnsuiteExplanationViewModel explanation) {
    return [
      AgoraHtml(data: explanation.intro),
      SizedBox(height: AgoraSpacings.base),
      Image.network(explanation.imageUrl),
      SizedBox(height: AgoraSpacings.base),
      AgoraHtml(data: explanation.description),
    ];
  }
}
