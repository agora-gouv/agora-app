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
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ConsultationQuestionPage extends StatelessWidget {
  static const routeName = "/consultationQuestionPage";

  final String consultationId;

  const ConsultationQuestionPage({super.key, required this.consultationId});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<ConsultationQuestionsBloc>(
          create: (BuildContext context) =>
              ConsultationQuestionsBloc(consultationRepository: RepositoryManager.getConsultationRepository())
                ..add(FetchConsultationQuestionsEvent(consultationId: consultationId)),
        ),
        BlocProvider<ConsultationQuestionsResponsesStockBloc>(
          create: (BuildContext context) => ConsultationQuestionsResponsesStockBloc(),
        ),
      ],
      child: AgoraScaffold(
        shouldPop: false,
        child: BlocBuilder<ConsultationQuestionsResponsesStockBloc, ConsultationQuestionsResponsesStockState>(
          builder: (context, responsesStockState) {
            return BlocConsumer<ConsultationQuestionsBloc, ConsultationQuestionsState>(
              listener: (context, state) {
                if (state is ConsultationQuestionsFinishState) {
                  Navigator.pushNamed(
                    context,
                    ConsultationQuestionConfirmationPage.routeName,
                    arguments: ConsultationQuestionConfirmationArguments(
                      consultationId: consultationId,
                      consultationQuestionsResponsesBloc: context.read<ConsultationQuestionsResponsesStockBloc>(),
                    ),
                  );
                }
              },
              builder: (context, questionsState) {
                if (questionsState is ConsultationQuestionsFetchedState) {
                  final currentQuestion = questionsState.viewModels[questionsState.currentQuestionIndex];
                  final totalQuestions = questionsState.totalQuestion;
                  final questionAlreadyAnswered = _getPreviousResponses(
                    questionId: currentQuestion.id,
                    inStockResponses: responsesStockState.questionsResponses,
                  );
                  if (currentQuestion is ConsultationQuestionUniqueViewModel) {
                    return _handleQuestionUniqueChoice(
                      consultationId,
                      currentQuestion,
                      totalQuestions,
                      questionAlreadyAnswered,
                      context,
                    );
                  } else if (currentQuestion is ConsultationQuestionMultipleViewModel) {
                    return _handleQuestionMultipleChoices(
                      consultationId,
                      currentQuestion,
                      totalQuestions,
                      questionAlreadyAnswered,
                      context,
                    );
                  } else if (currentQuestion is ConsultationQuestionOpenedViewModel) {
                    return _handleQuestionOpened(
                      consultationId,
                      currentQuestion,
                      totalQuestions,
                      questionAlreadyAnswered,
                      context,
                    );
                  } else if (currentQuestion is ConsultationQuestionChapterViewModel) {
                    return _handleChapter(
                      consultationId,
                      currentQuestion,
                      totalQuestions,
                      context,
                    );
                  } else {
                    return Container();
                  }
                } else if (questionsState is ConsultationQuestionsErrorState) {
                  return Column(
                    children: [
                      AgoraToolbar(style: AgoraToolbarStyle.close),
                      SizedBox(height: MediaQuery.of(context).size.height / 10 * 4),
                      Center(child: AgoraErrorView()),
                    ],
                  );
                } else {
                  return Column(
                    children: [
                      AgoraToolbar(style: AgoraToolbarStyle.close),
                      SizedBox(height: MediaQuery.of(context).size.height / 10 * 4),
                      Center(child: CircularProgressIndicator()),
                    ],
                  );
                }
              },
            );
          },
        ),
      ),
    );
  }

  ConsultationQuestionUniqueChoiceView _handleQuestionUniqueChoice(
    String consultationId,
    ConsultationQuestionUniqueViewModel uniqueChoiceQuestion,
    int totalQuestions,
    ConsultationQuestionResponses? questionAlreadyAnswered,
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
        _saveAndNextQuestion(
          context: context,
          questionId: questionId,
          responsesIds: [responseId],
          openedResponse: "",
        );
      },
      onBackTap: () {
        TrackerHelper.trackClick(
          clickName: AnalyticsEventNames.backConsultationQuestion.format(uniqueChoiceQuestion.questionProgress),
          widgetName: "${AnalyticsScreenNames.consultationQuestionPage} $consultationId",
        );
        context.read<ConsultationQuestionsBloc>().add(ConsultationPreviousQuestionEvent());
      },
    );
  }

  ConsultationQuestionMultipleChoicesView _handleQuestionMultipleChoices(
    String consultationId,
    ConsultationQuestionMultipleViewModel multipleChoicesQuestion,
    int totalQuestions,
    ConsultationQuestionResponses? questionAlreadyAnswered,
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
        _saveAndNextQuestion(
          context: context,
          questionId: questionId,
          responsesIds: responseIds,
          openedResponse: "",
        );
      },
      onBackTap: () {
        TrackerHelper.trackClick(
          clickName: AnalyticsEventNames.backConsultationQuestion.format(multipleChoicesQuestion.questionProgress),
          widgetName: "${AnalyticsScreenNames.consultationQuestionPage} $consultationId",
        );
        context.read<ConsultationQuestionsBloc>().add(ConsultationPreviousQuestionEvent());
      },
    );
  }

  ConsultationQuestionOpenedView _handleQuestionOpened(
    String consultationId,
    ConsultationQuestionOpenedViewModel openedQuestion,
    int totalQuestions,
    ConsultationQuestionResponses? questionAlreadyAnswered,
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
        _saveAndNextQuestion(
          context: context,
          questionId: questionId,
          responsesIds: [],
          openedResponse: responseText,
        );
      },
      onBackTap: () {
        TrackerHelper.trackClick(
          clickName: AnalyticsEventNames.backConsultationQuestion.format(openedQuestion.questionProgress),
          widgetName: "${AnalyticsScreenNames.consultationQuestionPage} $consultationId",
        );
        context.read<ConsultationQuestionsBloc>().add(ConsultationPreviousQuestionEvent());
      },
    );
  }

  ConsultationQuestionChapterView _handleChapter(
    String consultationId,
    ConsultationQuestionChapterViewModel chapter,
    int totalQuestions,
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
        context.read<ConsultationQuestionsBloc>().add(ConsultationNextQuestionEvent());
      },
      onBackTap: () {
        TrackerHelper.trackClick(
          clickName: AnalyticsEventNames.chapterDescription,
          widgetName: "${AnalyticsScreenNames.consultationQuestionPage} $consultationId",
        );
        context.read<ConsultationQuestionsBloc>().add(ConsultationPreviousQuestionEvent());
      },
    );
  }

  void _saveAndNextQuestion({
    required BuildContext context,
    required String questionId,
    required List<String> responsesIds,
    required String openedResponse,
  }) {
    context.read<ConsultationQuestionsResponsesStockBloc>().add(
          AddConsultationQuestionsResponseStockEvent(
            questionResponse: ConsultationQuestionResponses(
              questionId: questionId,
              responseIds: responsesIds,
              responseText: openedResponse,
            ),
          ),
        );
    context.read<ConsultationQuestionsBloc>().add(ConsultationNextQuestionEvent());
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
