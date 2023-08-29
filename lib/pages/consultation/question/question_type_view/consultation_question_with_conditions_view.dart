import 'package:agora/bloc/consultation/question/consultation_questions_view_model.dart';
import 'package:agora/common/extension/string_extension.dart';
import 'package:agora/common/uuid/uuid_utils.dart';
import 'package:agora/design/custom_view/agora_question_response_choice_view.dart';
import 'package:agora/design/custom_view/button/agora_button.dart';
import 'package:agora/design/style/agora_button_style.dart';
import 'package:agora/design/style/agora_spacings.dart';
import 'package:agora/domain/consultation/questions/responses/consultation_question_response.dart';
import 'package:agora/pages/consultation/question/consultation_question_helper.dart';
import 'package:agora/pages/consultation/question/question_type_view/consultation_question_view.dart';
import 'package:flutter/material.dart';

class ConsultationQuestionWithConditionsView extends StatefulWidget {
  final ConsultationQuestionWithConditionViewModel questionWithConditions;
  final ConsultationQuestionResponses? previousSelectedResponses;
  final int totalQuestions;
  final Function(
    String questionId,
    String responseId,
    String otherResponse,
    String nextQuestionId,
  ) onWithConditionResponseTap;
  final VoidCallback onBackTap;

  ConsultationQuestionWithConditionsView({
    Key? key,
    required this.questionWithConditions,
    required this.previousSelectedResponses,
    required this.totalQuestions,
    required this.onWithConditionResponseTap,
    required this.onBackTap,
  }) : super(key: key);

  @override
  State<ConsultationQuestionWithConditionsView> createState() => _ConsultationQuestionWithConditionsViewState();
}

class _ConsultationQuestionWithConditionsViewState extends State<ConsultationQuestionWithConditionsView> {
  String currentQuestionId = "";
  String currentResponseId = "";
  String otherResponseText = "";
  String currentNextQuestionId = "";
  bool showNextButton = false;
  bool shouldResetPreviousResponses = true;

  @override
  Widget build(BuildContext context) {
    _resetPreviousResponses();
    return ConsultationQuestionView(
      order: widget.questionWithConditions.order,
      totalQuestions: widget.totalQuestions,
      questionProgress: widget.questionWithConditions.questionProgress,
      questionProgressSemanticLabel: widget.questionWithConditions.questionProgressSemanticLabel,
      title: widget.questionWithConditions.title,
      popupDescription: widget.questionWithConditions.popupDescription,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ..._buildWithConditionsResponse(),
          if (showNextButton)
            AgoraButton(
              label: ConsultationQuestionHelper.buildNextButtonLabel(
                order: widget.questionWithConditions.order,
                totalQuestions: widget.totalQuestions,
              ),
              style: AgoraButtonStyle.primaryButtonStyle,
              onPressed: currentResponseId.isNotBlank() && otherResponseText.isNotBlank()
                  ? () => widget.onWithConditionResponseTap(
                        widget.questionWithConditions.id,
                        currentResponseId,
                        otherResponseText,
                        currentNextQuestionId,
                      )
                  : null,
            ),
          ...ConsultationQuestionHelper.buildBackButton(
            order: widget.questionWithConditions.order,
            onBackTap: widget.onBackTap,
          ),
        ],
      ),
    );
  }

  List<Widget> _buildWithConditionsResponse() {
    final List<Widget> responseWidgets = [];
    final responseChoicesViewModels = widget.questionWithConditions.responseChoicesViewModels;
    final totalLength = responseChoicesViewModels.length;
    for (var index = 0; index < totalLength; index++) {
      final response = responseChoicesViewModels[index];
      responseWidgets.add(
        AgoraQuestionResponseChoiceView(
          responseId: response.id,
          responseLabel: response.label,
          hasOpenTextField: response.hasOpenTextField,
          isSelected: _isResponseAlreadySelected(response.id),
          previousOtherResponse: otherResponseText,
          semantic: AgoraQuestionResponseChoiceSemantic(currentIndex: index + 1, totalIndex: totalLength),
          onTap: (responseId) {
            currentResponseId = responseId;
            currentNextQuestionId = response.nextQuestionId;
            if (response.hasOpenTextField) {
              setState(() => showNextButton = true);
            } else {
              widget.onWithConditionResponseTap(
                widget.questionWithConditions.id,
                responseId,
                otherResponseText,
                currentNextQuestionId,
              );
            }
          },
          onOtherResponseChanged: (responseId, otherResponse) {
            if (currentResponseId == responseId) {
              setState(() => otherResponseText = otherResponse);
            } else {
              setState(() => otherResponseText = "");
            }
          },
        ),
      );
      responseWidgets.add(SizedBox(height: AgoraSpacings.base));
    }
    return responseWidgets;
  }

  void _resetPreviousResponses() {
    if (currentQuestionId != widget.questionWithConditions.id) {
      currentQuestionId = widget.questionWithConditions.id;
      shouldResetPreviousResponses = true;
    }
    if (shouldResetPreviousResponses) {
      currentResponseId = "";
      otherResponseText = "";
      currentNextQuestionId = "";
      final previousSelectedResponses = widget.previousSelectedResponses;
      if (previousSelectedResponses != null) {
        final previousResponseIds = previousSelectedResponses.responseIds;
        if (!previousResponseIds.contains(UuidUtils.uuidZero) && previousResponseIds.isNotEmpty) {
          currentResponseId = previousResponseIds[0];
          otherResponseText = previousSelectedResponses.responseText;
          currentNextQuestionId = widget.questionWithConditions.responseChoicesViewModels
              .firstWhere((element) => element.id == currentResponseId)
              .nextQuestionId;
          if (otherResponseText.isNotBlank()) {
            showNextButton = true;
          }
        }
      }
      shouldResetPreviousResponses = false;
    }
  }

  bool _isResponseAlreadySelected(String responseId) {
    return currentResponseId == responseId;
  }
}
