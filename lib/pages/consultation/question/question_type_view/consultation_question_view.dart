import 'package:agora/design/custom_view/agora_questions_progress_bar.dart';
import 'package:agora/design/custom_view/agora_single_scroll_view.dart';
import 'package:agora/design/custom_view/agora_toolbar.dart';
import 'package:agora/design/style/agora_colors.dart';
import 'package:agora/design/style/agora_spacings.dart';
import 'package:agora/design/style/agora_text_styles.dart';
import 'package:flutter/material.dart';

class ConsultationQuestionView extends StatelessWidget {
  final int order;
  final int totalQuestions;
  final String questionProgress;
  final String title;
  final Widget child;

  ConsultationQuestionView({
    Key? key,
    required this.order,
    required this.totalQuestions,
    required this.questionProgress,
    required this.title,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AgoraSingleScrollView(
      physics: BouncingScrollPhysics(),
      child: Column(
        children: [
          AgoraToolbar(style: AgoraToolbarStyle.close),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AgoraSpacings.horizontalPadding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AgoraQuestionsProgressBar(
                  currentQuestionOrder: order,
                  totalQuestions: totalQuestions,
                ),
                SizedBox(height: AgoraSpacings.x0_75),
                Text(questionProgress, style: AgoraTextStyles.medium16),
                SizedBox(height: AgoraSpacings.base),
                Text(
                  title,
                  style: AgoraTextStyles.medium20.copyWith(color: AgoraColors.primaryBlue),
                ),
                SizedBox(height: AgoraSpacings.x0_75),
              ],
            ),
          ),
          Flexible(
            child: Container(
              width: double.infinity,
              color: AgoraColors.background,
              child: Padding(
                padding: const EdgeInsets.all(AgoraSpacings.horizontalPadding),
                child: child,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
