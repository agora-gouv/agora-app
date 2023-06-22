import 'package:agora/bloc/consultation/question/consultation_questions_bloc.dart';
import 'package:agora/bloc/consultation/question/consultation_questions_event.dart';
import 'package:agora/bloc/consultation/question/consultation_questions_state.dart';
import 'package:agora/bloc/consultation/question/consultation_questions_view_model.dart';
import 'package:agora/bloc/consultation/question/response/stock/consultation_questions_responses_stock_bloc.dart';
import 'package:agora/bloc/consultation/question/response/stock/consultation_questions_responses_stock_event.dart';
import 'package:agora/bloc/consultation/question/response/stock/consultation_questions_responses_stock_state.dart';
import 'package:agora/common/analytics/analytics_event_names.dart';
import 'package:agora/common/analytics/analytics_screen_names.dart';
import 'package:agora/common/extension/string_extension.dart';
import 'package:agora/common/helper/tracker_helper.dart';
import 'package:agora/common/manager/repository_manager.dart';
import 'package:agora/design/custom_view/agora_error_view.dart';
import 'package:agora/design/custom_view/agora_scaffold.dart';
import 'package:agora/design/custom_view/agora_toolbar.dart';
import 'package:agora/domain/consultation/questions/responses/consultation_question_response.dart';
import 'package:agora/pages/consultation/question/consultation_question_confirmation_page.dart';
import 'package:agora/pages/consultation/question/question_type_view/consultation_question_chapter_view.dart';
import 'package:agora/pages/consultation/question/question_type_view/consultation_question_multiple_choices_view.dart';
import 'package:agora/pages/consultation/question/question_type_view/consultation_question_opened_view.dart';
import 'package:agora/pages/consultation/question/question_type_view/consultation_question_unique_choice_view.dart';
import 'package:agora/pages/consultation/question/question_type_view/consultation_question_with_conditions_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ConsultationQuestionPage extends StatefulWidget {
  static const routeName = "/consultationQuestionPage";

  final String consultationId;

  const ConsultationQuestionPage({super.key, required this.consultationId});

  @override
  State<ConsultationQuestionPage> createState() => _ConsultationQuestionPageState();
}

