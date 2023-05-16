import 'package:agora/bloc/demographic/stock/demographic_responses_stock_bloc.dart';
import 'package:agora/bloc/demographic/stock/demographic_responses_stock_event.dart';
import 'package:agora/bloc/demographic/stock/demographic_responses_stock_state.dart';
import 'package:agora/common/extension/demographic_question_type_extension.dart';
import 'package:agora/common/extension/string_extension.dart';
import 'package:agora/common/strings/demographic_strings.dart';
import 'package:agora/design/custom_view/agora_questions_progress_bar.dart';
import 'package:agora/design/custom_view/agora_scaffold.dart';
import 'package:agora/design/custom_view/agora_single_scroll_view.dart';
import 'package:agora/design/style/agora_colors.dart';
import 'package:agora/design/style/agora_spacings.dart';
import 'package:agora/design/style/agora_text_styles.dart';
import 'package:agora/domain/demographic/demographic_question_type.dart';
import 'package:agora/domain/demographic/demographic_response.dart';
import 'package:agora/pages/consultation/summary/consultation_summary_page.dart';
import 'package:agora/pages/demographic/demographic_helper.dart';
import 'package:agora/pages/demographic/demographic_response_helper.dart';
import 'package:agora/pages/demographic/question_view/demographic_birth_view.dart';
import 'package:agora/pages/demographic/question_view/demographic_common_view.dart';
import 'package:agora/pages/demographic/question_view/demographic_department_view.dart';
import 'package:agora/pages/demographic/question_view/demographic_vote_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DemographicQuestionPage extends StatefulWidget {
  static const routeName = "/demographicQuestionPage";

  @override
  State<DemographicQuestionPage> createState() => _DemographicQuestionPageState();
}

class _DemographicQuestionPageState extends State<DemographicQuestionPage> {
  final int totalStep = 6;
  int currentStep = 1;
  String? consultationId;

  @override
  Widget build(BuildContext context) {
    consultationId = ModalRoute.of(context)!.settings.arguments as String?;
    return MultiBlocProvider(
      providers: [
        BlocProvider<DemographicResponsesStockBloc>(
          create: (BuildContext context) => DemographicResponsesStockBloc(),
        ),
      ],
      child: AgoraScaffold(
        shouldPop: false,
        child: BlocBuilder<DemographicResponsesStockBloc, DemographicResponsesStockState>(
          builder: (context, responsesStockState) {
            return AgoraSingleScrollView(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: AgoraSpacings.x0_75,
                      horizontal: AgoraSpacings.horizontalPadding,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AgoraQuestionsProgressBar(
                          currentQuestionOrder: currentStep,
                          totalQuestions: totalStep,
                        ),
                        SizedBox(height: AgoraSpacings.x0_75),
                        Text(
                          DemographicStrings.profileStep.format2(currentStep.toString(), totalStep.toString()),
                          style: AgoraTextStyles.medium16,
                        ),
                        SizedBox(height: AgoraSpacings.base),
                        Text(
                          DemographicHelper.getQuestionTitle(currentStep),
                          style: AgoraTextStyles.medium20.copyWith(color: AgoraColors.primaryGreen),
                        ),
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
                          children: [_buildResponseSection(context, currentStep, responsesStockState.responses)] +
                              DemographicHelper.buildBackButton(
                                step: currentStep,
                                onBackTap: () => setState(() => currentStep--),
                              ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
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
          responseChoices: DemographicResponseHelper.question1ResponseChoice(),
          onContinuePressed: (responseCode) {
            setState(() {
              _stockResponse(context, DemographicQuestionType.gender, responseCode);
              _nextStep();
            });
          },
          onIgnorePressed: () => setState(() => _nextStep()),
          oldResponse: _getOldResponse(DemographicQuestionType.gender, oldResponses),
        );
      case 2:
        final oldResponse = _getOldResponse(DemographicQuestionType.yearOfBirth, oldResponses);
        return DemographicBirthView(
          onContinuePressed: (String inputYear) {
            setState(() {
              _stockResponse(context, DemographicQuestionType.yearOfBirth, inputYear);
              _nextStep();
            });
          },
          onIgnorePressed: () => setState(() => _nextStep()),
          controller: oldResponse != null ? TextEditingController(text: oldResponse.response) : null,
          oldResponse: oldResponse?.response,
        );
      case 3:
        return DemographicDepartmentView(
          onContinuePressed: (departmentCode) {
            setState(() {
              _stockResponse(context, DemographicQuestionType.department, departmentCode);
              _nextStep();
            });
          },
          onIgnorePressed: () => setState(() => _nextStep()),
        );
      case 4:
        return DemographicCommonView(
          responseChoices: DemographicResponseHelper.question4ResponseChoice(),
          onContinuePressed: (responseCode) {
            setState(() {
              _stockResponse(context, DemographicQuestionType.cityType, responseCode);
              _nextStep();
            });
          },
          onIgnorePressed: () => setState(() => _nextStep()),
          oldResponse: _getOldResponse(DemographicQuestionType.cityType, oldResponses),
        );
      case 5:
        return DemographicCommonView(
          responseChoices: DemographicResponseHelper.question5ResponseChoice(),
          onContinuePressed: (responseCode) {
            setState(() {
              _stockResponse(context, DemographicQuestionType.jobCategory, responseCode);
              _nextStep();
            });
          },
          onIgnorePressed: () => setState(() => _nextStep()),
          oldResponse: _getOldResponse(DemographicQuestionType.jobCategory, oldResponses),
        );
      case 6:
        return DemographicVoteView(
          responseChoices: DemographicResponseHelper.question6ResponseChoice(),
          onContinuePressed: (
            String? voteFrequencyCode,
            String? publicMeetingFrequencyCode,
            String? consultationFrequencyCode,
          ) {
            setState(() {
              if (voteFrequencyCode != null) {
                _stockResponse(context, DemographicQuestionType.voteFrequency, voteFrequencyCode);
              }
              if (publicMeetingFrequencyCode != null) {
                _stockResponse(context, DemographicQuestionType.publicMeetingFrequency, publicMeetingFrequencyCode);
              }
              if (consultationFrequencyCode != null) {
                _stockResponse(context, DemographicQuestionType.consultationFrequency, consultationFrequencyCode);
              }
              _nextStep();
            });
          },
          onIgnorePressed: () => setState(() => _nextStep()),
        );
      default:
        throw Exception("Demographic response step not exists error");
    }
  }

  void _nextStep() {
    if (currentStep == totalStep) {
      if (consultationId != null) {
        Navigator.pushNamed(
          context,
          ConsultationSummaryPage.routeName,
          arguments: consultationId,
        );
      } else {
        // TODO navigate to profile
      }
    } else {
      currentStep++;
    }
  }

  void _stockResponse(BuildContext context, DemographicQuestionType questionType, String responseCode) {
    context.read<DemographicResponsesStockBloc>().add(
          AddDemographicResponseStockEvent(
            response: DemographicResponse(
              question: questionType.toTypeString(),
              response: responseCode,
            ),
          ),
        );
  }

  DemographicResponse? _getOldResponse(DemographicQuestionType questionType, List<DemographicResponse> oldResponses) {
    try {
      return oldResponses.firstWhere((oldResponse) => oldResponse.question == questionType.toTypeString());
    } catch (e) {
      return null;
    }
  }
}
