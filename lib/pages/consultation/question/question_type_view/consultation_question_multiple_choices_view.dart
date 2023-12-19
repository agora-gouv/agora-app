import 'package:agora/bloc/consultation/question/consultation_questions_view_model.dart';
import 'package:agora/common/extension/string_extension.dart';
import 'package:agora/common/strings/consultation_strings.dart';
import 'package:agora/common/strings/semantics_strings.dart';
import 'package:agora/common/uuid/uuid_utils.dart';
import 'package:agora/design/custom_view/agora_question_response_choice_view.dart';
import 'package:agora/design/style/agora_spacings.dart';
import 'package:agora/design/style/agora_text_styles.dart';
import 'package:agora/domain/consultation/questions/responses/consultation_question_response.dart';
import 'package:agora/pages/consultation/question/consultation_question_helper.dart';
import 'package:agora/pages/consultation/question/question_type_view/consultation_question_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';

class ConsultationQuestionMultipleChoicesView extends StatefulWidget {
  final ConsultationQuestionMultipleViewModel multipleChoicesQuestion;
  final ConsultationQuestionResponses? previousSelectedResponses;
  final int totalQuestions;
  final Function(String questionId, List<String> responseIds, String otherResponse) onMultipleResponseTap;
  final VoidCallback onBackTap;

  ConsultationQuestionMultipleChoicesView({
    super.key,
    required this.multipleChoicesQuestion,
    required this.totalQuestions,
    required this.previousSelectedResponses,
    required this.onMultipleResponseTap,
    required this.onBackTap,
  });

  @override
  State<ConsultationQuestionMultipleChoicesView> createState() => _ConsultationQuestionMultipleChoicesViewState();
}

class _ConsultationQuestionMultipleChoicesViewState extends State<ConsultationQuestionMultipleChoicesView> {
  String currentQuestionId = "";
  final List<String> currentResponseIds = [];
  String otherResponseText = "";
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
      questionProgressSemanticLabel: multipleChoicesQuestion.questionProgressSemanticLabel,
      title: multipleChoicesQuestion.title,
      popupDescription: multipleChoicesQuestion.popupDescription,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ..._buildMultipleChoiceResponse(),
          SizedBox(height: AgoraSpacings.base),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ConsultationQuestionHelper.buildBackButton(
                order: multipleChoicesQuestion.order,
                onBackTap: widget.onBackTap,
              ),
              currentResponseIds.isNotEmpty
                  ? ConsultationQuestionHelper.buildNextQuestion(
                      order: multipleChoicesQuestion.order,
                      totalQuestions: widget.totalQuestions,
                      onPressed: () {
                        widget.onMultipleResponseTap(
                          multipleChoicesQuestion.id,
                          [...currentResponseIds],
                          otherResponseText,
                        );
                      },
                    )
                  : ConsultationQuestionHelper.buildIgnoreButton(
                      onPressed: () => widget.onMultipleResponseTap(
                        multipleChoicesQuestion.id,
                        [UuidUtils.uuidZero],
                        "",
                      ),
                    ),
            ],
          ),
        ],
      ),
    );
  }

  void _resetPreviousResponses() {
    if (currentQuestionId != widget.multipleChoicesQuestion.id) {
      currentQuestionId = widget.multipleChoicesQuestion.id;
      shouldResetPreviousResponses = true;
    }
    if (shouldResetPreviousResponses) {
      currentResponseIds.clear();
      otherResponseText = "";
      final previousSelectedResponses = widget.previousSelectedResponses;
      if (previousSelectedResponses != null && !previousSelectedResponses.responseIds.contains(UuidUtils.uuidZero)) {
        currentResponseIds.addAll(previousSelectedResponses.responseIds);
        otherResponseText = previousSelectedResponses.responseText;
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

    final responseChoicesViewModels = multipleChoicesQuestion.responseChoicesViewModels;
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
            setState(() {
              if (currentResponseIds.contains(responseId)) {
                currentResponseIds.remove(responseId);
                otherResponseText = "";
              } else {
                if (currentResponseIds.length < multipleChoicesQuestion.maxChoices) {
                  currentResponseIds.add(responseId);
                } else {
                  SemanticsService.announce(SemanticsStrings.maxChoiceAttempt, TextDirection.ltr);
                }
              }
            });
          },
          onOtherResponseChanged: (responseId, otherResponse) {
            if (currentResponseIds.contains(responseId)) {
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

  bool _isResponseAlreadySelected(String responseId) {
    return currentResponseIds.contains(responseId);
  }
}
