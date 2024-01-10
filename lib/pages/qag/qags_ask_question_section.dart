import 'package:agora/bloc/qag/ask_qag/ask_qag_status_bloc.dart';
import 'package:agora/bloc/qag/ask_qag/ask_qag_status_state.dart';
import 'package:agora/common/analytics/analytics_event_names.dart';
import 'package:agora/common/analytics/analytics_screen_names.dart';
import 'package:agora/common/helper/tracker_helper.dart';
import 'package:agora/common/strings/qag_strings.dart';
import 'package:agora/design/custom_view/agora_rich_text.dart';
import 'package:agora/design/custom_view/button/agora_rounded_button.dart';
import 'package:agora/design/custom_view/skeletons.dart';
import 'package:agora/design/style/agora_spacings.dart';
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
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: AgoraRichText(
                      items: [
                        AgoraRichTextItem(text: "${QagStrings.allQagPart1}\n", style: AgoraRichTextItemStyle.regular),
                        AgoraRichTextItem(text: QagStrings.allQagPart2, style: AgoraRichTextItemStyle.bold),
                      ],
                    ),
                  ),
                  _buildAskQagButton(context, viewModel),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildAskQagButton(BuildContext context, _ViewModel viewModel) {
    return switch (viewModel) {
      _AskQagStatusLoadingViewModel _ => SkeletonBox(
          width: 100,
          height: 30,
          radius: 20,
        ),
      _AskQagStatusEnabledViewModel _ => AgoraRoundedButton(
          label: QagStrings.askQuestion,
          onPressed: () {
            TrackerHelper.trackClick(
              clickName: AnalyticsEventNames.askQuestion,
              widgetName: AnalyticsScreenNames.qagsPage,
            );
            Navigator.pushNamed(
              context,
              QagAskQuestionPage.routeName,
              arguments: viewModel.askQagErrorText,
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
