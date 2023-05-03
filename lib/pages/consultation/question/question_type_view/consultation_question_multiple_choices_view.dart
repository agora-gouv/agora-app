import 'package:agora/bloc/consultation/question/consultation_questions_view_model.dart';
import 'package:agora/common/extension/string_extension.dart';
import 'package:agora/common/strings/consultation_strings.dart';
import 'package:agora/design/agora_button_style.dart';
import 'package:agora/design/agora_spacings.dart';
import 'package:agora/design/agora_text_styles.dart';
import 'package:agora/design/custom_view/agora_question_response_choice_view.dart';
import 'package:agora/design/custom_view/button/agora_button.dart';
import 'package:agora/domain/consultation/questions/responses/consultation_question_response.dart';
import 'package:agora/pages/consultation/question/consultation_question_helper.dart';
import 'package:agora/pages/consultation/question/question_type_view/consultation_question_view.dart';
import 'package:flutter/material.dart';

class ConsultationQuestionMultipleChoicesView extends StatefulWidget {
  final ConsultationQuestionMultipleViewModel multipleChoicesQuestion;
  final ConsultationQuestionResponses? previousSelectedResponses;
  final int totalQuestions;
  final Function(String, List<String>) onMultipleResponseTap;
  final VoidCallback onBackTap;

  ConsultationQuestionMultipleChoicesView({
    Key? key,
    required this.multipleChoicesQuestion,
    required this.totalQuestions,
    required this.previousSelectedResponses,
    required this.onMultipleResponseTap,
    required this.onBackTap,
  }) : super(key: key);

  @override
  State<ConsultationQuestionMultipleChoicesView> createState() => _ConsultationQuestionMultipleChoicesViewState();
}

class _ConsultationQuestionMultipleChoicesViewState extends State<ConsultationQuestionMultipleChoicesView> {
  final List<String> currentResponseIds = [];
  bool shouldResetPreviousResponses = true;
  late ConsultationQuestionMultipleViewModel multipleChoicesQuestion;

  @override
  Widget build(BuildContext context) {
    multipleChoicesQuestion = widget.multipleChoicesQuestion;
    _resetPreviousResponses();
    return ConsultationQuestionView(
      order: multipleChoicesQuestion.order,
      totalQuestions: widget.totalQuestions,
      questionProgress: multipleChoicesQuestion.questionProgress,
      title: multipleChoicesQuestion.title,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: _buildMultipleChoiceResponse() +
            ConsultationQuestionHelper.buildBackButton(
              order: multipleChoicesQuestion.order,
              onBackTap: widget.onBackTap,
            ),
      ),
    );
  }

  void _resetPreviousResponses() {
    if (shouldResetPreviousResponses) {
      currentResponseIds.clear();
      final previousSelectedResponses = widget.previousSelectedResponses;
      if (previousSelectedResponses != null) {
        currentResponseIds.addAll(previousSelectedResponses.responseIds);
      }
      shouldResetPreviousResponses = false;
    }
  }

  List<Widget> _buildMultipleChoiceResponse() {
    final List<Widget> responseWidgets = [
      Text(
        ConsultationStrings.maxChoices.format(multipleChoicesQuestion.maxChoices.toString()),
        style: AgoraTextStyles.medium14,
      ),
      SizedBox(height: AgoraSpacings.base),
    ];
    for (final response in multipleChoicesQuestion.responseChoicesViewModels) {
      responseWidgets.add(
        AgoraQuestionResponseChoiceView(
          responseId: response.id,
          response: response.label,
          isSelected: _isResponseAlreadySelected(response.id),
          onTap: (responseId) {
            setState(() {
              if (currentResponseIds.contains(responseId)) {
                currentResponseIds.remove(responseId);
              } else if (currentResponseIds.length < multipleChoicesQuestion.maxChoices) {
                currentResponseIds.add(responseId);
              }
            });
          },
        ),
      );
      responseWidgets.add(SizedBox(height: AgoraSpacings.base));
    }

    responseWidgets.add(
      AgoraButton(
        label: ConsultationQuestionHelper.buildNextButtonLabel(
          order: multipleChoicesQuestion.order,
          totalQuestions: widget.totalQuestions,
        ),
        style: AgoraButtonStyle.primaryButtonStyle,
        onPressed: () {
          if (currentResponseIds.isNotEmpty) {
            widget.onMultipleResponseTap(multipleChoicesQuestion.id, [...currentResponseIds]);
            shouldResetPreviousResponses = true;
          }
        },
      ),
    );
    return responseWidgets;
  }

  bool _isResponseAlreadySelected(String responseId) {
    return currentResponseIds.contains(responseId);
  }
}
