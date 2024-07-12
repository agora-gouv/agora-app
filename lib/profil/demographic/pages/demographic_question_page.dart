import 'package:agora/profil/demographic/bloc/stock/demographic_responses_stock_bloc.dart';
import 'package:agora/profil/demographic/bloc/stock/demographic_responses_stock_event.dart';
import 'package:agora/profil/demographic/bloc/stock/demographic_responses_stock_state.dart';
import 'package:agora/common/analytics/analytics_event_names.dart';
import 'package:agora/common/analytics/analytics_screen_names.dart';
import 'package:agora/common/extension/string_extension.dart';
import 'package:agora/common/helper/tracker_helper.dart';
import 'package:agora/common/strings/demographic_strings.dart';
import 'package:agora/common/strings/semantics_strings.dart';
import 'package:agora/design/custom_view/agora_questions_progress_bar.dart';
import 'package:agora/design/custom_view/agora_scaffold.dart';
import 'package:agora/design/custom_view/scroll/agora_single_scroll_view.dart';
import 'package:agora/design/custom_view/agora_toolbar.dart';
import 'package:agora/design/style/agora_colors.dart';
import 'package:agora/design/style/agora_spacings.dart';
import 'package:agora/design/style/agora_text_styles.dart';
import 'package:agora/profil/demographic/domain/demographic_information.dart';
import 'package:agora/profil/demographic/domain/demographic_question_type.dart';
import 'package:agora/profil/demographic/domain/demographic_response.dart';
import 'package:agora/profil/demographic/pages/demographic_confirmation_page.dart';
import 'package:agora/profil/demographic/pages/helpers/demographic_helper.dart';
import 'package:agora/profil/demographic/pages/helpers/demographic_response_helper.dart';
import 'package:agora/profil/demographic/pages/question_view/demographic_birth_view.dart';
import 'package:agora/profil/demographic/pages/question_view/demographic_common_view.dart';
import 'package:agora/profil/demographic/pages/question_view/demographic_department_view.dart';
import 'package:agora/profil/demographic/pages/question_view/demographic_vote_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

sealed class DemographicQuestionArguments {}

class DemographicQuestionArgumentsFromQuestion extends DemographicQuestionArguments {
  final String consultationId;
  final String consultationTitle;

  DemographicQuestionArgumentsFromQuestion({required this.consultationId, required this.consultationTitle});
}

class DemographicQuestionArgumentsFromModify extends DemographicQuestionArguments {
  final List<DemographicInformation> demographicInformations;

  DemographicQuestionArgumentsFromModify(this.demographicInformations);
}

class DemographicQuestionPage extends StatefulWidget {
  static const routeName = "/demographicQuestionPage";

  @override
  State<DemographicQuestionPage> createState() => _DemographicQuestionPageState();
}

class _DemographicQuestionPageState extends State<DemographicQuestionPage> {
  final int totalStep = 6;
  int currentStep = 1;
  DemographicQuestionArguments? arguments;

