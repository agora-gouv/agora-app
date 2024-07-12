import 'package:agora/consultation/question/bloc/consultation_questions_view_model.dart';
import 'package:agora/common/extension/string_extension.dart';
import 'package:agora/common/uuid/uuid_utils.dart';
import 'package:agora/design/custom_view/agora_question_response_choice_view.dart';
import 'package:agora/design/style/agora_spacings.dart';
import 'package:agora/consultation/question/domain/consultation_question_response.dart';
import 'package:agora/consultation/question/pages/consultation_question_helper.dart';
import 'package:agora/consultation/question/pages/question_type_view/consultation_question_view.dart';
import 'package:flutter/material.dart';

class ConsultationQuestionUniqueChoiceView extends StatefulWidget {
  final ConsultationQuestionUniqueViewModel uniqueChoiceQuestion;
  final ConsultationQuestionResponses? previousSelectedResponses;
  final int totalQuestions;
  final int currentQuestionIndex;
  final Function(String questionId, String responseId, String otherResponse) onUniqueResponseTap;
  final VoidCallback onBackTap;

  ConsultationQuestionUniqueChoiceView({
    super.key,
    required this.uniqueChoiceQuestion,
    required this.previousSelectedResponses,
    required this.totalQuestions,
    required this.currentQuestionIndex,
    required this.onUniqueResponseTap,
    required this.onBackTap,
  });

  @override
  State<ConsultationQuestionUniqueChoiceView> createState() => _ConsultationQuestionUniqueChoiceViewState();
}

class _ConsultationQuestionUniqueChoiceViewState extends State<ConsultationQuestionUniqueChoiceView> {
  String currentQuestionId = "";
  String currentResponseId = "";
  String otherResponseText = "";
  bool shouldResetPreviousResponses = true;

  @override
  Widget build(BuildContext context) {
    _resetPreviousResponses();
    return ConsultationQuestionView(
      order: widget.uniqueChoiceQuestion.order,
      totalQuestions: widget.totalQuestions,
      currentQuestionIndex: widget.currentQuestionIndex,
      isLastQuestion: widget.uniqueChoiceQuestion.nextQuestionId == null,
      title: widget.uniqueChoiceQuestion.title,
      popupDescription: widget.uniqueChoiceQuestion.popupDescription,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ..._buildUniqueChoiceResponse(),
          SizedBox(height: AgoraSpacings.base),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisSize: MainAxisSize.max,
            children: [
              ConsultationQuestionHelper.buildBackButton(
                order: widget.uniqueChoiceQuestion.order,
                onBackTap: widget.onBackTap,
              ),
              const SizedBox(width: AgoraSpacings.base),
              currentResponseId.isNotBlank()
                  ? Flexible(
                      child: ConsultationQuestionHelper.buildNextQuestion(
                        isLastQuestion: widget.uniqueChoiceQuestion.nextQuestionId == null,
                        onPressed: () => widget.onUniqueResponseTap(
                          widget.uniqueChoiceQuestion.id,
                          currentResponseId,
                          otherResponseText,
                        ),
                      ),
                    )
                  : Flexible(
                      child: ConsultationQuestionHelper.buildIgnoreButton(
                        onPressed: () {
                          widget.onUniqueResponseTap(widget.uniqueChoiceQuestion.id, UuidUtils.uuidZero, "");
                        },
                      ),
                    ),
            ],
          ),
        ],
      ),
    );
  }

  List<Widget> _buildUniqueChoiceResponse() {
    final List<Widget> responseWidgets = [];
    final responseChoicesViewModels = widget.uniqueChoiceQuestion.responseChoicesViewModels;
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
              setState(() => currentResponseId = responseId);
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
    if (currentQuestionId != widget.uniqueChoiceQuestion.id) {
      currentQuestionId = widget.uniqueChoiceQuestion.id;
      shouldResetPreviousResponses = true;
    }
    if (shouldResetPreviousResponses) {
      currentResponseId = "";
      otherResponseText = "";
      final previousSelectedResponses = widget.previousSelectedResponses;
      if (previousSelectedResponses != null) {
        final previousResponseIds = previousSelectedResponses.responseIds;
        if (!previousResponseIds.contains(UuidUtils.uuidZero) && previousResponseIds.isNotEmpty) {
          currentResponseId = previousResponseIds[0];
          otherResponseText = previousSelectedResponses.responseText;
        }
      }
      shouldResetPreviousResponses = false;
    }
  }

  bool _isResponseAlreadySelected(String responseId) {
    return currentResponseId == responseId;
  }
}
