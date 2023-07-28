import 'package:agora/bloc/consultation/question/response/send/consultation_questions_responses_bloc.dart';
import 'package:agora/bloc/consultation/question/response/send/consultation_questions_responses_event.dart';
import 'package:agora/bloc/consultation/question/response/send/consultation_questions_responses_state.dart';
import 'package:agora/bloc/consultation/question/response/stock/consultation_questions_responses_stock_bloc.dart';
import 'package:agora/common/analytics/analytics_event_names.dart';
import 'package:agora/common/analytics/analytics_screen_names.dart';
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
import 'package:agora/design/style/agora_colors.dart';
import 'package:agora/design/style/agora_spacings.dart';
import 'package:agora/design/style/agora_text_styles.dart';
import 'package:agora/pages/consultation/details/consultation_details_page.dart';
import 'package:agora/pages/consultation/summary/consultation_summary_page.dart';
import 'package:agora/pages/demographic/demographic_information_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

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
              questionsStack: questionsResponsesStockState.questionsStack,
              questionsResponses: questionsResponsesStockState.questionsResponses,
            ),
          );
      },
      child: AgoraScaffold(
        shouldPop: false,
        appBarColor: AgoraColors.primaryBlue,
        child: BlocConsumer<ConsultationQuestionsResponsesBloc, SendConsultationQuestionsResponsesState>(
          listener: (context, state) {
            if (_shouldDisplayDemographicQuiz(state)) {
              Navigator.pushNamed(
                context,
                DemographicInformationPage.routeName,
                arguments: consultationId,
              );
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
      return Column(
        children: [
          _buildToolbar(context),
          SizedBox(height: MediaQuery.of(context).size.height / 10 * 4),
          Center(child: CircularProgressIndicator()),
        ],
      );
    } else {
      return Column(
        children: [
          _buildToolbar(context),
          SizedBox(height: MediaQuery.of(context).size.height / 10 * 4),
          Center(child: AgoraErrorView()),
        ],
      );
    }
  }

  Widget _buildToolbar(BuildContext context) {
    return AgoraToolbar(
      onBackClick: () => Navigator.popUntil(context, ModalRoute.withName(ConsultationDetailsPage.routeName)),
    );
  }

  Widget _buildContent(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: AgoraSpacings.base),
        SvgPicture.asset(
          "assets/ic_question_confirmation.svg",
          width: MediaQuery.of(context).size.width - AgoraSpacings.base,
        ),
        Padding(
          padding: const EdgeInsets.all(AgoraSpacings.horizontalPadding),
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
                          arguments: ConsultationSummaryArguments(consultationId: consultationId),
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
              )
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
