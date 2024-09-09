import 'package:agora/common/analytics/analytics_event_names.dart';
import 'package:agora/common/analytics/analytics_screen_names.dart';
import 'package:agora/common/extension/string_extension.dart';
import 'package:agora/common/helper/tracker_helper.dart';
import 'package:agora/common/strings/qag_strings.dart';
import 'package:agora/design/custom_view/agora_consultation_result_bar.dart';
import 'package:agora/design/custom_view/button/agora_button.dart';
import 'package:agora/design/custom_view/error/agora_error_text.dart';
import 'package:agora/design/style/agora_colors.dart';
import 'package:agora/design/style/agora_spacings.dart';
import 'package:agora/design/style/agora_text_styles.dart';
import 'package:agora/qag/details/bloc/qag_details_bloc.dart';
import 'package:agora/qag/details/bloc/qag_details_event.dart';
import 'package:agora/qag/details/bloc/qag_details_state.dart';
import 'package:agora/qag/details/bloc/qag_details_view_model.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lottie/lottie.dart';

class QagDetailsFeedbackWidget extends StatelessWidget {
  final void Function() onFeedbackSent;

  const QagDetailsFeedbackWidget({super.key, required this.onFeedbackSent});

  @override
  Widget build(BuildContext context) {
    return BlocSelector<QagDetailsBloc, QagDetailsState, _ViewModel?>(
      selector: _ViewModel.fromState,
      builder: (context, viewModel) {
        return viewModel is _DisplayedViewModel
            ? Container(
                color: AgoraColors.background,
                padding: const EdgeInsets.only(
                  left: AgoraSpacings.horizontalPadding,
                  right: AgoraSpacings.horizontalPadding,
                  bottom: AgoraSpacings.horizontalPadding,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Semantics(
                      header: true,
                      child: Text(viewModel.viewModel.feedbackQuestion, style: AgoraTextStyles.medium18),
                    ),
                    SizedBox(height: AgoraSpacings.base),
                    _Content(viewModel.qagId, viewModel.viewModel, onFeedbackSent),
                  ],
                ),
              )
            : SizedBox();
      },
    );
  }
}

class _Content extends StatelessWidget {
  final String qagId;
  final QagDetailsFeedbackViewModel viewModel;
  final void Function() onFeedbackSent;

  const _Content(this.qagId, this.viewModel, this.onFeedbackSent);

  @override
  Widget build(BuildContext context) {
    return switch (viewModel) {
      QagDetailsFeedbackErrorViewModel _ => _Error(),
      final QagDetailsFeedbackLoadingViewModel loadingVm =>
        _NotAnswered(qagId, loadingVm.isHelpfulClicked, onFeedbackSent),
      QagDetailsFeedbackNotAnsweredViewModel _ => _NotAnswered(qagId, null, onFeedbackSent),
      final QagDetailsFeedbackAnsweredNoResultsViewModel vm => _AnsweredNoResults(vm),
      final QagDetailsFeedbackAnsweredResultsViewModel vm => _AnsweredResults(vm)
    };
  }
}

class _Error extends StatelessWidget {
  const _Error();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: AgoraSpacings.base),
        AgoraErrorText(),
      ],
    );
  }
}

class _AnsweredResults extends StatelessWidget {
  final QagDetailsFeedbackAnsweredResultsViewModel viewModel;

  const _AnsweredResults(this.viewModel);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Semantics(
          focusable: true,
          focused: true,
          child: AgoraConsultationResultBar(
            participantsPercentage: viewModel.feedbackResults.positiveRatio,
            response: QagStrings.utils,
            isUserResponse: viewModel.userResponse == true,
            minusPadding: AgoraSpacings.horizontalPadding * 2,
          ),
        ),
        SizedBox(height: AgoraSpacings.x0_75),
        AgoraConsultationResultBar(
          participantsPercentage: viewModel.feedbackResults.negativeRatio,
          response: QagStrings.notUtils,
          isUserResponse: viewModel.userResponse == false,
          minusPadding: AgoraSpacings.horizontalPadding * 2,
        ),
        SizedBox(height: AgoraSpacings.x1_5),
        Row(
          children: [
            SvgPicture.asset("assets/ic_person.svg", excludeFromSemantics: true),
            SizedBox(width: AgoraSpacings.x0_5),
            Text(
              QagStrings.feedbackAnswerCount.format(viewModel.feedbackResults.count.toString()),
              style: AgoraTextStyles.light14,
            ),
          ],
        ),
        const SizedBox(height: AgoraSpacings.base),
        Align(
          alignment: Alignment.centerLeft,
          child: AgoraButton.withLabel(
            label: 'Modifier votre réponse',
            buttonStyle: AgoraButtonStyle.secondary,
            onPressed: () {
              context.read<QagDetailsBloc>().add(EditFeedbackQagDetailsEvent());
            },
          ),
        ),
      ],
    );
  }
}

