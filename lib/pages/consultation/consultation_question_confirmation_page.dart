import 'package:agora/bloc/consultation/question/response/send/consultation_questions_responses_bloc.dart';
import 'package:agora/bloc/consultation/question/response/send/consultation_questions_responses_event.dart';
import 'package:agora/bloc/consultation/question/response/send/consultation_questions_responses_state.dart';
import 'package:agora/bloc/consultation/question/response/stock/consultation_questions_responses_stock_bloc.dart';
import 'package:agora/common/client/repository_manager.dart';
import 'package:agora/common/strings/consultation_strings.dart';
import 'package:agora/design/agora_button.dart';
import 'package:agora/design/agora_button_style.dart';
import 'package:agora/design/agora_spacings.dart';
import 'package:agora/design/agora_text_styles.dart';
import 'package:agora/design/custom_view/agora_error_view.dart';
import 'package:agora/design/custom_view/agora_scaffold.dart';
import 'package:agora/design/custom_view/agora_top_diagonal.dart';
import 'package:agora/pages/loading_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ConsultationQuestionConfirmationArguments {
  final String consultationId;
  final ConsultationQuestionsResponsesStockBloc consultationQuestionsResponsesBloc;

  ConsultationQuestionConfirmationArguments({
    required this.consultationId,
    required this.consultationQuestionsResponsesBloc,
  });
}

class ConsultationQuestionConfirmationPage extends StatelessWidget {
  static const routeName = "/consultationQuestionConfirmationPage";

  final String consultationId;

  ConsultationQuestionConfirmationPage({required this.consultationId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) {
        return ConsultationQuestionsResponsesBloc(
          consultationRepository: RepositoryManager.getConsultationRepository(),
        )..add(
            SendConsultationQuestionsResponsesEvent(
              consultationId: consultationId,
              questionsResponses: context.read<ConsultationQuestionsResponsesStockBloc>().state.questionsResponses,
            ),
          );
      },
      child: AgoraScaffold(
        shouldPop: false,
        child: BlocBuilder<ConsultationQuestionsResponsesBloc, SendConsultationQuestionsResponsesState>(
          builder: (context, state) {
            if (state is SendConsultationQuestionsResponsesSuccessState) {
              return SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                child: Column(
                  children: [
                    AgoraTopDiagonal(),
                    Image.asset("assets/ic_question_confirmation.png"),
                    Padding(
                      padding: const EdgeInsets.all(AgoraSpacings.x1_5),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            ConsultationStrings.confirmationTitle,
                            style: AgoraTextStyles.medium19,
                          ),
                          SizedBox(height: AgoraSpacings.base),
                          Text(
                            ConsultationStrings.confirmationDescription,
                            style: AgoraTextStyles.light16,
                          ),
                          SizedBox(height: AgoraSpacings.x1_5),
                          AgoraButton(
                            label: ConsultationStrings.goToResult,
                            style: AgoraButtonStyle.primaryButtonStyle,
                            onPressed: () {
                              // TODO next ticket go to result
                              Navigator.pushNamedAndRemoveUntil(
                                context,
                                LoadingPage.routeName,
                                (route) => false,
                              );
                            },
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              );
            } else if (state is SendConsultationQuestionsResponsesInitialState ||
                state is SendConsultationQuestionsResponsesLoadingState) {
              return Center(child: CircularProgressIndicator());
            } else {
              return Center(child: AgoraErrorView());
            }
          },
        ),
      ),
    );
  }
}
