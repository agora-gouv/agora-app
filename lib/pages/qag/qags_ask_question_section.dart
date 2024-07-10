import 'package:agora/bloc/qag/ask_qag/ask_qag_status_bloc.dart';
import 'package:agora/bloc/qag/ask_qag/ask_qag_status_state.dart';
import 'package:agora/common/analytics/analytics_event_names.dart';
import 'package:agora/common/analytics/analytics_screen_names.dart';
import 'package:agora/common/helper/tracker_helper.dart';
import 'package:agora/common/strings/generic_strings.dart';
import 'package:agora/common/strings/qag_strings.dart';
import 'package:agora/common/strings/reponse_strings.dart';
import 'package:agora/common/strings/semantics_strings.dart';
import 'package:agora/design/custom_view/agora_alert_dialog.dart';
import 'package:agora/design/custom_view/agora_more_information.dart';
import 'package:agora/design/custom_view/agora_rich_text.dart';
import 'package:agora/design/custom_view/button/agora_button.dart';
import 'package:agora/design/custom_view/button/agora_rounded_button.dart';
import 'package:agora/design/custom_view/skeletons.dart';
import 'package:agora/design/style/agora_spacings.dart';
import 'package:agora/design/style/agora_text_styles.dart';
import 'package:agora/pages/qag/ask_question/qag_ask_question_page.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class QagsAskQuestionSectionPage extends StatelessWidget {
  const QagsAskQuestionSectionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocSelector<AskQagStatusBloc, AskQagStatusState, _ViewModel>(
      selector: _ViewModel.fromState,
      builder: (context, viewModel) {
        return Padding(
          padding: EdgeInsets.only(
            left: AgoraSpacings.horizontalPadding,
            top: AgoraSpacings.base,
            right: AgoraSpacings.horizontalPadding,
          ),
          child: Row(
            children: [
              Expanded(child: _TitreEtInfo()),
              Expanded(child: _PoserQuestionBouton(viewModel)),
            ],
          ),
        );
      },
    );
  }
}

class _TitreEtInfo extends StatelessWidget {
  const _TitreEtInfo();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Flexible(
          child: AgoraRichText(
            items: [
              AgoraRichTextItem(text: "${QagStrings.allQagPart1}\n", style: AgoraRichTextItemStyle.regular),
              AgoraRichTextItem(text: QagStrings.allQagPart2, style: AgoraRichTextItemStyle.bold),
            ],
          ),
        ),
        _InfoBouton(),
      ],
    );
  }
}

class _InfoBouton extends StatelessWidget {
  const _InfoBouton();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: AgoraSpacings.x0_5),
      child: AgoraMoreInformation(
        semanticsLabel: SemanticsStrings.moreInformationAboutGovernmentResponse,
        onClick: () {
          showAgoraDialog(
            context: context,
            columnChildren: [
              Text(ReponseStrings.qagResponseInfoBubble, style: AgoraTextStyles.light16),
              SizedBox(height: AgoraSpacings.x0_75),
              AgoraButton(
                label: GenericStrings.close,
                buttonStyle: AgoraButtonStyle.primary,
                onPressed: () => Navigator.pop(context),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _PoserQuestionBouton extends StatelessWidget {
  final _ViewModel viewModel;

  const _PoserQuestionBouton(this.viewModel);

  @override
  Widget build(BuildContext context) {
    return switch (viewModel) {
      _AskQagStatusLoadingViewModel _ => SkeletonBox(
          width: 100,
          height: 30,
          radius: 20,
        ),
      final _AskQagStatusEnabledViewModel vm => AgoraRoundedButton(
          label: QagStrings.askQuestion,
          onPressed: () {
            TrackerHelper.trackClick(
              clickName: AnalyticsEventNames.askQuestion,
              widgetName: AnalyticsScreenNames.qagsPage,
            );
            Navigator.pushNamed(
              context,
              QagAskQuestionPage.routeName,
              arguments: vm.askQagErrorText,
            );
          },
        ),
    };
  }
}

sealed class _ViewModel extends Equatable {
  static _ViewModel fromState(AskQagStatusState state) {
    return switch (state) {
      AskQagInitialLoadingState _ => _AskQagStatusLoadingViewModel(),
      AskQagErrorState _ => _AskQagStatusEnabledViewModel(askQagErrorText: null),
      final AskQagStatusFetchedState _ => _AskQagStatusEnabledViewModel(askQagErrorText: state.askQagError)
    };
  }

  @override
  List<Object?> get props => [];
}

class _AskQagStatusLoadingViewModel extends _ViewModel {}

class _AskQagStatusEnabledViewModel extends _ViewModel {
  final String? askQagErrorText;

  _AskQagStatusEnabledViewModel({required this.askQagErrorText});

  @override
  List<Object?> get props => [askQagErrorText];
}
