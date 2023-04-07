import 'package:agora/bloc/consultation/question/consultation_questions_state.dart';
import 'package:agora/common/extension/string_extension.dart';
import 'package:agora/common/strings/consultation_strings.dart';
import 'package:agora/design/agora_colors.dart';
import 'package:agora/design/agora_spacings.dart';
import 'package:agora/design/agora_text_styles.dart';
import 'package:agora/design/custom_view/agora_questions_progress_bar.dart';
import 'package:agora/design/custom_view/agora_questions_response_view.dart';
import 'package:agora/design/custom_view/agora_single_scroll_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AgoraQuestionsView extends StatelessWidget {
  final String questionId;
  final String questionText;
  final int currentQuestionOrder;
  final int totalQuestions;
  final List<ConsultationQuestionResponseChoiceViewModel> responses;
  final Function(String, String) onResponseTap;
  final VoidCallback onBackTap;

  AgoraQuestionsView({
    Key? key,
    required this.questionId,
    required this.questionText,
    required this.currentQuestionOrder,
    required this.totalQuestions,
    required this.responses,
    required this.onResponseTap,
    required this.onBackTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AgoraSingleScrollView(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: AgoraSpacings.x0_75, horizontal: AgoraSpacings.x1_5),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AgoraQuestionsProgressBar(
                  currentQuestion: currentQuestionOrder,
                  totalQuestions: totalQuestions,
                ),
                SizedBox(height: AgoraSpacings.x0_75),
                Text(
                  ConsultationStrings.question.format2(currentQuestionOrder.toString(), totalQuestions.toString()),
                  style: AgoraTextStyles.medium16,
                ),
                SizedBox(height: AgoraSpacings.base),
                Text(
                  questionText,
                  style: AgoraTextStyles.medium20.copyWith(color: AgoraColors.primaryGreen),
                ),
              ],
            ),
          ),
          Flexible(
            child: Container(
              width: double.infinity,
              color: AgoraColors.whiteSmoke,
              child: Padding(
                padding: const EdgeInsets.all(AgoraSpacings.x1_5),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: _buildResponse() + _buildBackButton(),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildResponse() {
    final List<Widget> responseWidgets = [];
    for (final response in responses) {
      responseWidgets.add(
        AgoraQuestionsResponseView(
          responseId: response.id,
          response: response.label,
          onTap: (responseId) => onResponseTap(questionId, responseId),
        ),
      );
      responseWidgets.add(SizedBox(height: AgoraSpacings.base));
    }
    return responseWidgets;
  }

  List<Widget> _buildBackButton() {
    if (currentQuestionOrder != 1) {
      return [
        SizedBox(height: AgoraSpacings.x1_5),
        InkWell(
          onTap: () => onBackTap(),
          child: SizedBox(
            width: 200,
            child: Column(
              children: [
                Row(
                  children: [
                    SvgPicture.asset("assets/ic_forward.svg"),
                    SizedBox(width: AgoraSpacings.base),
                    Expanded(
                      child: Text(
                        ConsultationStrings.previousQuestion,
                        style: AgoraTextStyles.light16.copyWith(color: AgoraColors.blueFrance),
                      ),
                    ),
                  ],
                ),
                Divider(height: 10, color: AgoraColors.blueFrance, thickness: 1),
              ],
            ),
          ),
        ),
      ];
    } else {
      return [];
    }
  }
}
