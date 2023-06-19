import 'package:agora/bloc/consultation/question/consultation_questions_view_model.dart';
import 'package:agora/design/custom_view/agora_question_response_choice_view.dart';
import 'package:agora/design/style/agora_spacings.dart';
import 'package:agora/domain/consultation/questions/responses/consultation_question_response.dart';
import 'package:agora/pages/consultation/question/consultation_question_helper.dart';
import 'package:agora/pages/consultation/question/question_type_view/consultation_question_view.dart';
import 'package:flutter/material.dart';

class ConsultationQuestionWithConditionsView extends StatelessWidget {
  final ConsultationQuestionWithConditionViewModel questionWithConditions;
  final ConsultationQuestionResponses? previousResponses;
  final int totalQuestions;
  final Function(String questionId, String responseId, String nextQuestionId) onWithConditionResponseTap;
  final VoidCallback onBackTap;

  ConsultationQuestionWithConditionsView({
    Key? key,
    required this.questionWithConditions,
    required this.previousResponses,
    required this.totalQuestions,
    required this.onWithConditionResponseTap,
    required this.onBackTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ConsultationQuestionView(
      order: questionWithConditions.order,
      totalQuestions: totalQuestions,
      questionProgress: questionWithConditions.questionProgress,
      title: questionWithConditions.title,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: _buildWithConditionsResponse() +
            ConsultationQuestionHelper.buildBackButton(
              order: questionWithConditions.order,
              onBackTap: onBackTap,
            ),
      ),
    );
  }

  List<Widget> _buildWithConditionsResponse() {
    final List<Widget> responseWidgets = [];
    for (final response in questionWithConditions.responseChoicesViewModels) {
      responseWidgets.add(
        AgoraQuestionResponseChoiceView(
          responseId: response.id,
          responseLabel: response.label,
          isSelected: _isResponseAlreadySelected(response.id),
          onTap: (responseId) {
            onWithConditionResponseTap(questionWithConditions.id, responseId, response.nextQuestionId);
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
