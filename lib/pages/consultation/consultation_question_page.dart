import 'package:agora/bloc/consultation/question/consultation_questions_bloc.dart';
import 'package:agora/bloc/consultation/question/consultation_questions_event.dart';
import 'package:agora/bloc/consultation/question/consultation_questions_state.dart';
import 'package:agora/bloc/consultation/question/response/stock/consultation_questions_responses_stock_bloc.dart';
import 'package:agora/bloc/consultation/question/response/stock/consultation_questions_responses_stock_event.dart';
import 'package:agora/common/client/repository_manager.dart';
import 'package:agora/design/custom_view/agora_error_view.dart';
import 'package:agora/design/custom_view/agora_questions_view.dart';
import 'package:agora/design/custom_view/agora_scaffold.dart';
import 'package:agora/domain/consultation/questions/responses/consultation_question_response.dart';
import 'package:agora/pages/consultation/consultation_question_confirmation_page.dart';
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
          )..add(FetchConsultationQuestionsEvent(consultationId: consultationId)),
        ),
        BlocProvider<ConsultationQuestionsResponsesStockBloc>(
          create: (BuildContext context) => ConsultationQuestionsResponsesStockBloc(),
        ),
      ],
      child: AgoraScaffold(
        shouldPop: false,
        child: BlocConsumer<ConsultationQuestionsBloc, ConsultationQuestionsState>(
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
          builder: (context, state) {
            if (state is ConsultationQuestionsFetchedState) {
              return AgoraQuestionsView(
                questionId: state.viewModels[state.currentQuestionIndex].id,
                questionText: state.viewModels[state.currentQuestionIndex].label,
                currentQuestionOrder: state.viewModels[state.currentQuestionIndex].order,
                currentQuestionType: state.viewModels[state.currentQuestionIndex].type,
                totalQuestions: state.viewModels.length,
                responses: state.viewModels[state.currentQuestionIndex].responseChoicesViewModels,
                onUniqueResponseTap: (questionId, responseId) {
                  context.read<ConsultationQuestionsResponsesStockBloc>().add(
                        AddConsultationQuestionsResponseStockEvent(
                          questionResponse: ConsultationQuestionResponse(
                            questionId: questionId,
                            responseIds: [responseId],
                            responseText: "",
                          ),
                        ),
                      );
                  context.read<ConsultationQuestionsBloc>().add(ConsultationNextQuestionEvent());
                },
                onOpenedResponseInput: (questionId, responseText) {
                  context.read<ConsultationQuestionsResponsesStockBloc>().add(
                        AddConsultationQuestionsResponseStockEvent(
                          questionResponse: ConsultationQuestionResponse(
                            questionId: questionId,
                            responseIds: [],
                            responseText: responseText,
                          ),
                        ),
                      );
                  context.read<ConsultationQuestionsBloc>().add(ConsultationNextQuestionEvent());
                },
                onBackTap: () {
                  context
                      .read<ConsultationQuestionsResponsesStockBloc>()
                      .add(RemoveConsultationQuestionsResponseStockEvent());
                  context.read<ConsultationQuestionsBloc>().add(ConsultationPreviousQuestionEvent());
                },
              );
            } else if (state is ConsultationQuestionsInitialLoadingState) {
              return Center(child: CircularProgressIndicator());
            } else if (state is ConsultationQuestionsErrorState) {
              return Center(child: AgoraErrorView());
            } else {
              return Center(child: CircularProgressIndicator());
            }
          },
        ),
      ),
    );
  }
}
