import 'package:agora/bloc/consultation/question/consultation_questions_view_model.dart';
import 'package:agora/design/custom_view/agora_question_response_choice_view.dart';
import 'package:agora/design/style/agora_spacings.dart';
import 'package:agora/domain/consultation/questions/responses/consultation_question_response.dart';
import 'package:agora/pages/consultation/question/consultation_question_helper.dart';
import 'package:agora/pages/consultation/question/question_type_view/consultation_question_view.dart';
import 'package:flutter/material.dart';

class ConsultationQuestionUniqueChoiceView extends StatelessWidget {
  final ConsultationQuestionUniqueViewModel uniqueChoiceQuestion;
  final ConsultationQuestionResponses? previousResponses;
  final int totalQuestions;
  final Function(String, String) onUniqueResponseTap;
  final VoidCallback onBackTap;

  ConsultationQuestionUniqueChoiceView({
    Key? key,
    required this.uniqueChoiceQuestion,
    required this.previousResponses,
    required this.totalQuestions,
    required this.onUniqueResponseTap,
    required this.onBackTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ConsultationQuestionView(
      order: uniqueChoiceQuestion.order,
      totalQuestions: totalQuestions,
      questionProgress: uniqueChoiceQuestion.questionProgress,
      title: uniqueChoiceQuestion.title,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: _buildUniqueChoiceResponse() +
            ConsultationQuestionHelper.buildBackButton(
              order: uniqueChoiceQuestion.order,
              onBackTap: onBackTap,
            ),
      ),
    );
  }

  List<Widget> _buildUniqueChoiceResponse() {
    final List<Widget> responseWidgets = [];
    for (final response in uniqueChoiceQuestion.responseChoicesViewModels) {
      responseWidgets.add(
        AgoraQuestionResponseChoiceView(
          responseId: response.id,
          response: response.label,
          isSelected: _isResponseAlreadySelected(response.id),
          onTap: (responseId) {
            onUniqueResponseTap(uniqueChoiceQuestion.id, responseId);
          },
        ),
      );
      responseWidgets.add(SizedBox(height: AgoraSpacings.base));
    }
    return responseWidgets;
  }

  bool _isResponseAlreadySelected(String responseId) {
    return previousResponses != null ? previousResponses!.responseIds.contains(responseId) : false;
  }
}
