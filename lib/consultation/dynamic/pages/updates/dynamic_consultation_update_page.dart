import 'package:agora/consultation/dynamic/bloc/dynamic_consultation_events.dart';
import 'package:agora/consultation/dynamic/bloc/updates/dynamic_consultation_update_state.dart';
import 'package:agora/consultation/dynamic/bloc/updates/dynamic_consultation_updates_bloc.dart';
import 'package:agora/common/extension/date_extension.dart';
import 'package:agora/common/manager/repository_manager.dart';
import 'package:agora/common/strings/consultation_strings.dart';
import 'package:agora/design/custom_view/agora_error_text.dart';
import 'package:agora/design/custom_view/agora_scaffold.dart';
import 'package:agora/design/custom_view/agora_toolbar.dart';
import 'package:agora/design/style/agora_spacings.dart';
import 'package:agora/consultation/dynamic/domain/dynamic_consultation.dart';
import 'package:agora/consultation/dynamic/pages/dynamic_consultation_page.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'dynamic_consultation_update_presenter.dart';
part 'dynamic_consultation_update_view_model.dart';

class DynamicConsultationUpdateArguments {
  final String consultationId;
  final String updateId;

  DynamicConsultationUpdateArguments({
    required this.consultationId,
    required this.updateId,
  });
}

class DynamicConsultationUpdatePage extends StatelessWidget {
  static const routeName = '/consultation/dynamic/update';

  final DynamicConsultationUpdateArguments arguments;

  DynamicConsultationUpdatePage(this.arguments);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) {
        return DynamicConsultationUpdatesBloc(
          RepositoryManager.getConsultationRepository(),
        )..add(
            FetchDynamicConsultationUpdateEvent(
              arguments.updateId,
              arguments.consultationId,
            ),
          );
      },
      child: BlocSelector<DynamicConsultationUpdatesBloc, DynamicConsultationUpdatesState, _ViewModel>(
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
          AgoraToolbar(pageLabel: ConsultationStrings.summaryTabPresentation),
          SizedBox(height: MediaQuery.of(context).size.height / 10 * 4),
          Center(child: AgoraErrorText()),
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
          AgoraToolbar(pageLabel: ConsultationStrings.summaryTabResult),
          Expanded(
            child: ListView.builder(
              itemCount: viewModel.sections.length + 1,
              itemBuilder: (BuildContext context, int index) {
                if (index == viewModel.sections.length) return SizedBox(height: AgoraSpacings.x2);
                return DynamicConsultationSectionWidget(viewModel.sections[index]);
              },
            ),
          ),
        ],
      ),
    );
  }
}
