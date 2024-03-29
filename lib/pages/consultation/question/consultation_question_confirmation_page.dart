import 'package:agora/bloc/consultation/question/response/send/consultation_questions_responses_bloc.dart';
import 'package:agora/bloc/consultation/question/response/send/consultation_questions_responses_event.dart';
import 'package:agora/bloc/consultation/question/response/send/consultation_questions_responses_state.dart';
import 'package:agora/bloc/consultation/question/response/stock/consultation_questions_responses_stock_bloc.dart';
import 'package:agora/bloc/consultation/question/response/stock/consultation_questions_responses_stock_event.dart';
import 'package:agora/common/analytics/analytics_event_names.dart';
import 'package:agora/common/analytics/analytics_screen_names.dart';
import 'package:agora/common/helper/responsive_helper.dart';
import 'package:agora/common/helper/share_helper.dart';
import 'package:agora/common/helper/tracker_helper.dart';
import 'package:agora/common/manager/repository_manager.dart';
import 'package:agora/common/strings/consultation_strings.dart';
import 'package:agora/design/custom_view/agora_error_view.dart';
import 'package:agora/design/custom_view/agora_scaffold.dart';
import 'package:agora/design/custom_view/agora_toolbar.dart';
import 'package:agora/design/custom_view/agora_top_diagonal.dart';
import 'package:agora/design/custom_view/button/agora_button.dart';
import 'package:agora/design/style/agora_button_style.dart';
import 'package:agora/design/style/agora_spacings.dart';
import 'package:agora/design/style/agora_text_styles.dart';
import 'package:agora/pages/consultation/details/consultation_details_page.dart';
import 'package:agora/pages/consultation/summary/consultation_summary_page.dart';
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
                );
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
      return _buildContent(context);
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
      onBackClick: () => Navigator.popUntil(context, ModalRoute.withName(ConsultationDetailsPage.routeName)),
    );
  }

  Widget _buildContent(BuildContext context) {
    final largerThanMobile = ResponsiveHelper.isLargerThanMobile(context);
    return Column(
      crossAxisAlignment: largerThanMobile ? CrossAxisAlignment.center : CrossAxisAlignment.start,
      children: [
        SizedBox(height: AgoraSpacings.base),
        Lottie.asset(
          'assets/animations/consultation_success.json',
          width: MediaQuery.sizeOf(context).width,
          height: 200,
          repeat: false,
          fit: BoxFit.fitHeight,
        ),
        Padding(
          padding: const EdgeInsets.all(AgoraSpacings.horizontalPadding),
          child: Column(
            crossAxisAlignment: largerThanMobile ? CrossAxisAlignment.center : CrossAxisAlignment.start,
            children: [
              Semantics(
                focused: true,
                child: Text(
                  ConsultationStrings.confirmationTitle,
                  style: AgoraTextStyles.medium19,
                  textAlign: largerThanMobile ? TextAlign.center : TextAlign.start,
                ),
              ),
              SizedBox(height: AgoraSpacings.base),
              Text(
                ConsultationStrings.confirmationDescription,
                style: AgoraTextStyles.light16,
                textAlign: largerThanMobile ? TextAlign.center : TextAlign.start,
              ),
              SizedBox(height: AgoraSpacings.x1_5),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Flexible(
                    child: AgoraButton(
                      label: ConsultationStrings.goToResult,
                      style: AgoraButtonStyle.primaryButtonStyle,
                      onPressed: () {
                        TrackerHelper.trackClick(
                          clickName: "${AnalyticsEventNames.goToResult} $consultationId",
                          widgetName: AnalyticsScreenNames.consultationQuestionConfirmationPage,
                        );
                        Navigator.pushNamed(
                          context,
                          ConsultationSummaryPage.routeName,
                          arguments: ConsultationSummaryArguments(
                            consultationId: consultationId,
                            initialTab: ConsultationSummaryInitialTab.results,
                          ),
                        );
                      },
                    ),
                  ),
                  SizedBox(width: AgoraSpacings.base),
                  AgoraButton(
                    label: ConsultationStrings.share,
                    icon: "ic_share.svg",
                    style: AgoraButtonStyle.blueBorderButtonStyle,
                    onPressed: () async {
                      TrackerHelper.trackClick(
                        clickName: "${AnalyticsEventNames.shareConsultation} $consultationId",
                        widgetName: AnalyticsScreenNames.consultationQuestionConfirmationPage,
                      );
                      ShareHelper.shareConsultation(context: context, title: consultationTitle, id: consultationId);
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  bool _shouldDisplayDemographicQuiz(SendConsultationQuestionsResponsesState state) {
    return state is SendConsultationQuestionsResponsesSuccessState && state.shouldDisplayDemographicInformation;
  }
}
