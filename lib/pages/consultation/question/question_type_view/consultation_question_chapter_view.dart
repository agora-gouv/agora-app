import 'package:agora/bloc/consultation/question/consultation_questions_view_model.dart';
import 'package:agora/common/helper/launch_url_helper.dart';
import 'package:agora/design/agora_button_style.dart';
import 'package:agora/design/agora_html_styles.dart';
import 'package:agora/design/agora_spacings.dart';
import 'package:agora/design/agora_text_styles.dart';
import 'package:agora/design/custom_view/agora_questions_progress_bar.dart';
import 'package:agora/design/custom_view/button/agora_button.dart';
import 'package:agora/pages/consultation/question/consultation_question_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';

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
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: AgoraSpacings.x0_75,
          horizontal: AgoraSpacings.horizontalPadding,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
                AgoraQuestionsProgressBar(
                  currentQuestionOrder: chapter.order,
                  totalQuestions: totalQuestions,
                ),
                SizedBox(height: AgoraSpacings.x0_75),
                Text(chapter.title, style: AgoraTextStyles.medium19),
                SizedBox(height: AgoraSpacings.base),
                Html(
                  data: chapter.description,
                  style: AgoraHtmlStyles.htmlStyle,
                  onLinkTap: (url, _, __, ___) async {
                    LaunchUrlHelper.launch(url);
                  },
                ),
                SizedBox(height: AgoraSpacings.x1_5),
                AgoraButton(
                  label: ConsultationQuestionHelper.buildNextButtonLabel(
                    order: chapter.order,
                    totalQuestions: totalQuestions,
                  ),
                  style: AgoraButtonStyle.primaryButtonStyle,
                  onPressed: () => onNextTap(),
                )
              ] +
              ConsultationQuestionHelper.buildBackButton(order: chapter.order, onBackTap: onBackTap),
        ),
      ),
    );
  }
}
