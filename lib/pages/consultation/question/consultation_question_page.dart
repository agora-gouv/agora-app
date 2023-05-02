import 'package:agora/bloc/consultation/question/consultation_questions_bloc.dart';
import 'package:agora/bloc/consultation/question/consultation_questions_event.dart';
import 'package:agora/bloc/consultation/question/consultation_questions_state.dart';
import 'package:agora/bloc/consultation/question/consultation_questions_view_model.dart';
import 'package:agora/bloc/consultation/question/response/stock/consultation_questions_responses_stock_bloc.dart';
import 'package:agora/bloc/consultation/question/response/stock/consultation_questions_responses_stock_event.dart';
import 'package:agora/bloc/consultation/question/response/stock/consultation_questions_responses_stock_state.dart';
import 'package:agora/common/manager/helper_manager.dart';
import 'package:agora/common/manager/repository_manager.dart';
import 'package:agora/design/custom_view/agora_error_view.dart';
import 'package:agora/design/custom_view/agora_scaffold.dart';
import 'package:agora/domain/consultation/questions/responses/consultation_question_response.dart';
import 'package:agora/pages/consultation/consultation_question_confirmation_page.dart';
import 'package:agora/pages/consultation/question/question_type_view/consultation_question_chapter_view.dart';
import 'package:agora/pages/consultation/question/question_type_view/consultation_question_multiple_choices_view.dart';
import 'package:agora/pages/consultation/question/question_type_view/consultation_question_opened_view.dart';
import 'package:agora/pages/consultation/question/question_type_view/consultation_question_unique_choice_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ConsultationQuestionPage extends StatelessWidget {
  static const routeName = "/consultationQuestionPage";

  @override
  Widget build(BuildContext context) {
    final consultationId = ModalRoute.of(context)!.settings.arguments as String;
    return MultiBlocProvider(
      providers: [
        BlocProvider<ConsultationQuestionsBloc>(
          create: (BuildContext context) => ConsultationQuestionsBloc(
            consultationRepository: RepositoryManager.getConsultationRepository(),
            deviceInfoHelper: HelperManager.getDeviceInfoHelper(),
          )..add(FetchConsultationQuestionsEvent(consultationId: consultationId)),
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
                      currentQuestion,
                      totalQuestions,
                      questionAlreadyAnswered,
                      context,
                    );
                  } else if (currentQuestion is ConsultationQuestionMultipleViewModel) {
                    return _handleQuestionMultipleChoices(
                      currentQuestion,
                      totalQuestions,
                      questionAlreadyAnswered,
                      context,
                    );
                  } else if (currentQuestion is ConsultationQuestionOpenedViewModel) {
                    return _handleQuestionOpened(
                      currentQuestion,
                      totalQuestions,
                      questionAlreadyAnswered,
                      context,
                    );
                  } else if (currentQuestion is ConsultationQuestionChapterViewModel) {
                    return _handleChapter(
                      currentQuestion,
                      totalQuestions,
                      context,
                    );
                  } else {
                    return Container();
                  }
                } else if (questionsState is ConsultationQuestionsInitialLoadingState) {
                  return Center(child: CircularProgressIndicator());
                } else if (questionsState is ConsultationQuestionsErrorState) {
                  return Center(child: AgoraErrorView());
                } else {
                  return Center(child: CircularProgressIndicator());
                }
              },
            );
          },
        ),
      ),
    );
  }

  ConsultationQuestionUniqueChoiceView _handleQuestionUniqueChoice(
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
        _saveAndNextQuestion(
          context: context,
          questionId: questionId,
          responsesIds: [responseId],
          openedResponse: "",
        );
      },
      onBackTap: () => context.read<ConsultationQuestionsBloc>().add(ConsultationPreviousQuestionEvent()),
    );
  }

  ConsultationQuestionMultipleChoicesView _handleQuestionMultipleChoices(
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
        _saveAndNextQuestion(
          context: context,
          questionId: questionId,
          responsesIds: responseIds,
          openedResponse: "",
        );
      },
      onBackTap: () => context.read<ConsultationQuestionsBloc>().add(ConsultationPreviousQuestionEvent()),
    );
  }

  ConsultationQuestionOpenedView _handleQuestionOpened(
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
        _saveAndNextQuestion(
          context: context,
          questionId: questionId,
          responsesIds: [],
          openedResponse: responseText,
        );
      },
      onBackTap: () => context.read<ConsultationQuestionsBloc>().add(ConsultationPreviousQuestionEvent()),
    );
  }

  ConsultationQuestionChapterView _handleChapter(
    ConsultationQuestionChapterViewModel chapter,
    int totalQuestions,
    BuildContext context,
  ) {
    return ConsultationQuestionChapterView(
      chapter: chapter,
      totalQuestions: totalQuestions,
      onNextTap: () => context.read<ConsultationQuestionsBloc>().add(ConsultationNextQuestionEvent()),
      onBackTap: () => context.read<ConsultationQuestionsBloc>().add(ConsultationPreviousQuestionEvent()),
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