  @override
  Widget build(BuildContext context) {
    arguments = ModalRoute.of(context)!.settings.arguments as DemographicQuestionArguments?;
    return BlocProvider<DemographicResponsesStockBloc>(
      create: (BuildContext context) => DemographicResponsesStockBloc(arguments),
      child: AgoraScaffold(
        popAction: () {
          if (currentStep == 1) {
            return true;
          } else {
            setState(() => currentStep--);
            return false;
          }
        },
        child: BlocBuilder<DemographicResponsesStockBloc, DemographicResponsesStockState>(
          builder: (context, responsesStockState) {
            return Column(
              children: [
                AgoraToolbar(
                  style: AgoraToolbarStyle.close,
                  pageLabel: 'Modifier mes informations',
                ),
                Expanded(
                  child: AgoraSingleScrollView(
                    physics: BouncingScrollPhysics(),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: AgoraSpacings.horizontalPadding,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              AgoraQuestionsProgressBar(
                                currentQuestionIndex: currentStep,
                                totalQuestions: totalStep,
                              ),
                              SizedBox(height: AgoraSpacings.x0_75),
                              Text(
                                DemographicStrings.profileStep.format2(currentStep.toString(), totalStep.toString()),
                                style: AgoraTextStyles.medium16,
                                semanticsLabel: SemanticsStrings.profileStep.format2(
                                  currentStep.toString(),
                                  totalStep.toString(),
                                ),
                              ),
                              SizedBox(height: AgoraSpacings.base),
                              Semantics(
                                header: true,
                                child: Text(
                                  DemographicHelper.getQuestionTitle(currentStep),
                                  style: AgoraTextStyles.medium20.copyWith(color: AgoraColors.primaryBlue),
                                ),
                              ),
                              SizedBox(height: AgoraSpacings.x0_75),
                            ],
                          ),
                        ),
                        Flexible(
                          child: Container(
                            width: double.infinity,
                            color: AgoraColors.background,
                            child: Padding(
                              padding: const EdgeInsets.all(AgoraSpacings.horizontalPadding),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  _buildResponseSection(context, currentStep, responsesStockState.responses),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildResponseSection(BuildContext context, int step, List<DemographicResponse> oldResponses) {
    switch (step) {
      case 1:
        return DemographicCommonView(
          step: currentStep,
          totalStep: totalStep,
          responseChoices: DemographicResponseHelper.question1ResponseChoice(),
          onContinuePressed: () => setState(() {
            _trackContinueClick(step);
            _nextStep(context);
          }),
          onResponseChosed: (responseCode) => setState(() {
            _stockResponse(context, DemographicQuestionType.gender, responseCode);
          }),
          onIgnorePressed: () => setState(() {
            _trackIgnoreClick(step);
            _deleteResponse(context, DemographicQuestionType.gender);
            _nextStep(context);
          }),
          onBackPressed: _onBackClick,
          oldResponse: _getOldResponse(DemographicQuestionType.gender, oldResponses),
        );
      case 2:
        final oldResponse = _getOldResponse(DemographicQuestionType.yearOfBirth, oldResponses);
        return DemographicBirthView(
          step: currentStep,
          totalStep: totalStep,
          onContinuePressed: (String inputYear) => setState(() {
            _trackContinueClick(step);
            _stockResponse(context, DemographicQuestionType.yearOfBirth, inputYear);
            _nextStep(context);
          }),
          onIgnorePressed: () => setState(() {
            _trackIgnoreClick(step);
            _deleteResponse(context, DemographicQuestionType.yearOfBirth);
            _nextStep(context);
          }),
          onBackPressed: _onBackClick,
          controller: oldResponse != null ? TextEditingController(text: oldResponse.response) : null,
        );
      case 3:
        return DemographicDepartmentView(
          step: currentStep,
          totalStep: totalStep,
          oldResponse: _getOldResponse(DemographicQuestionType.department, oldResponses),
          onContinuePressed: (departmentCode) => setState(() {
            _trackContinueClick(step);
            _stockResponse(context, DemographicQuestionType.department, departmentCode);
            _nextStep(context);
          }),
          onIgnorePressed: () => setState(() {
            _trackIgnoreClick(step);
            _deleteResponse(context, DemographicQuestionType.department);
            _nextStep(context);
          }),
          onBackPressed: _onBackClick,
        );
      case 4:
        return DemographicCommonView(
          step: currentStep,
          totalStep: totalStep,
          responseChoices: DemographicResponseHelper.question4ResponseChoice(),
          onContinuePressed: () => setState(() {
            _trackContinueClick(step);
            _nextStep(context);
          }),
          onResponseChosed: (responseCode) => setState(() {
            _stockResponse(context, DemographicQuestionType.cityType, responseCode);
          }),
          onIgnorePressed: () => setState(() {
            _trackIgnoreClick(step);
            _deleteResponse(context, DemographicQuestionType.cityType);
            _nextStep(context);
          }),
          onBackPressed: _onBackClick,
          oldResponse: _getOldResponse(DemographicQuestionType.cityType, oldResponses),
        );
      case 5:
        return DemographicCommonView(
          step: currentStep,
          totalStep: totalStep,
          responseChoices: DemographicResponseHelper.question5ResponseChoice(),
          onContinuePressed: () => setState(() {
            _trackContinueClick(step);
            _nextStep(context);
          }),
          onResponseChosed: (responseCode) => setState(() {
            _stockResponse(context, DemographicQuestionType.jobCategory, responseCode);
          }),
          onIgnorePressed: () => setState(() {
            _trackIgnoreClick(step);
            _deleteResponse(context, DemographicQuestionType.jobCategory);
            _nextStep(context);
          }),
          onBackPressed: _onBackClick,
          oldResponse: _getOldResponse(DemographicQuestionType.jobCategory, oldResponses),
          showWhatAbout: true,
          whatAboutText: DemographicStrings.question5WhatAbout,
        );
      case 6:
        return DemographicVoteView(
          step: currentStep,
          totalStep: totalStep,
          responseChoices: DemographicResponseHelper.question6ResponseChoice(),
          oldResponses: oldResponses,
          onContinuePressed: (voteFrequencyCode, publicMeetingFrequencyCode, consultationFrequencyCode) => setState(() {
            _trackContinueClick(step);
            if (voteFrequencyCode != null) {
              _stockResponse(context, DemographicQuestionType.voteFrequency, voteFrequencyCode);
            }
            if (publicMeetingFrequencyCode != null) {
              _stockResponse(context, DemographicQuestionType.publicMeetingFrequency, publicMeetingFrequencyCode);
            }
            if (consultationFrequencyCode != null) {
              _stockResponse(context, DemographicQuestionType.consultationFrequency, consultationFrequencyCode);
            }
            _nextStep(context);
          }),
          onIgnorePressed: () => setState(() {
            _trackIgnoreClick(step);
            _deleteResponse(context, DemographicQuestionType.voteFrequency);
            _deleteResponse(context, DemographicQuestionType.publicMeetingFrequency);
            _deleteResponse(context, DemographicQuestionType.consultationFrequency);
            _nextStep(context);
          }),
          onBackPressed: _onBackClick,
        );
      default:
        throw Exception("Demographic response step not exists error");
    }
  }

  void _trackContinueClick(int step) {
    TrackerHelper.trackClick(
      clickName: AnalyticsEventNames.answerDemographicQuestion.format("$step / $totalStep"),
      widgetName: AnalyticsScreenNames.demographicQuestionPage,
    );
  }

  void _trackIgnoreClick(int step) {
    TrackerHelper.trackClick(
      clickName: AnalyticsEventNames.ignoreDemographicQuestion.format("$step / $totalStep"),
      widgetName: AnalyticsScreenNames.demographicQuestionPage,
    );
  }

  void _trackBackClick() {
    TrackerHelper.trackClick(
      clickName: AnalyticsEventNames.backDemographicQuestion.format("$currentStep / $totalStep"),
      widgetName: AnalyticsScreenNames.demographicQuestionPage,
    );
  }

  void _onBackClick() {
    _trackBackClick();
    setState(() => currentStep--);
  }

  void _nextStep(BuildContext context) {
    if (currentStep == totalStep) {
      TrackerHelper.trackClick(
        clickName: AnalyticsEventNames.sendDemographic,
        widgetName: AnalyticsScreenNames.demographicQuestionPage,
      );
      final consultationId = arguments is DemographicQuestionArgumentsFromQuestion
          ? (arguments as DemographicQuestionArgumentsFromQuestion).consultationId
          : null;
      Navigator.pushNamed(
        context,
        DemographicConfirmationPage.routeName,
        arguments: DemographicConfirmationArguments(
          consultationId: consultationId,
          consultationTitle: arguments is DemographicQuestionArgumentsFromQuestion
              ? (arguments as DemographicQuestionArgumentsFromQuestion).consultationTitle
              : null,
          demographicResponsesStockBloc: context.read<DemographicResponsesStockBloc>(),
        ),
      ).then((value) {
        if (consultationId != null) {
          Navigator.pop(context);
        }
      });
    } else {
      currentStep++;
    }
  }

  void _stockResponse(BuildContext context, DemographicQuestionType demographicType, String responseCode) {
    context.read<DemographicResponsesStockBloc>().add(
          AddDemographicResponseStockEvent(
            response: DemographicResponse(
              demographicType: demographicType,
              response: responseCode,
            ),
          ),
        );
  }

  void _deleteResponse(BuildContext context, DemographicQuestionType demographicType) {
    context
        .read<DemographicResponsesStockBloc>()
        .add(DeleteDemographicResponseStockEvent(demographicType: demographicType));
  }

  DemographicResponse? _getOldResponse(
      DemographicQuestionType demographicType, List<DemographicResponse> oldResponses) {
    try {
      return oldResponses.firstWhere((oldResponse) => oldResponse.demographicType == demographicType);
    } catch (e) {
      return null;
    }
  }
}
