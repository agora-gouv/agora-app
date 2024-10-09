import 'package:agora/common/analytics/analytics_event_names.dart';
import 'package:agora/common/analytics/analytics_screen_names.dart';
import 'package:agora/common/extension/string_extension.dart';
import 'package:agora/common/helper/tracker_helper.dart';
import 'package:agora/common/manager/repository_manager.dart';
import 'package:agora/common/manager/storage_manager.dart';
import 'package:agora/consultation/bloc/consultation_questions_state.dart';
import 'package:agora/consultation/question/bloc/consultation_questions_bloc.dart';
import 'package:agora/consultation/question/bloc/consultation_questions_event.dart';
import 'package:agora/consultation/question/bloc/consultation_questions_view_model.dart';
import 'package:agora/consultation/question/bloc/response/stock/consultation_questions_responses_stock_bloc.dart';
import 'package:agora/consultation/question/bloc/response/stock/consultation_questions_responses_stock_event.dart';
import 'package:agora/consultation/question/bloc/response/stock/consultation_questions_responses_stock_state.dart';
import 'package:agora/consultation/question/domain/consultation_question_response.dart';
import 'package:agora/consultation/question/pages/consultation_question_confirmation_page.dart';
import 'package:agora/consultation/question/pages/question_type_view/consultation_question_chapter_view.dart';
import 'package:agora/consultation/question/pages/question_type_view/consultation_question_multiple_choices_view.dart';
import 'package:agora/consultation/question/pages/question_type_view/consultation_question_opened_view.dart';
import 'package:agora/consultation/question/pages/question_type_view/consultation_question_unique_choice_view.dart';
import 'package:agora/consultation/question/pages/question_type_view/consultation_question_with_conditions_view.dart';
import 'package:agora/design/custom_view/agora_scaffold.dart';
import 'package:agora/design/custom_view/agora_toolbar.dart';
import 'package:agora/design/custom_view/error/agora_error_text.dart';
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

class ConsultationQuestionPage extends StatefulWidget {
  static const routeName = "/consultationQuestionPage";

  final ConsultationQuestionArguments arguments;

  const ConsultationQuestionPage({super.key, required this.arguments});

  @override
  State<ConsultationQuestionPage> createState() => _ConsultationQuestionPageState();
}

