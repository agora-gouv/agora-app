import 'package:agora/bloc/consultation/question/consultation_questions_view_model.dart';
import 'package:agora/common/extension/string_extension.dart';
import 'package:agora/common/strings/consultation_strings.dart';
import 'package:agora/design/custom_view/agora_text_field.dart';
import 'package:agora/design/style/agora_spacings.dart';
import 'package:agora/design/style/agora_text_styles.dart';
import 'package:agora/domain/consultation/questions/responses/consultation_question_response.dart';
import 'package:agora/pages/consultation/question/consultation_question_helper.dart';
import 'package:agora/pages/consultation/question/question_type_view/consultation_question_view.dart';
import 'package:flutter/material.dart';

class ConsultationQuestionOpenedView extends StatefulWidget {
  final ConsultationQuestionOpenedViewModel openedQuestion;
  final ConsultationQuestionResponses? previousResponses;
  final int totalQuestions;
  final Function(String questionId, String response) onOpenedResponseInput;
  final VoidCallback onBackTap;

  ConsultationQuestionOpenedView({
    super.key,
    required this.openedQuestion,
    required this.previousResponses,
    required this.totalQuestions,
    required this.onOpenedResponseInput,
    required this.onBackTap,
  });

  @override
  State<ConsultationQuestionOpenedView> createState() => _ConsultationQuestionOpenedViewState();
}

class _ConsultationQuestionOpenedViewState extends State<ConsultationQuestionOpenedView> {
  String currentQuestionId = "";
  String openedResponse = "";
  bool shouldResetPreviousResponses = true;
  late ConsultationQuestionOpenedViewModel openedQuestion;
  late TextEditingController textEditingController;

  @override
  Widget build(BuildContext context) {
    openedQuestion = widget.openedQuestion;
    _resetPreviousResponses();
    return ConsultationQuestionView(
      order: openedQuestion.order,
      totalQuestions: widget.totalQuestions,
      questionProgress: openedQuestion.questionProgress,
      questionProgressSemanticLabel: openedQuestion.questionProgressSemanticLabel,
      title: openedQuestion.title,
      popupDescription: openedQuestion.popupDescription,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ..._buildOpenedChoiceResponse(),
          SizedBox(height: AgoraSpacings.base),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ConsultationQuestionHelper.buildBackButton(
                order: openedQuestion.order,
                onBackTap: widget.onBackTap,
              ),
              openedResponse.isNotBlank()
                  ? ConsultationQuestionHelper.buildNextQuestion(
                      order: openedQuestion.order,
                      totalQuestions: widget.totalQuestions,
                      onPressed: () => widget.onOpenedResponseInput(openedQuestion.id, openedResponse),
                    )
                  : ConsultationQuestionHelper.buildIgnoreButton(
                      onPressed: () => widget.onOpenedResponseInput(openedQuestion.id, ""),
                    ),
            ],
          ),
        ],
      ),
    );
  }

  void _resetPreviousResponses() {
    if (currentQuestionId != widget.openedQuestion.id) {
      currentQuestionId = widget.openedQuestion.id;
      shouldResetPreviousResponses = true;
    }
    if (shouldResetPreviousResponses) {
      openedResponse = "";
      final previousSelectedResponses = widget.previousResponses;
      if (previousSelectedResponses != null) {
        openedResponse = previousSelectedResponses.responseText;
      }
      textEditingController = TextEditingController(text: openedResponse);
      shouldResetPreviousResponses = false;
    }
  }

  List<Widget> _buildOpenedChoiceResponse() {
    return [
      Text(ConsultationStrings.openedQuestionNotice, style: AgoraTextStyles.medium14),
      SizedBox(height: AgoraSpacings.base),
      AgoraTextField(
        hintText: ConsultationStrings.hintText,
        controller: textEditingController,
        showCounterText: true,
        blockToMaxLength: true,
        onChanged: (openedResponseInput) {
          setState(() => openedResponse = openedResponseInput);
        },
      ),
    ];
  }
}