class _AnsweredNoResults extends StatelessWidget {
  final QagDetailsFeedbackAnsweredNoResultsViewModel viewModel;

  const _AnsweredNoResults(this.viewModel);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(QagStrings.feedback, style: AgoraTextStyles.regular14),
        const SizedBox(height: AgoraSpacings.base),
        AgoraButton.withLabel(
          label: 'Modifier votre réponse',
          buttonStyle: AgoraButtonStyle.secondary,
          onPressed: () {
            context.read<QagDetailsBloc>().add(EditFeedbackQagDetailsEvent());
          },
        ),
        const SizedBox(height: AgoraSpacings.x0_5),
        Text(
          'Pour rappel, vous avez répondu "${viewModel.userResponse == true ? 'Oui' : 'Non'}".',
          style: AgoraTextStyles.light14,
        ),
      ],
    );
  }
}

class _NotAnswered extends StatelessWidget {
  final String qagId;
  final bool? isHelpfulClicked;
  final void Function() onFeedbackSent;

  const _NotAnswered(this.qagId, this.isHelpfulClicked, this.onFeedbackSent);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        if (isHelpfulClicked == null) ...[
          AgoraButton.withLabel(
            prefixIcon: "ic_thumb_white.svg",
            label: QagStrings.utils,
            onPressed: () {
              Future.delayed(Duration(milliseconds: 2500)).then((_) => onFeedbackSent());
              if (isHelpfulClicked == null) {
                _trackFeedback(qagId);
                context.read<QagDetailsBloc>().add(SendFeedbackQagDetailsEvent(qagId: qagId, isHelpful: true));
              }
            },
          ),
          SizedBox(width: AgoraSpacings.base),
          AgoraButton.withLabel(
            prefixIcon: "ic_thumb_down_white.svg",
            label: QagStrings.notUtils,
            onPressed: () {
              Future.delayed(Duration(milliseconds: 2500)).then((_) => onFeedbackSent());
              if (isHelpfulClicked == null) {
                _trackFeedback(qagId);
                context.read<QagDetailsBloc>().add(SendFeedbackQagDetailsEvent(qagId: qagId, isHelpful: false));
              }
            },
          ),
        ],
        if (isHelpfulClicked != null)
          Expanded(
            child: Lottie.asset(
              'assets/animations/check.json',
              width: 48,
              height: 48,
            ),
          ),
      ],
    );
  }
}

void _trackFeedback(String qagId) {
  TrackerHelper.trackClick(
    clickName: "${AnalyticsEventNames.giveQagFeedback} $qagId",
    widgetName: AnalyticsScreenNames.qagDetailsPage,
  );
}

abstract class _ViewModel extends Equatable {
  _ViewModel();

  factory _ViewModel.fromState(QagDetailsState state) {
    if (state is QagDetailsFetchedState && state.viewModel.feedback != null) {
      return _DisplayedViewModel(
        qagId: state.viewModel.id,
        viewModel: state.viewModel.feedback!,
      );
    }
    return _HiddenViewModel();
  }
}

class _HiddenViewModel extends _ViewModel {
  @override
  List<Object?> get props => [];
}

class _DisplayedViewModel extends _ViewModel {
  final String qagId;
  final QagDetailsFeedbackViewModel viewModel;

  _DisplayedViewModel({required this.qagId, required this.viewModel});

  @override
  List<Object?> get props => [qagId, viewModel];
}
