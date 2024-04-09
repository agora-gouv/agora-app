import 'package:agora/bloc/consultation/question/response/send/consultation_questions_responses_bloc.dart';
import 'package:agora/bloc/consultation/question/response/send/consultation_questions_responses_event.dart';
import 'package:agora/bloc/consultation/question/response/send/consultation_questions_responses_state.dart';
import 'package:agora/bloc/consultation/question/response/stock/consultation_questions_responses_stock_bloc.dart';
import 'package:agora/bloc/consultation/question/response/stock/consultation_questions_responses_stock_event.dart';
import 'package:agora/common/manager/repository_manager.dart';
import 'package:agora/design/custom_view/agora_error_view.dart';
import 'package:agora/design/custom_view/agora_scaffold.dart';
import 'package:agora/design/custom_view/agora_toolbar.dart';
import 'package:agora/design/custom_view/agora_top_diagonal.dart';
import 'package:agora/design/style/agora_text_styles.dart';
import 'package:agora/pages/consultation/dynamic/dynamic_consultation_page.dart';
import 'package:agora/pages/demographic/demographic_information_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';

class ConsultationQuestionConfirmationArguments {
  final String consultationId;
  final String consultationTitle;
  final ConsultationQuestionsResponsesStockBloc consultationQuestionsResponsesBloc;

  ConsultationQuestionConfirmationArguments({
    required this.consultationId,
    required this.consultationTitle,
    required this.consultationQuestionsResponsesBloc,
  });
}

class ConsultationQuestionConfirmationPage extends StatelessWidget {
  static const routeName = "/consultationQuestionConfirmationPage";

  final String consultationId;
  final String consultationTitle;

  ConsultationQuestionConfirmationPage({required this.consultationId, required this.consultationTitle});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) {
        final questionsResponsesStockState = context.read<ConsultationQuestionsResponsesStockBloc>().state;
        return ConsultationQuestionsResponsesBloc(consultationRepository: RepositoryManager.getConsultationRepository())
          ..add(
            SendConsultationQuestionsResponsesEvent(
              consultationId: consultationId,
              questionIdStack: questionsResponsesStockState.questionIdStack,
              questionsResponses: questionsResponsesStockState.questionsResponses,
            ),
          );
      },
      child: AgoraScaffold(
        shouldPop: false,
        appBarType: AppBarColorType.primaryColor,
        child: BlocConsumer<ConsultationQuestionsResponsesBloc, SendConsultationQuestionsResponsesState>(
          listener: (context, state) {
            if (state is SendConsultationQuestionsResponsesSuccessState) {
              if (state.shouldDisplayDemographicInformation) {
                Navigator.pushNamed(
                  context,
                  DemographicInformationPage.routeName,
                  arguments: DemographicInformationArguments(
                    consultationId: consultationId,
                    consultationTitle: consultationTitle,
                  ),
                ).then((value) => Navigator.of(context).pop());
              } else {
                Navigator.pushNamed(
                  context,
                  DynamicConsultationPage.routeName,
                  arguments: DynamicConsultationPageArguments(
                    consultationId: consultationId,
                  ),
                ).then((value) => Navigator.of(context).pop());
              }
            } else if (state is SendConsultationQuestionsResponsesFailureState) {
              context
                  .read<ConsultationQuestionsResponsesStockBloc>()
                  .add(ResetToLastQuestionEvent(consultationId: consultationId));
            }
          },
          builder: (context, state) {
            return SingleChildScrollView(
              physics: ClampingScrollPhysics(),
              child: Column(
                children: [
                  AgoraTopDiagonal(),
                  _buildState(context, state),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildState(BuildContext context, SendConsultationQuestionsResponsesState state) {
    if (state is SendConsultationQuestionsResponsesSuccessState && !state.shouldDisplayDemographicInformation) {
      return Container();
    } else if (state is SendConsultationQuestionsResponsesInitialLoadingState || _shouldDisplayDemographicQuiz(state)) {
      return ConstrainedBox(
        constraints: BoxConstraints(maxHeight: MediaQuery.sizeOf(context).height - 60),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildToolbar(context, 'Envoi en cours'),
            Flexible(flex: 1, child: SizedBox()),
            Lottie.asset(
              'assets/animations/loading_consultation.json',
              width: MediaQuery.sizeOf(context).width,
            ),
            Center(child: Text('Envoi de vos réponses', style: AgoraTextStyles.light16)),
            Flexible(flex: 2, child: SizedBox()),
          ],
        ),
      );
    } else {
      return Column(
        children: [
          _buildToolbar(context, 'Erreur dans l\'envoi du questionnaire'),
          SizedBox(height: MediaQuery.of(context).size.height / 10 * 4),
          Center(child: AgoraErrorView()),
        ],
      );
    }
  }

  Widget _buildToolbar(BuildContext context, String label) {
    return AgoraToolbar(
      pageLabel: label,
      onBackClick: () => Navigator.popUntil(context, ModalRoute.withName(DynamicConsultationPage.routeName)),
    );
  }

  bool _shouldDisplayDemographicQuiz(SendConsultationQuestionsResponsesState state) {
    return state is SendConsultationQuestionsResponsesSuccessState && state.shouldDisplayDemographicInformation;
  }
}
