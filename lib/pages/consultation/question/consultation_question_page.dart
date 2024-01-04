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
import 'package:agora/common/manager/storage_manager.dart';
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

class ConsultationQuestionArguments {
  final String consultationId;
  final String consultationTitle;

  ConsultationQuestionArguments({
    required this.consultationId,
    required this.consultationTitle,
  });
}

class ConsultationQuestionPage extends StatelessWidget {
  static const routeName = "/consultationQuestionPage";

  final ConsultationQuestionArguments arguments;

  const ConsultationQuestionPage({super.key, required this.arguments});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<ConsultationQuestionsResponsesStockBloc>(
          create: (BuildContext context) => ConsultationQuestionsResponsesStockBloc(
            storageClient: StorageManager.getConsultationQuestionStorageClient(),
          )..add(RestoreSavingConsultationResponseEvent(consultationId: arguments.consultationId)),
        ),
        BlocProvider<ConsultationQuestionsBloc>(
          create: (BuildContext context) =>
              ConsultationQuestionsBloc(consultationRepository: RepositoryManager.getConsultationRepository())
                ..add(FetchConsultationQuestionsEvent(consultationId: arguments.consultationId)),
        ),
      ],
      child: BlocConsumer<ConsultationQuestionsResponsesStockBloc, ConsultationQuestionsResponsesStockState>(
        listener: (context, responsesStockState) {
          if (responsesStockState.shouldPop) {
            Navigator.pop(context);
          } else if (_isLastQuestion(responsesStockState.currentQuestionId, responsesStockState.questionIdStack)) {
            Navigator.pushNamed(
              context,
              ConsultationQuestionConfirmationPage.routeName,
              arguments: ConsultationQuestionConfirmationArguments(
                consultationId: arguments.consultationId,
                consultationTitle: arguments.consultationTitle,
                consultationQuestionsResponsesBloc: context.read<ConsultationQuestionsResponsesStockBloc>(),
              ),
            );
          }
        },
        buildWhen: (_, responsesStockState) {
          final currentQuestionId = responsesStockState.currentQuestionId;
          return currentQuestionId != null || _isFirstQuestion(currentQuestionId, responsesStockState.questionIdStack);
        },
        builder: (context, responsesStockState) {
          return BlocBuilder<ConsultationQuestionsBloc, ConsultationQuestionsState>(
            builder: (context, questionsState) {
              if (questionsState is ConsultationQuestionsFetchedState) {
                return _handleQuestionsFetchedState(context, responsesStockState, questionsState);
              } else if (questionsState is ConsultationQuestionsErrorState) {
                return _buildCommonState(context, AgoraErrorView());
              } else {
                return _buildCommonState(context, CircularProgressIndicator());
              }
            },
          );
        },
      ),
    );
  }

  bool _isFirstQuestion(String? currentQuestionId, List<String> questionIdStack) {
    return currentQuestionId == null && questionIdStack.isEmpty;
  }

  bool _isLastQuestion(String? currentQuestionId, List<String> questionIdStack) {
    return currentQuestionId == null && questionIdStack.isNotEmpty;
  }

  Widget _buildCommonState(BuildContext context, Widget child) {
    return AgoraScaffold(
      child: Column(
        children: [
          AgoraToolbar(
            style: AgoraToolbarStyle.close,
            pageLabel: 'Questionnaire consultation',
          ),
          SizedBox(height: MediaQuery.of(context).size.height / 10 * 4),
          Center(child: child),
        ],
      ),
    );
  }

  Widget _handleQuestionsFetchedState(
    BuildContext context,
    ConsultationQuestionsResponsesStockState responsesStockState,
    ConsultationQuestionsFetchedState questionsState,
  ) {
    var currentQuestionId = responsesStockState.currentQuestionId;
    if (_isFirstQuestion(currentQuestionId, responsesStockState.questionIdStack)) {
      currentQuestionId = questionsState.viewModels[0].id;
    }
    final currentQuestion = questionsState.viewModels.firstWhere((element) => element.id == currentQuestionId);
    final totalQuestions = questionsState.viewModels.length;
    final questionAlreadyAnswered = _getPreviousResponses(
      questionId: currentQuestion.id,
      inStockResponses: responsesStockState.questionsResponses,
    );
    return AgoraScaffold(
      popAction: () {
        _removeAndGoToPreviousQuestion(context);
        return false;
      },
      child: _buildContent(
        context,
        currentQuestion,
        totalQuestions,
        questionAlreadyAnswered,
        responsesStockState,
      ),
    );
  }

  Widget _buildContent(
    BuildContext context,
    ConsultationQuestionViewModel currentQuestion,
    int totalQuestions,
    ConsultationQuestionResponses? questionAlreadyAnswered,
    ConsultationQuestionsResponsesStockState responsesStockState,
  ) {
    if (currentQuestion is ConsultationQuestionUniqueViewModel) {
      return _handleQuestionUniqueChoice(
        context,
        arguments.consultationId,
        currentQuestion,
        totalQuestions,
        questionAlreadyAnswered,
      );
    } else if (currentQuestion is ConsultationQuestionMultipleViewModel) {
      return _handleQuestionMultipleChoices(
        context,
        arguments.consultationId,
        currentQuestion,
        totalQuestions,
        questionAlreadyAnswered,
      );
    } else if (currentQuestion is ConsultationQuestionOpenedViewModel) {
      return _handleQuestionOpened(
        context,
        arguments.consultationId,
        currentQuestion,
        totalQuestions,
        questionAlreadyAnswered,
      );
    }
    if (currentQuestion is ConsultationQuestionWithConditionViewModel) {
      return _handleQuestionWithConditions(
        context,
        arguments.consultationId,
        currentQuestion,
        totalQuestions,
        questionAlreadyAnswered,
      );
    } else if (currentQuestion is ConsultationQuestionChapterViewModel) {
      return _handleChapter(
        context,
        arguments.consultationId,
        currentQuestion,
        totalQuestions,
      );
    } else {
      return Container();
    }
  }

  ConsultationQuestionUniqueChoiceView _handleQuestionUniqueChoice(
    BuildContext context,
    String consultationId,
    ConsultationQuestionUniqueViewModel uniqueChoiceQuestion,
    int totalQuestions,
    ConsultationQuestionResponses? questionAlreadyAnswered,
  ) {
    return ConsultationQuestionUniqueChoiceView(
      uniqueChoiceQuestion: uniqueChoiceQuestion,
      totalQuestions: totalQuestions,
      previousSelectedResponses: questionAlreadyAnswered,
      onUniqueResponseTap: (questionId, responseId, otherResponse) {
        TrackerHelper.trackClick(
          clickName: AnalyticsEventNames.answerConsultationQuestion.format(uniqueChoiceQuestion.questionProgress),
          widgetName: "${AnalyticsScreenNames.consultationQuestionPage} $consultationId",
        );
        _saveAndGoToNextQuestion(
          context: context,
          questionId: questionId,
          responsesIds: [responseId],
          openedResponse: otherResponse,
          nextQuestionId: uniqueChoiceQuestion.nextQuestionId,
        );
      },
      onBackTap: () {
        TrackerHelper.trackClick(
          clickName: AnalyticsEventNames.backConsultationQuestion.format(uniqueChoiceQuestion.questionProgress),
          widgetName: "${AnalyticsScreenNames.consultationQuestionPage} $consultationId",
        );
        _removeAndGoToPreviousQuestion(context);
      },
    );
  }

  ConsultationQuestionMultipleChoicesView _handleQuestionMultipleChoices(
    BuildContext context,
    String consultationId,
    ConsultationQuestionMultipleViewModel multipleChoicesQuestion,
    int totalQuestions,
    ConsultationQuestionResponses? questionAlreadyAnswered,
  ) {
    return ConsultationQuestionMultipleChoicesView(
      multipleChoicesQuestion: multipleChoicesQuestion,
      totalQuestions: totalQuestions,
      previousSelectedResponses: questionAlreadyAnswered,
      onMultipleResponseTap: (questionId, responseIds, otherResponse) {
        TrackerHelper.trackClick(
          clickName: AnalyticsEventNames.answerConsultationQuestion.format(multipleChoicesQuestion.questionProgress),
          widgetName: "${AnalyticsScreenNames.consultationQuestionPage} $consultationId",
        );
        _saveAndGoToNextQuestion(
          context: context,
          questionId: questionId,
          responsesIds: responseIds,
          openedResponse: otherResponse,
          nextQuestionId: multipleChoicesQuestion.nextQuestionId,
        );
      },
      onBackTap: () {
        TrackerHelper.trackClick(
          clickName: AnalyticsEventNames.backConsultationQuestion.format(multipleChoicesQuestion.questionProgress),
          widgetName: "${AnalyticsScreenNames.consultationQuestionPage} $consultationId",
        );
        _removeAndGoToPreviousQuestion(context);
      },
    );
  }

  ConsultationQuestionOpenedView _handleQuestionOpened(
    BuildContext context,
    String consultationId,
    ConsultationQuestionOpenedViewModel openedQuestion,
    int totalQuestions,
    ConsultationQuestionResponses? questionAlreadyAnswered,
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
        _removeAndGoToPreviousQuestion(context);
      },
    );
  }

  ConsultationQuestionWithConditionsView _handleQuestionWithConditions(
    BuildContext context,
    String consultationId,
    ConsultationQuestionWithConditionViewModel questionWithConditions,
    int totalQuestions,
    ConsultationQuestionResponses? questionAlreadyAnswered,
  ) {
    return ConsultationQuestionWithConditionsView(
      questionWithConditions: questionWithConditions,
      totalQuestions: totalQuestions,
      previousSelectedResponses: questionAlreadyAnswered,
      onWithConditionResponseTap: (questionId, responseId, otherResponse, nextQuestionId) {
        TrackerHelper.trackClick(
          clickName: AnalyticsEventNames.answerConsultationQuestion.format(questionWithConditions.questionProgress),
          widgetName: "${AnalyticsScreenNames.consultationQuestionPage} $consultationId",
        );
        _saveAndGoToNextQuestion(
          context: context,
          questionId: questionId,
          responsesIds: [responseId],
          openedResponse: otherResponse,
          nextQuestionId: nextQuestionId,
        );
      },
      onBackTap: () {
        TrackerHelper.trackClick(
          clickName: AnalyticsEventNames.backConsultationQuestion.format(questionWithConditions.questionProgress),
          widgetName: "${AnalyticsScreenNames.consultationQuestionPage} $consultationId",
        );
        _removeAndGoToPreviousQuestion(context);
      },
    );
  }

  ConsultationQuestionChapterView _handleChapter(
    BuildContext context,
    String consultationId,
    ConsultationQuestionChapterViewModel chapter,
    int totalQuestions,
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
        _removeAndGoToPreviousQuestion(context);
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
      context.read<ConsultationQuestionsResponsesStockBloc>().add(
            AddConsultationChapterStockEvent(
              consultationId: arguments.consultationId,
              chapterId: questionId,
              nextQuestionId: nextQuestionId,
            ),
          );
    } else {
      context.read<ConsultationQuestionsResponsesStockBloc>().add(
            AddConsultationQuestionsResponseStockEvent(
              consultationId: arguments.consultationId,
              questionResponse: ConsultationQuestionResponses(
                questionId: questionId,
                responseIds: responsesIds,
                responseText: openedResponse,
              ),
              nextQuestionId: nextQuestionId,
            ),
          );
    }
  }

  void _removeAndGoToPreviousQuestion(BuildContext context) {
    context.read<ConsultationQuestionsResponsesStockBloc>().add(RemoveConsultationQuestionEvent());
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
