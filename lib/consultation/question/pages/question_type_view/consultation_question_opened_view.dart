import 'package:agora/consultation/question/bloc/consultation_questions_view_model.dart';
import 'package:agora/common/extension/string_extension.dart';
import 'package:agora/common/strings/consultation_strings.dart';
import 'package:agora/design/custom_view/text/agora_text_field.dart';
import 'package:agora/design/style/agora_spacings.dart';
import 'package:agora/design/style/agora_text_styles.dart';
import 'package:agora/consultation/question/domain/consultation_question_response.dart';
import 'package:agora/common/parser/string_parser.dart';
import 'package:agora/consultation/question/pages/consultation_question_helper.dart';
import 'package:agora/consultation/question/pages/question_type_view/consultation_question_view.dart';
import 'package:flutter/material.dart';

class ConsultationQuestionOpenedView extends StatefulWidget {
  final ConsultationQuestionOpenedViewModel openedQuestion;
  final ConsultationQuestionResponses? previousResponses;
  final int totalQuestions;
  final int currentQuestionIndex;
  final Function(String questionId, String response) onOpenedResponseInput;
  final VoidCallback onBackTap;

  ConsultationQuestionOpenedView({
    super.key,
    required this.openedQuestion,
    required this.previousResponses,
    required this.totalQuestions,
    required this.currentQuestionIndex,
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
      currentQuestionIndex: widget.currentQuestionIndex,
      isLastQuestion: openedQuestion.nextQuestionId == null,
      title: openedQuestion.title,
      popupDescription: openedQuestion.popupDescription,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ..._buildOpenedChoiceResponse(openedQuestion.title),
          SizedBox(height: AgoraSpacings.base),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisSize: MainAxisSize.max,
            children: [
              ConsultationQuestionHelper.buildBackButton(
                order: openedQuestion.order,
                onBackTap: widget.onBackTap,
              ),
              const SizedBox(width: AgoraSpacings.base),
              openedResponse.isNotBlank()
                  ? Flexible(
                      child: ConsultationQuestionHelper.buildNextQuestion(
                        isLastQuestion: openedQuestion.nextQuestionId == null,
                        onPressed: () => widget.onOpenedResponseInput(openedQuestion.id, openedResponse),
                      ),
                    )
                  : Flexible(
                      child: ConsultationQuestionHelper.buildIgnoreButton(
                        onPressed: () => widget.onOpenedResponseInput(openedQuestion.id, ""),
                      ),
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

  List<Widget> _buildOpenedChoiceResponse(List<StringSegment> title) {
    final semanticTitle = title.where((segment) => !segment.isEmoji).map((seg) => seg.text).join();
    return [
      Text(ConsultationStrings.openedQuestionNotice, style: AgoraTextStyles.medium14),
      SizedBox(height: AgoraSpacings.base),
      AgoraTextField(
        hintText: ConsultationStrings.hintText,
        controller: textEditingController,
        contentDescription: semanticTitle,
        showCounterText: true,
        blockToMaxLength: true,
        onChanged: (openedResponseInput) {
          setState(() => openedResponse = openedResponseInput);
        },
      ),
    ];
  }
}
