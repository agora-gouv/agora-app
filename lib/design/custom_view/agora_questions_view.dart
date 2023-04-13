import 'package:agora/bloc/consultation/question/consultation_questions_view_model.dart';
import 'package:agora/common/extension/string_extension.dart';
import 'package:agora/common/strings/consultation_strings.dart';
import 'package:agora/design/agora_button.dart';
import 'package:agora/design/agora_button_style.dart';
import 'package:agora/design/agora_colors.dart';
import 'package:agora/design/agora_spacings.dart';
import 'package:agora/design/agora_text_styles.dart';
import 'package:agora/design/custom_view/agora_question_response_choice_view.dart';
import 'package:agora/design/custom_view/agora_questions_progress_bar.dart';
import 'package:agora/design/custom_view/agora_single_scroll_view.dart';
import 'package:agora/domain/consultation/questions/consultation_question_type.dart';
import 'package:agora/domain/consultation/questions/responses/consultation_question_response.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AgoraQuestionsView extends StatefulWidget {
  final String questionId;
  final String questionText;
  final int currentQuestionOrder;
  final ConsultationQuestionType currentQuestionType;
  final int totalQuestions;
  final int maxChoices;
  final List<ConsultationQuestionResponseChoiceViewModel> responses;
  final ConsultationQuestionResponses? previousSelectedResponses;
  final Function(String, String) onUniqueResponseTap;
  final Function(String, String) onOpenedResponseInput;
  final Function(String, List<String>) onMultipleResponseTap;
  final VoidCallback onBackTap;

  AgoraQuestionsView({
    Key? key,
    required this.questionId,
    required this.questionText,
    required this.currentQuestionOrder,
    required this.currentQuestionType,
    required this.totalQuestions,
    required this.maxChoices,
    required this.responses,
    required this.previousSelectedResponses,
    required this.onUniqueResponseTap,
    required this.onOpenedResponseInput,
    required this.onMultipleResponseTap,
    required this.onBackTap,
  }) : super(key: key);

  @override
  State<AgoraQuestionsView> createState() => _AgoraQuestionsViewState();
}

class _AgoraQuestionsViewState extends State<AgoraQuestionsView> {
  String openedResponse = "";
  final List<String> currentResponseIds = [];
  bool shouldResetPreviousResponses = true;