class _ConsultationQuestionPageState extends State<ConsultationQuestionPage> {
  int currentQuestionIndex = 1;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<ConsultationQuestionsResponsesStockBloc>(
          create: (BuildContext context) => ConsultationQuestionsResponsesStockBloc(
            storageClient: StorageManager.getConsultationQuestionStorageClient(),
          )..add(RestoreSavingConsultationResponseEvent(consultationId: widget.arguments.consultationId)),
        ),
        BlocProvider<ConsultationQuestionsBloc>(
          create: (BuildContext context) =>
              ConsultationQuestionsBloc(consultationRepository: RepositoryManager.getConsultationRepository())
                ..add(FetchConsultationQuestionsEvent(consultationId: widget.arguments.consultationId)),
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
                consultationId: widget.arguments.consultationId,
                consultationTitle: widget.arguments.consultationTitle,
                consultationQuestionsResponsesBloc: context.read<ConsultationQuestionsResponsesStockBloc>(),
              ),
            ).then((value) {
              if (context.mounted) {
                Navigator.of(context).pop();
              }
            });
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
                return _buildCommonState(context, AgoraErrorText());
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
            semanticPageLabel: 'Questionnaire consultation',
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
    currentQuestionIndex = responsesStockState.questionIdStack.length + 1;
    var currentQuestionId = responsesStockState.currentQuestionId;
    if (_isFirstQuestion(currentQuestionId, responsesStockState.questionIdStack)) {
      currentQuestionId = questionsState.consultationQuestionsViewModel.questions[0].id;
    }
    final currentQuestion = questionsState.consultationQuestionsViewModel.questions
        .firstWhere((element) => element.id == currentQuestionId);
    final totalQuestions = questionsState.consultationQuestionsViewModel.questionCount;
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
        widget.arguments.consultationId,
        currentQuestion,
        totalQuestions,
        questionAlreadyAnswered,
      );
    } else if (currentQuestion is ConsultationQuestionMultipleViewModel) {
      return _handleQuestionMultipleChoices(
        context,
        widget.arguments.consultationId,
        currentQuestion,
        totalQuestions,
        questionAlreadyAnswered,
      );
    } else if (currentQuestion is ConsultationQuestionOpenedViewModel) {
      return _handleQuestionOpened(
        context,
        widget.arguments.consultationId,
        currentQuestion,
        totalQuestions,
        questionAlreadyAnswered,
      );
    }
    if (currentQuestion is ConsultationQuestionWithConditionViewModel) {
      return _handleQuestionWithConditions(
        context,
        widget.arguments.consultationId,
        currentQuestion,
        totalQuestions,
        questionAlreadyAnswered,
      );
    } else if (currentQuestion is ConsultationQuestionChapterViewModel) {
      return _handleChapter(
        context,
        widget.arguments.consultationId,
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
    final questionNumberLabel = 'Question $currentQuestionIndex';
    return ConsultationQuestionUniqueChoiceView(
      uniqueChoiceQuestion: uniqueChoiceQuestion,
      totalQuestions: totalQuestions,
      previousSelectedResponses: questionAlreadyAnswered,
      currentQuestionIndex: currentQuestionIndex,
      onUniqueResponseTap: (questionId, responseId, otherResponse) {
        setState(() {
          if (uniqueChoiceQuestion.nextQuestionId != null) {
            currentQuestionIndex++;
          }
        });
        TrackerHelper.trackClick(
          clickName: AnalyticsEventNames.answerConsultationQuestion.format(questionNumberLabel),
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
        setState(() {
          currentQuestionIndex--;
        });
        TrackerHelper.trackClick(
          clickName: AnalyticsEventNames.backConsultationQuestion.format(questionNumberLabel),
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
    final questionNumberLabel = 'Question $currentQuestionIndex';
    return ConsultationQuestionMultipleChoicesView(
      multipleChoicesQuestion: multipleChoicesQuestion,
      totalQuestions: totalQuestions,
      previousSelectedResponses: questionAlreadyAnswered,
      currentQuestionIndex: currentQuestionIndex,
      onMultipleResponseTap: (questionId, responseIds, otherResponse) {
        setState(() {
          if (multipleChoicesQuestion.nextQuestionId != null) {
            currentQuestionIndex++;
          }
        });
        TrackerHelper.trackClick(
          clickName: AnalyticsEventNames.answerConsultationQuestion.format(questionNumberLabel),
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
        setState(() {
          currentQuestionIndex--;
        });
        TrackerHelper.trackClick(
          clickName: AnalyticsEventNames.backConsultationQuestion.format(questionNumberLabel),
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
    final questionNumberLabel = 'Question $currentQuestionIndex';
    return ConsultationQuestionOpenedView(
      openedQuestion: openedQuestion,
      totalQuestions: totalQuestions,
      previousResponses: questionAlreadyAnswered,
      currentQuestionIndex: currentQuestionIndex,
      onOpenedResponseInput: (questionId, responseText) {
        setState(() {
          if (openedQuestion.nextQuestionId != null) {
            currentQuestionIndex++;
          }
        });
        TrackerHelper.trackClick(
          clickName: AnalyticsEventNames.answerConsultationQuestion.format(questionNumberLabel),
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
        setState(() {
          currentQuestionIndex--;
        });
        TrackerHelper.trackClick(
          clickName: AnalyticsEventNames.backConsultationQuestion.format(questionNumberLabel),
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
    final questionNumberLabel = 'Question $currentQuestionIndex';
    return ConsultationQuestionWithConditionsView(
      questionWithConditions: questionWithConditions,
      totalQuestions: totalQuestions,
      previousSelectedResponses: questionAlreadyAnswered,
      currentQuestionIndex: currentQuestionIndex,
      onWithConditionResponseTap: (questionId, responseId, otherResponse, nextQuestionId) {
        setState(() {
          currentQuestionIndex++;
        });
        TrackerHelper.trackClick(
          clickName: AnalyticsEventNames.answerConsultationQuestion.format(questionNumberLabel),
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
        setState(() {
          currentQuestionIndex--;
        });
        TrackerHelper.trackClick(
          clickName: AnalyticsEventNames.backConsultationQuestion.format(questionNumberLabel),
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
      currentQuestionIndex: currentQuestionIndex,
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
              consultationId: widget.arguments.consultationId,
              chapterId: questionId,
              nextQuestionId: nextQuestionId,
            ),
          );
    } else {
      context.read<ConsultationQuestionsResponsesStockBloc>().add(
            AddConsultationQuestionsResponseStockEvent(
              consultationId: widget.arguments.consultationId,
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
