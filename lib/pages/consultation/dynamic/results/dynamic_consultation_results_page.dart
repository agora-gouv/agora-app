import 'package:agora/bloc/consultation/dynamic/dynamic_consultation_events.dart';
import 'package:agora/bloc/consultation/dynamic/responses/dynamic_consultation_results_state.dart';
import 'package:agora/bloc/consultation/dynamic/responses/dynamic_consultations_results_bloc.dart';
import 'package:agora/bloc/consultation/summary/consultation_summary_view_model.dart';
import 'package:agora/common/manager/repository_manager.dart';
import 'package:agora/common/strings/consultation_strings.dart';
import 'package:agora/design/custom_view/agora_consultation_result_view.dart';
import 'package:agora/design/custom_view/agora_error_view.dart';
import 'package:agora/design/custom_view/agora_scaffold.dart';
import 'package:agora/design/custom_view/agora_toolbar.dart';
import 'package:agora/design/style/agora_colors.dart';
import 'package:agora/design/style/agora_spacings.dart';
import 'package:agora/design/style/agora_text_styles.dart';
import 'package:agora/domain/consultation/summary/consultation_summary_results.dart';
import 'package:agora/pages/consultation/dynamic/dynamic_consultation_page.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

part 'dynamic_consultation_results_presenter.dart';

part 'dynamic_consultation_results_view_model.dart';

class DynamicConsultationResultsPage extends StatelessWidget {
  static const routeName = '/consultation/dynamic/results';

  final String id;

  DynamicConsultationResultsPage(this.id);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) {
        return DynamicConsultationResultsBloc(
          RepositoryManager.getConsultationRepository(),
        )..add(FetchDynamicConsultationResultsEvent(id));
      },
      child: BlocSelector<DynamicConsultationResultsBloc, DynamicConsultationResultsState, _ViewModel>(
        selector: _Presenter.getViewModelFromState,
        builder: (BuildContext context, _ViewModel viewModel) {
          return switch (viewModel) {
            _LoadingViewModel() => _LoadingPage(),
            _ErrorViewModel() => _ErrorPage(),
            _SuccessViewModel() => _SuccessPage(viewModel),
          };
        },
      ),
    );
  }
}

class _ErrorPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AgoraScaffold(
      child: Column(
        children: [
          AgoraToolbar(pageLabel: ConsultationStrings.summaryTabResult),
          SizedBox(height: MediaQuery.of(context).size.height / 10 * 4),
          Center(child: AgoraErrorView()),
        ],
      ),
    );
  }
}

class _LoadingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AgoraScaffold(
      child: Center(
        child: Column(
          children: [
            AgoraToolbar(pageLabel: ConsultationStrings.summaryTabResult),
            SizedBox(height: MediaQuery.of(context).size.height / 10 * 4),
            CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
}

class _SuccessPage extends StatelessWidget {
  final _SuccessViewModel viewModel;

  _SuccessPage(this.viewModel);

  @override
  Widget build(BuildContext context) {
    return AgoraScaffold(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.max,
        children: [
          AgoraToolbar(pageLabel: ConsultationStrings.consultationResultsPageTitle),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: AgoraSpacings.horizontalPadding),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    HeaderSectionUpdateWidget(
                      HeaderSectionUpdate(
                        coverUrl: viewModel.coverUrl,
                        title: viewModel.title,
                      ),
                      0.0,
                    ),
                    const SizedBox(height: AgoraSpacings.base),
                    Semantics(
                      header: true,
                      child: Text(
                        'Réponses des participants',
                        style: AgoraTextStyles.medium18.copyWith(
                          color: AgoraColors.primaryBlue,
                        ),
                      ),
                    ),
                    const SizedBox(height: AgoraSpacings.base),
                    Row(
                      children: [
                        SvgPicture.asset("assets/ic_person.svg", excludeFromSemantics: true),
                        SizedBox(width: AgoraSpacings.x0_5),
                        Text('${viewModel.participantCount} participants', style: AgoraTextStyles.light14),
                      ],
                    ),
                    const SizedBox(height: AgoraSpacings.base),
                    ...viewModel.results.map(
                      (result) {
                        if (result is ConsultationSummaryUniqueChoiceResultsViewModel) {
                          return AgoraConsultationResultView(
                            questionTitle: result.questionTitle,
                            responses: result.responses,
                            isMultipleChoice: false,
                          );
                        } else if (result is ConsultationSummaryMultipleChoicesResultsViewModel) {
                          return AgoraConsultationResultView(
                            questionTitle: result.questionTitle,
                            responses: result.responses,
                            isMultipleChoice: true,
                          );
                        } else {
                          throw Exception("Results view model doesn't exists $result");
                        }
                      },
                    ),
                    Text(ConsultationStrings.summaryInformation, style: AgoraTextStyles.light14),
                    const SizedBox(height: AgoraSpacings.x1_5),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
