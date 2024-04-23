import 'package:agora/bloc/consultation/question/consultation_questions_view_model.dart';
import 'package:agora/design/custom_view/agora_html.dart';
import 'package:agora/design/custom_view/agora_questions_progress_bar.dart';
import 'package:agora/design/custom_view/agora_toolbar.dart';
import 'package:agora/design/style/agora_spacings.dart';
import 'package:agora/design/style/agora_text_styles.dart';
import 'package:agora/pages/consultation/question/consultation_question_helper.dart';
import 'package:flutter/material.dart';

class ConsultationQuestionChapterView extends StatelessWidget {
  final ConsultationQuestionChapterViewModel chapter;
  final int totalQuestions;
  final VoidCallback onNextTap;
  final VoidCallback onBackTap;

  const ConsultationQuestionChapterView({
    super.key,
    required this.chapter,
    required this.totalQuestions,
    required this.onNextTap,
    required this.onBackTap,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: BouncingScrollPhysics(),
      child: Column(
        children: [
          AgoraToolbar(
            style: AgoraToolbarStyle.close,
            pageLabel: 'Questionnaire consultation',
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AgoraSpacings.horizontalPadding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AgoraQuestionsProgressBar(
                  currentQuestionIndex: chapter.order,
                  totalQuestions: totalQuestions,
                ),
                SizedBox(height: AgoraSpacings.x0_75),
                Text(chapter.title, style: AgoraTextStyles.medium19),
                SizedBox(height: AgoraSpacings.base),
                AgoraHtml(data: chapter.description),
                SizedBox(height: AgoraSpacings.x1_5),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    ConsultationQuestionHelper.buildBackButton(order: chapter.order, onBackTap: onBackTap),
                    const SizedBox(width: 20),
                    Flexible(
                      child: ConsultationQuestionHelper.buildNextQuestion(
                        order: chapter.order,
                        totalQuestions: totalQuestions,
                        onPressed: () => onNextTap(),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(height: AgoraSpacings.x1_5),
        ],
      ),
    );
  }
}
