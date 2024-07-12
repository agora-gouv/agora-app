import 'package:agora/consultation/bloc/question/consultation_questions_view_model.dart';
import 'package:agora/common/extension/string_extension.dart';
import 'package:agora/common/strings/consultation_strings.dart';
import 'package:agora/common/uuid/uuid_utils.dart';
import 'package:agora/design/custom_view/agora_question_response_choice_view.dart';
import 'package:agora/design/style/agora_spacings.dart';
import 'package:agora/design/style/agora_text_styles.dart';
import 'package:agora/consultation/domain/questions/responses/consultation_question_response.dart';
import 'package:agora/consultation/pages/question/consultation_question_helper.dart';
import 'package:agora/consultation/pages/question/question_type_view/consultation_question_view.dart';
import 'package:flutter/material.dart';

class ConsultationQuestionWithConditionsView extends StatefulWidget {
  final ConsultationQuestionWithConditionViewModel questionWithConditions;
  final ConsultationQuestionResponses? previousSelectedResponses;
  final int totalQuestions;
  final int currentQuestionIndex;
  final Function(
    String questionId,
    String responseId,
    String otherResponse,
    String nextQuestionId,
  ) onWithConditionResponseTap;
  final VoidCallback onBackTap;

  ConsultationQuestionWithConditionsView({
    super.key,
    required this.questionWithConditions,
    required this.previousSelectedResponses,
    required this.totalQuestions,
    required this.currentQuestionIndex,
    required this.onWithConditionResponseTap,
    required this.onBackTap,
  });

  @override
  State<ConsultationQuestionWithConditionsView> createState() => _ConsultationQuestionWithConditionsViewState();
}

class _ConsultationQuestionWithConditionsViewState extends State<ConsultationQuestionWithConditionsView> {
  String currentQuestionId = "";
  String currentResponseId = "";
  String otherResponseText = "";
  String currentNextQuestionId = "";
  bool shouldResetPreviousResponses = true;

  @override
  Widget build(BuildContext context) {
    _resetPreviousResponses();
    return ConsultationQuestionView(
      order: widget.questionWithConditions.order,
      currentQuestionIndex: widget.currentQuestionIndex,
      totalQuestions: widget.totalQuestions,
      isLastQuestion: false,
      title: widget.questionWithConditions.title,
      popupDescription: widget.questionWithConditions.popupDescription,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ..._buildWithConditionsResponse(),
          SizedBox(height: AgoraSpacings.base),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisSize: MainAxisSize.max,
            children: [
              ConsultationQuestionHelper.buildBackButton(
                order: widget.questionWithConditions.order,
                onBackTap: widget.onBackTap,
              ),
              const SizedBox(width: AgoraSpacings.base),
              if (currentResponseId.isNotBlank())
                Flexible(
                  child: ConsultationQuestionHelper.buildNextQuestion(
                    isLastQuestion: false,
                    onPressed: () => widget.onWithConditionResponseTap(
                      widget.questionWithConditions.id,
                      currentResponseId,
                      otherResponseText,
                      currentNextQuestionId,
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  List<Widget> _buildWithConditionsResponse() {
    final List<Widget> responseWidgets = [
      Text(ConsultationStrings.withCondition, style: AgoraTextStyles.medium14),
      SizedBox(height: AgoraSpacings.base),
    ];
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
            if (currentResponseId == response.id) {
              setState(() => currentResponseId = "");
            } else {
              setState(() {
                currentResponseId = responseId;
                currentNextQuestionId = response.nextQuestionId;
              });
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
        }
      }
      shouldResetPreviousResponses = false;
    }
  }

  bool _isResponseAlreadySelected(String responseId) {
    return currentResponseId == responseId;
  }
}
