import 'package:agora/bloc/qag/details/qag_details_view_model.dart';
import 'package:agora/bloc/qag/feedback/qag_feedback_bloc.dart';
import 'package:agora/bloc/qag/feedback/qag_feedback_event.dart';
import 'package:agora/bloc/qag/feedback/qag_feedback_state.dart';
import 'package:agora/common/analytics/analytics_event_names.dart';
import 'package:agora/common/analytics/analytics_screen_names.dart';
import 'package:agora/common/helper/tracker_helper.dart';
import 'package:agora/common/strings/qag_strings.dart';
import 'package:agora/design/custom_view/agora_error_view.dart';
import 'package:agora/design/custom_view/agora_read_more_text.dart';
import 'package:agora/design/custom_view/agora_video_view.dart';
import 'package:agora/design/custom_view/button/agora_rounded_button.dart';
import 'package:agora/design/style/agora_colors.dart';
import 'package:agora/design/style/agora_spacings.dart';
import 'package:agora/design/style/agora_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class QagDetailsResponseView extends StatefulWidget {
  final String qagId;
  final QagDetailsViewModel detailsViewModel;

  const QagDetailsResponseView({super.key, required this.qagId, required this.detailsViewModel});

  @override
  State<QagDetailsResponseView> createState() => _QagDetailsResponseViewState();
}

class _QagDetailsResponseViewState extends State<QagDetailsResponseView> {
  bool isThumbUpClicked = true;

  @override
  Widget build(BuildContext context) {
    final response = widget.detailsViewModel.response!;
    return Flexible(
      child: Container(
        width: double.infinity,
        color: AgoraColors.background,
        child: Padding(
          padding: const EdgeInsets.all(AgoraSpacings.horizontalPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(QagStrings.governmentResponseTitle, style: AgoraTextStyles.medium17),
              SizedBox(height: AgoraSpacings.base),
              AgoraVideoView(
                videoUrl: response.videoUrl,
                videoWidth: response.videoWidth,
                videoHeight: response.videoHeight,
                onVideoStartMoreThan5Sec: () {
                  TrackerHelper.trackEvent(
                    eventName: "${AnalyticsEventNames.video} ${widget.qagId}",
                    widgetName: AnalyticsScreenNames.qagDetailsPage,
                  );
                },
              ),
              SizedBox(height: AgoraSpacings.base),
              RichText(
                textScaleFactor: MediaQuery.of(context).textScaleFactor,
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
                textScaleFactor: MediaQuery.of(context).textScaleFactor,
                text: TextSpan(
                  style: AgoraTextStyles.light16.copyWith(color: AgoraColors.primaryGreyOpacity80),
                  children: [
                    TextSpan(text: QagStrings.at),
                    WidgetSpan(child: SizedBox(width: AgoraSpacings.x0_25)),
                    TextSpan(
                      text: widget.detailsViewModel.date,
                      style: AgoraTextStyles.mediumItalic16.copyWith(color: AgoraColors.primaryGreyOpacity80),
                    )
                  ],
                ),
              ),
              SizedBox(height: AgoraSpacings.x1_5),
              RichText(
                textScaleFactor: MediaQuery.of(context).textScaleFactor,
                text: TextSpan(
                  style: AgoraTextStyles.regularItalic14.copyWith(color: AgoraColors.primaryGreyOpacity80),
                  children: [
                    TextSpan(text: QagStrings.answerTo),
                    WidgetSpan(child: SizedBox(width: AgoraSpacings.x0_25)),
                    TextSpan(
                      text: widget.detailsViewModel.username,
                      style: AgoraTextStyles.mediumItalic14.copyWith(color: AgoraColors.primaryGreyOpacity80),
                    ),
                    WidgetSpan(child: SizedBox(width: AgoraSpacings.x0_25)),
                    TextSpan(text: QagStrings.at),
                    WidgetSpan(child: SizedBox(width: AgoraSpacings.x0_25)),
                    TextSpan(
                      text: widget.detailsViewModel.date,
                      style: AgoraTextStyles.mediumItalic14.copyWith(color: AgoraColors.primaryGreyOpacity80),
                    )
                  ],
                ),
              ),
              SizedBox(height: AgoraSpacings.x1_5),
              AgoraReadMoreText(response.transcription),
              SizedBox(height: AgoraSpacings.x2),
              Text(QagStrings.questionUtilsTitle, style: AgoraTextStyles.medium18),
              SizedBox(height: AgoraSpacings.base),
              BlocBuilder<QagFeedbackBloc, QagFeedbackState>(
                builder: (context, feedbackState) {
                  final qagFeedbackBloc = context.read<QagFeedbackBloc>();
                  return feedbackState is QagFeedbackSuccessState ||
                          (feedbackState is QagFeedbackInitialState && response.feedbackStatus)
                      ? Text(QagStrings.feedback)
                      : Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                AgoraRoundedButton(
                                  icon: "ic_thumb_white.svg",
                                  label: QagStrings.utils,
                                  contentPadding: AgoraRoundedButtonPadding.short,
                                  isLoading: feedbackState is QagFeedbackLoadingState && isThumbUpClicked,
                                  onPressed: () {
                                    _trackFeedback();
                                    setState(() => isThumbUpClicked = true);
                                    qagFeedbackBloc.add(QagFeedbackEvent(qagId: widget.qagId, isHelpful: true));
                                  },
                                ),
                                SizedBox(width: AgoraSpacings.base),
                                AgoraRoundedButton(
                                  icon: "ic_thumb_down_white.svg",
                                  label: QagStrings.notUtils,
                                  contentPadding: AgoraRoundedButtonPadding.short,
                                  isLoading: feedbackState is QagFeedbackLoadingState && !isThumbUpClicked,
                                  onPressed: () {
                                    _trackFeedback();
                                    setState(() => isThumbUpClicked = false);
                                    qagFeedbackBloc.add(QagFeedbackEvent(qagId: widget.qagId, isHelpful: false));
                                  },
                                ),
                              ],
                            ),
                            if (feedbackState is QagFeedbackErrorState) ...[
                              SizedBox(height: AgoraSpacings.base),
                              AgoraErrorView(),
                            ]
                          ],
                        );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _trackFeedback() {
    TrackerHelper.trackClick(
      clickName: "${AnalyticsEventNames.giveQagFeedback} ${widget.qagId}",
      widgetName: AnalyticsScreenNames.qagDetailsPage,
    );
  }
}
