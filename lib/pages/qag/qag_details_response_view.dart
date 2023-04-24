import 'package:agora/bloc/qag/details/qag_details_view_model.dart';
import 'package:agora/bloc/qag/feedback/qag_feedback_bloc.dart';
import 'package:agora/bloc/qag/feedback/qag_feedback_event.dart';
import 'package:agora/bloc/qag/feedback/qag_feedback_state.dart';
import 'package:agora/common/strings/qag_strings.dart';
import 'package:agora/design/agora_button.dart';
import 'package:agora/design/agora_button_style.dart';
import 'package:agora/design/agora_colors.dart';
import 'package:agora/design/agora_spacings.dart';
import 'package:agora/design/agora_text_styles.dart';
import 'package:agora/design/custom_view/agora_error_view.dart';
import 'package:agora/design/custom_view/agora_read_more_text.dart';
import 'package:agora/design/custom_view/agora_video_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class QagDetailsResponseView extends StatelessWidget {
  final String qagId;
  final QagDetailsViewModel detailsViewModel;

  const QagDetailsResponseView({super.key, required this.qagId, required this.detailsViewModel});

  @override
  Widget build(BuildContext context) {
    final response = detailsViewModel.response!;
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
              AgoraVideoView(videoUrl: response.videoUrl),
              SizedBox(height: AgoraSpacings.base),
              RichText(
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
                text: TextSpan(
                  style: AgoraTextStyles.light16.copyWith(color: AgoraColors.primaryGreyOpacity80),
                  children: [
                    TextSpan(text: QagStrings.at),
                    WidgetSpan(child: SizedBox(width: AgoraSpacings.x0_25)),
                    TextSpan(
                      text: detailsViewModel.date,
                      style: AgoraTextStyles.mediumItalic16.copyWith(color: AgoraColors.primaryGreyOpacity80),
                    )
                  ],
                ),
              ),
              SizedBox(height: AgoraSpacings.x1_5),
              RichText(
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
                  bool isThumbUpClicked = true;
                  return feedbackState is QagFeedbackSuccessState ||
                          (feedbackState is QagFeedbackInitialState && response.feedbackStatus)
                      ? Text(QagStrings.feedback)
                      : Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                AgoraButton(
                                  icon: "ic_thumb_white.svg",
                                  label: QagStrings.utils,
                                  style: AgoraButtonStyle.primaryButtonStyle,
                                  isLoading: feedbackState is QagFeedbackLoadingState && isThumbUpClicked,
                                  onPressed: () {
                                    isThumbUpClicked = true;
                                    qagFeedbackBloc.add(QagFeedbackEvent(qagId: qagId, isHelpful: true));
                                  },
                                ),
                                SizedBox(width: AgoraSpacings.base),
                                AgoraButton(
                                  icon: "ic_thumb_down_white.svg",
                                  label: QagStrings.notUtils,
                                  style: AgoraButtonStyle.primaryButtonStyle,
                                  isLoading: feedbackState is QagFeedbackLoadingState && !isThumbUpClicked,
                                  onPressed: () {
                                    isThumbUpClicked = false;
                                    qagFeedbackBloc.add(QagFeedbackEvent(qagId: qagId, isHelpful: false));
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
}