class _ConsultationQuestionPageState extends State<ConsultationQuestionPage> {
  String? currentQuestionId;
  List<String> questionsStack = [];

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<ConsultationQuestionsBloc>(
          create: (BuildContext context) =>
              ConsultationQuestionsBloc(consultationRepository: RepositoryManager.getConsultationRepository())
                ..add(FetchConsultationQuestionsEvent(consultationId: widget.consultationId)),
        ),
        BlocProvider<ConsultationQuestionsResponsesStockBloc>(
          create: (BuildContext context) => ConsultationQuestionsResponsesStockBloc(),
        ),
      ],
      child: BlocBuilder<ConsultationQuestionsBloc, ConsultationQuestionsState>(
        builder: (context, questionsState) {
          if (questionsState is ConsultationQuestionsFetchedState) {
            return _handleQuestionsFetchedState(questionsState);
          } else if (questionsState is ConsultationQuestionsErrorState) {
            return AgoraScaffold(
              child: Column(
                children: [
                  AgoraToolbar(style: AgoraToolbarStyle.close),
                  SizedBox(height: MediaQuery.of(context).size.height / 10 * 4),
                  Center(child: AgoraErrorView()),
                ],
              ),
            );
          } else {
            return AgoraScaffold(
              child: Column(
                children: [
                  AgoraToolbar(style: AgoraToolbarStyle.close),
                  SizedBox(height: MediaQuery.of(context).size.height / 10 * 4),
                  Center(child: CircularProgressIndicator()),
                ],
              ),
            );
          }
        },
      ),
    );
  }

  Widget _handleQuestionsFetchedState(ConsultationQuestionsFetchedState questionsState) {
    return BlocBuilder<ConsultationQuestionsResponsesStockBloc, ConsultationQuestionsResponsesStockState>(
      builder: (context, responsesStockState) {
        currentQuestionId ??= questionsState.viewModels[0].id;
        questionsStack = responsesStockState.questionsStack;
        final currentQuestion = questionsState.viewModels.firstWhere((element) => element.id == currentQuestionId);
        final totalQuestions = questionsState.viewModels.length;
        final questionAlreadyAnswered = _getPreviousResponses(
          questionId: currentQuestion.id,
          inStockResponses: responsesStockState.questionsResponses,
        );
        return AgoraScaffold(
          popAction: () {
            try {
              final previousQuestion = questionsStack.last;
              _removeAndGoToPreviousQuestion(context, previousQuestion);
              return false;
            } catch (e) {
              Navigator.pop(context);
              return true;
            }
          },
          child: _buildContent(
            currentQuestion,
            totalQuestions,
            questionAlreadyAnswered,
            responsesStockState,
            context,
          ),
        );
      },
    );
  }

  Widget _buildContent(
    ConsultationQuestionViewModel currentQuestion,
    int totalQuestions,
    ConsultationQuestionResponses? questionAlreadyAnswered,
    ConsultationQuestionsResponsesStockState responsesStockState,
    BuildContext context,
  ) {
    if (currentQuestion is ConsultationQuestionUniqueViewModel) {
      return _handleQuestionUniqueChoice(
        widget.consultationId,
        currentQuestion,
        totalQuestions,
        questionAlreadyAnswered,
        responsesStockState,
        context,
      );
    } else if (currentQuestion is ConsultationQuestionMultipleViewModel) {
      return _handleQuestionMultipleChoices(
        widget.consultationId,
        currentQuestion,
        totalQuestions,
        questionAlreadyAnswered,
        responsesStockState,
        context,
      );
    } else if (currentQuestion is ConsultationQuestionOpenedViewModel) {
      return _handleQuestionOpened(
        widget.consultationId,
        currentQuestion,
        totalQuestions,
        questionAlreadyAnswered,
        responsesStockState,
        context,
      );
    }
    if (currentQuestion is ConsultationQuestionWithConditionViewModel) {
      return _handleQuestionWithConditions(
        widget.consultationId,
        currentQuestion,
        totalQuestions,
        questionAlreadyAnswered,
        responsesStockState,
        context,
      );
    } else if (currentQuestion is ConsultationQuestionChapterViewModel) {
      return _handleChapter(
        widget.consultationId,
        currentQuestion,
        totalQuestions,
        responsesStockState,
        context,
      );
    } else {
      return Container();
    }
  }

  ConsultationQuestionUniqueChoiceView _handleQuestionUniqueChoice(
    String consultationId,
    ConsultationQuestionUniqueViewModel uniqueChoiceQuestion,
    int totalQuestions,
    ConsultationQuestionResponses? questionAlreadyAnswered,
    ConsultationQuestionsResponsesStockState stockState,
    BuildContext context,
  ) {
    return ConsultationQuestionUniqueChoiceView(
      uniqueChoiceQuestion: uniqueChoiceQuestion,
      totalQuestions: totalQuestions,
      previousResponses: questionAlreadyAnswered,
      onUniqueResponseTap: (questionId, responseId) {
        TrackerHelper.trackClick(
          clickName: AnalyticsEventNames.answerConsultationQuestion.format(uniqueChoiceQuestion.questionProgress),
          widgetName: "${AnalyticsScreenNames.consultationQuestionPage} $consultationId",
        );
        _saveAndGoToNextQuestion(
          context: context,
          questionId: questionId,
          responsesIds: [responseId],
          openedResponse: "",
          nextQuestionId: uniqueChoiceQuestion.nextQuestionId,
        );
      },
      onBackTap: () {
        TrackerHelper.trackClick(
          clickName: AnalyticsEventNames.backConsultationQuestion.format(uniqueChoiceQuestion.questionProgress),
          widgetName: "${AnalyticsScreenNames.consultationQuestionPage} $consultationId",
        );
        _removeAndGoToPreviousQuestion(context, stockState.questionsStack.last);
      },
    );
  }

  ConsultationQuestionMultipleChoicesView _handleQuestionMultipleChoices(
    String consultationId,
    ConsultationQuestionMultipleViewModel multipleChoicesQuestion,
    int totalQuestions,
    ConsultationQuestionResponses? questionAlreadyAnswered,
    ConsultationQuestionsResponsesStockState stockState,
    BuildContext context,
  ) {
    return ConsultationQuestionMultipleChoicesView(
      multipleChoicesQuestion: multipleChoicesQuestion,
      totalQuestions: totalQuestions,
      previousSelectedResponses: questionAlreadyAnswered,
      onMultipleResponseTap: (questionId, responseIds) {
        TrackerHelper.trackClick(
          clickName: AnalyticsEventNames.answerConsultationQuestion.format(multipleChoicesQuestion.questionProgress),
          widgetName: "${AnalyticsScreenNames.consultationQuestionPage} $consultationId",
        );
        _saveAndGoToNextQuestion(
          context: context,
          questionId: questionId,
          responsesIds: responseIds,
          openedResponse: "",
          nextQuestionId: multipleChoicesQuestion.nextQuestionId,
        );
      },
      onBackTap: () {
        TrackerHelper.trackClick(
          clickName: AnalyticsEventNames.backConsultationQuestion.format(multipleChoicesQuestion.questionProgress),
          widgetName: "${AnalyticsScreenNames.consultationQuestionPage} $consultationId",
        );
        _removeAndGoToPreviousQuestion(context, stockState.questionsStack.last);
      },
    );
  }

  ConsultationQuestionOpenedView _handleQuestionOpened(
    String consultationId,
    ConsultationQuestionOpenedViewModel openedQuestion,
    int totalQuestions,
    ConsultationQuestionResponses? questionAlreadyAnswered,
    ConsultationQuestionsResponsesStockState stockState,
    BuildContext context,
  ) {
    return ConsultationQuestionOpenedView(
      openedQuestion: openedQuestion,
      totalQuestions: totalQuestions,
      previousResponses: questionAlreadyAnswered,
      onOpenedResponseInput: (questionId, responseText) {
        TrackerHelper.trackClick(
          clickName: AnalyticsEventNames.answerConsultationQuestion.format(openedQuestion.questionProgress),
          widgetName: "${AnalyticsScreenNames.consultationQuestionPage} $consultationId",
        );
        _saveAndGoToNextQuestion(
          context: context,
          questionId: questionId,
          responsesIds: [],
          openedResponse: responseText,
          nextQuestionId: openedQuestion.nextQuestionId,
        );
      },
      onBackTap: () {
        TrackerHelper.trackClick(
          clickName: AnalyticsEventNames.backConsultationQuestion.format(openedQuestion.questionProgress),
          widgetName: "${AnalyticsScreenNames.consultationQuestionPage} $consultationId",
        );
        _removeAndGoToPreviousQuestion(context, stockState.questionsStack.last);
      },
    );
  }

  ConsultationQuestionWithConditionsView _handleQuestionWithConditions(
    String consultationId,
    ConsultationQuestionWithConditionViewModel questionWithConditions,
    int totalQuestions,
    ConsultationQuestionResponses? questionAlreadyAnswered,
    ConsultationQuestionsResponsesStockState stockState,
    BuildContext context,
  ) {
    return ConsultationQuestionWithConditionsView(
      questionWithConditions: questionWithConditions,
      totalQuestions: totalQuestions,
      previousResponses: questionAlreadyAnswered,
      onWithConditionResponseTap: (questionId, responseId, nextQuestionId) {
        TrackerHelper.trackClick(
          clickName: AnalyticsEventNames.answerConsultationQuestion.format(questionWithConditions.questionProgress),
          widgetName: "${AnalyticsScreenNames.consultationQuestionPage} $consultationId",
        );
        _saveAndGoToNextQuestion(
          context: context,
          questionId: questionId,
          responsesIds: [responseId],
          openedResponse: "",
          nextQuestionId: nextQuestionId,
        );
      },
      onBackTap: () {
        TrackerHelper.trackClick(
          clickName: AnalyticsEventNames.backConsultationQuestion.format(questionWithConditions.questionProgress),
          widgetName: "${AnalyticsScreenNames.consultationQuestionPage} $consultationId",
        );
        _removeAndGoToPreviousQuestion(context, stockState.questionsStack.last);
      },
    );
  }

  ConsultationQuestionChapterView _handleChapter(
    String consultationId,
    ConsultationQuestionChapterViewModel chapter,
    int totalQuestions,
    ConsultationQuestionsResponsesStockState stockState,
    BuildContext context,
  ) {
    return ConsultationQuestionChapterView(
      chapter: chapter,
      totalQuestions: totalQuestions,
      onNextTap: () {
        TrackerHelper.trackClick(
          clickName: AnalyticsEventNames.chapterDescription,
          widgetName: "${AnalyticsScreenNames.consultationQuestionPage} $consultationId",
        );
        _saveAndGoToNextQuestion(
          context: context,
          isChapter: true,
          questionId: chapter.id,
          responsesIds: [],
          openedResponse: "",
          nextQuestionId: chapter.nextQuestionId,
        );
      },
      onBackTap: () {
        TrackerHelper.trackClick(
          clickName: AnalyticsEventNames.chapterDescription,
          widgetName: "${AnalyticsScreenNames.consultationQuestionPage} $consultationId",
        );
        _removeAndGoToPreviousQuestion(context, stockState.questionsStack.last);
      },
    );
  }

  void _saveAndGoToNextQuestion({
    required BuildContext context,
    required String questionId,
    bool isChapter = false,
    required List<String> responsesIds,
    required String openedResponse,
    required String? nextQuestionId,
  }) {
    if (isChapter) {
      context
          .read<ConsultationQuestionsResponsesStockBloc>()
          .add(AddConsultationChapterStockEvent(chapterId: questionId));
    } else {
      context.read<ConsultationQuestionsResponsesStockBloc>().add(
            AddConsultationQuestionsResponseStockEvent(
              questionResponse: ConsultationQuestionResponses(
                questionId: questionId,
                responseIds: responsesIds,
                responseText: openedResponse,
              ),
            ),
          );
    }
    if (nextQuestionId != null) {
      setState(() => currentQuestionId = nextQuestionId);
    } else {
      Navigator.pushNamed(
        context,
        ConsultationQuestionConfirmationPage.routeName,
        arguments: ConsultationQuestionConfirmationArguments(
          consultationId: widget.consultationId,
          consultationQuestionsResponsesBloc: context.read<ConsultationQuestionsResponsesStockBloc>(),
        ),
      );
    }
  }

  void _removeAndGoToPreviousQuestion(
    BuildContext context,
    String previousQuestionId,
  ) {
    context.read<ConsultationQuestionsResponsesStockBloc>().add(RemoveConsultationQuestionEvent());
    setState(() => currentQuestionId = previousQuestionId);
  }

  ConsultationQuestionResponses? _getPreviousResponses({
    required String questionId,
    required List<ConsultationQuestionResponses> inStockResponses,
  }) {
    try {
      return inStockResponses.firstWhere((inStockResponse) => inStockResponse.questionId == questionId);
    } catch (e) {
      return null;
    }
  }
}
