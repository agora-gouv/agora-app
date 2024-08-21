import 'package:agora/consultation/question/bloc/consultation_questions_view_model.dart';
import 'package:agora/design/custom_view/text/agora_html.dart';
import 'package:agora/design/custom_view/agora_questions_progress_bar.dart';
import 'package:agora/design/custom_view/agora_toolbar.dart';
import 'package:agora/design/style/agora_spacings.dart';
import 'package:agora/design/style/agora_text_styles.dart';
import 'package:agora/common/parser/string_parser.dart';
import 'package:agora/consultation/question/pages/consultation_question_helper.dart';
import 'package:flutter/material.dart';

class ConsultationQuestionChapterView extends StatelessWidget {
  final ConsultationQuestionChapterViewModel chapter;
  final int totalQuestions;
  final int currentQuestionIndex;
  final VoidCallback onNextTap;
  final VoidCallback onBackTap;

  const ConsultationQuestionChapterView({
    super.key,
    required this.chapter,
    required this.totalQuestions,
    required this.currentQuestionIndex,
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
            semanticPageLabel:
                'Information : ${chapter.title.where((el) => !el.isEmoji).map((el) => el.text).join(" ")}',
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AgoraSpacings.horizontalPadding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ExcludeSemantics(
                  child: AgoraQuestionsProgressBar(
                    currentQuestionIndex: currentQuestionIndex,
                    totalQuestions: totalQuestions,
                    isLastQuestion: chapter.nextQuestionId == null,
                  ),
                ),
                SizedBox(height: AgoraSpacings.x0_75),
                ExcludeSemantics(child: _Title(texte: chapter.title)),
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
                        isLastQuestion: chapter.nextQuestionId == null,
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

class _Title extends StatelessWidget {
  final List<StringSegment> texte;

  const _Title({required this.texte});

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        children: texte
            .map(
              (segment) => TextSpan(
                text: segment.text,
                style: AgoraTextStyles.medium19,
              ),
            )
            .toList(),
      ),
    );
  }
}