  @override
  Widget build(BuildContext context) {
    _resetPreviousResponses();
    return AgoraSingleScrollView(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(
              vertical: AgoraSpacings.x0_75,
              horizontal: AgoraSpacings.horizontalPadding,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AgoraQuestionsProgressBar(
                  currentQuestion: widget.currentQuestionOrder,
                  totalQuestions: widget.totalQuestions,
                ),
                SizedBox(height: AgoraSpacings.x0_75),
                Text(
                  ConsultationStrings.question
                      .format2(widget.currentQuestionOrder.toString(), widget.totalQuestions.toString()),
                  style: AgoraTextStyles.medium16,
                ),
                SizedBox(height: AgoraSpacings.base),
                Text(
                  widget.questionText,
                  style: AgoraTextStyles.medium20.copyWith(color: AgoraColors.primaryGreen),
                ),
              ],
            ),
          ),
          Flexible(
            child: Container(
              width: double.infinity,
              color: AgoraColors.background,
              child: Padding(
                padding: const EdgeInsets.all(AgoraSpacings.horizontalPadding),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: _buildTypeChoiceResponse() + _buildBackButton(),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _resetPreviousResponses() {
    if (shouldResetPreviousResponses) {
      openedResponse = "";
      currentResponseIds.clear();
      final previousSelectedResponses = widget.previousSelectedResponses;
      if (previousSelectedResponses != null) {
        openedResponse = previousSelectedResponses.responseText;
        currentResponseIds.addAll(previousSelectedResponses.responseIds);
      }
      shouldResetPreviousResponses = false;
    }
  }

  List<Widget> _buildTypeChoiceResponse() {
    switch (widget.currentQuestionType) {
      case ConsultationQuestionType.unique:
        return _buildUniqueChoiceResponse();
      case ConsultationQuestionType.ouverte:
        return _buildOpenedChoiceResponse();
      case ConsultationQuestionType.multiple:
        return _buildMultipleChoiceResponse();
    }
  }

  List<Widget> _buildUniqueChoiceResponse() {
    final List<Widget> responseWidgets = [];
    for (final response in widget.responses) {
      responseWidgets.add(
        AgoraQuestionResponseChoiceView(
          responseId: response.id,
          response: response.label,
          isSelected: _isResponseAlreadySelected(response.id),
          onTap: (responseId) {
            widget.onUniqueResponseTap(widget.questionId, responseId);
            shouldResetPreviousResponses = true;
          },
        ),
      );
      responseWidgets.add(SizedBox(height: AgoraSpacings.base));
    }
    return responseWidgets;
  }

  List<Widget> _buildOpenedChoiceResponse() {
    final previousResponseText = widget.previousSelectedResponses?.responseText;
    return [
      Text(ConsultationStrings.openedQuestionNotice, style: AgoraTextStyles.medium14),
      SizedBox(height: AgoraSpacings.base),
      SizedBox(
        width: double.infinity,
        height: 200,
        child: TextField(
          minLines: 1,
          maxLines: 20,
          scrollPadding: const EdgeInsets.only(bottom: AgoraSpacings.x3),
          maxLength: 400,
          keyboardType: TextInputType.multiline,
          style: AgoraTextStyles.light14,
          controller: previousResponseText != null ? TextEditingController(text: previousResponseText) : null,
          decoration: InputDecoration(
            isDense: true,
            contentPadding: EdgeInsets.all(AgoraSpacings.base),
            filled: true,
            fillColor: AgoraColors.white,
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(4)),
              borderSide: BorderSide(width: 1, color: AgoraColors.border),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(width: 1, color: AgoraColors.primaryGreen),
            ),
            hintText: ConsultationStrings.hintText,
            hintStyle: AgoraTextStyles.light14.copyWith(color: AgoraColors.orochimaru),
          ),
          onChanged: (openedResponseInput) {
            openedResponse = openedResponseInput;
          },
        ),
      ),
      SizedBox(height: AgoraSpacings.base),
      AgoraButton(
        label: _buildNextButtonLabel(),
        style: AgoraButtonStyle.primaryButtonStyle,
        onPressed: () {
          widget.onOpenedResponseInput(widget.questionId, openedResponse);
          shouldResetPreviousResponses = true;
        },
      ),
    ];
  }

  List<Widget> _buildMultipleChoiceResponse() {
    final List<Widget> responseWidgets = [
      Text(
        ConsultationStrings.maxChoices.format(widget.maxChoices.toString()),
        style: AgoraTextStyles.medium14,
      ),
      SizedBox(height: AgoraSpacings.base),
    ];
    for (final response in widget.responses) {
      responseWidgets.add(
        AgoraQuestionResponseChoiceView(
          responseId: response.id,
          response: response.label,
          isSelected: _isResponseAlreadySelected(response.id),
          onTap: (responseId) {
            setState(() {
              if (currentResponseIds.contains(responseId)) {
                currentResponseIds.remove(responseId);
              } else if (currentResponseIds.length < widget.maxChoices) {
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
        label: _buildNextButtonLabel(),
        style: AgoraButtonStyle.primaryButtonStyle,
        onPressed: () {
          if (currentResponseIds.isNotEmpty) {
            widget.onMultipleResponseTap(widget.questionId, [...currentResponseIds]);
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

  String _buildNextButtonLabel() {
    return widget.currentQuestionOrder == widget.totalQuestions
        ? ConsultationStrings.validate
        : ConsultationStrings.nextQuestion;
  }

  List<Widget> _buildBackButton() {
    if (widget.currentQuestionOrder != 1) {
      return [
        SizedBox(height: AgoraSpacings.x1_5),
        InkWell(
          onTap: () {
            widget.onBackTap();
            shouldResetPreviousResponses = true;
          },
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
