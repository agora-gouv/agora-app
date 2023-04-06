import 'package:agora/bloc/consultation/question/consultation_questions_action.dart';
import 'package:agora/bloc/consultation/question/consultation_questions_bloc.dart';
import 'package:agora/bloc/consultation/question/consultation_questions_state.dart';
import 'package:agora/bloc/consultation/question/response/consultation_questions_responses_action.dart';
import 'package:agora/bloc/consultation/question/response/consultation_questions_responses_bloc.dart';
import 'package:agora/common/repository_manager.dart';
import 'package:agora/design/custom_view/agora_questions_view.dart';
import 'package:agora/design/custom_view/agora_scaffold.dart';
import 'package:agora/domain/consultation/questions/responses/consultation_question_response.dart';
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
        BlocProvider<ConsultationQuestionsResponsesBloc>(
          create: (BuildContext context) => ConsultationQuestionsResponsesBloc(),
        ),
      ],
      child: AgoraScaffold(
        // shouldPop: false, // TODO shouldPop need to be false when new screen with go back to menu button will be add
        child: BlocBuilder<ConsultationQuestionsBloc, ConsultationQuestionsState>(
          builder: (context, state) {
            if (state is ConsultationQuestionsFetchedState) {
              return AgoraQuestionsView(
                questionId: state.viewModels[state.currentQuestionIndex].id,
                questionText: state.viewModels[state.currentQuestionIndex].label,
                currentQuestionOrder: state.viewModels[state.currentQuestionIndex].order,
                totalQuestions: state.viewModels.length,
                responses: state.viewModels[state.currentQuestionIndex].responseChoicesViewModels,
                onResponseTap: (questionId, responseId) {
                  context.read<ConsultationQuestionsResponsesBloc>().add(
                        AddConsultationQuestionsResponseEvent(
                          questionResponse: ConsultationQuestionResponse(
                            questionId: questionId,
                            responseId: responseId,
                          ),
                        ),
                      );
                  context.read<ConsultationQuestionsBloc>().add(ConsultationNextQuestionEvent());
                },
                onBackTap: () {
                  context.read<ConsultationQuestionsResponsesBloc>().add(RemoveConsultationQuestionsResponseEvent());
                  context.read<ConsultationQuestionsBloc>().add(ConsultationPreviousQuestionEvent());
                },
              );
            } else if (state is ConsultationQuestionsInitialState || state is ConsultationQuestionsLoadingState) {
              return Center(child: CircularProgressIndicator());
            } else if (state is ConsultationQuestionsErrorState) {
              return Center(child: Text("An error occurred"));
            } else {
              return Center(child: Text("Vous avez fini de répondre à ce questionnaire"));
            }
          },
        ),
      ),
    );
  }
}
