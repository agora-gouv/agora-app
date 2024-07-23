import 'package:agora/common/analytics/analytics_event_names.dart';
import 'package:agora/common/analytics/analytics_screen_names.dart';
import 'package:agora/common/extension/string_extension.dart';
import 'package:agora/common/helper/tracker_helper.dart';
import 'package:agora/common/strings/qag_strings.dart';
import 'package:agora/design/custom_view/agora_consultation_result_bar.dart';
import 'package:agora/design/custom_view/button/agora_button.dart';
import 'package:agora/design/custom_view/button/agora_rounded_button.dart';
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
        return viewModel is _DisplayedViewModel ? _buildContent(context, viewModel) : SizedBox();
      },
    );
  }

  Widget _buildContent(BuildContext context, _DisplayedViewModel viewModel) {
    return Container(
      color: AgoraColors.background,
      padding: const EdgeInsets.only(
        left: AgoraSpacings.horizontalPadding,
        right: AgoraSpacings.horizontalPadding,
        bottom: AgoraSpacings.horizontalPadding,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Semantics(header: true, child: Text(viewModel.viewModel.feedbackQuestion, style: AgoraTextStyles.medium18)),
          SizedBox(height: AgoraSpacings.base),
          _build(context, viewModel.qagId, viewModel.viewModel, onFeedbackSent),
        ],
      ),
    );
  }

  Widget _build(
    BuildContext context,
    String qagId,
    QagDetailsFeedbackViewModel viewModel,
    void Function() onFeedbackSent,
  ) {
    if (viewModel is QagDetailsFeedbackNotAnsweredViewModel || viewModel is QagDetailsFeedbackLoadingViewModel) {
      final isHelpfulButtonClicked =
          viewModel is QagDetailsFeedbackLoadingViewModel ? viewModel.isHelpfulClicked : null;
      return _buildNotAnswered(context, qagId, isHelpfulButtonClicked);
    } else if (viewModel is QagDetailsFeedbackAnsweredNoResultsViewModel) {
      Future.delayed(Duration(milliseconds: 500)).then((_) => onFeedbackSent());
      return _buildAnsweredNoResults(context, viewModel);
    } else if (viewModel is QagDetailsFeedbackAnsweredResultsViewModel) {
      Future.delayed(Duration(milliseconds: 500)).then((_) => onFeedbackSent());
      return _buildAnsweredResults(context, viewModel);
    } else {
      return _buildError();
    }
  }

  Widget _buildNotAnswered(BuildContext context, String qagId, bool? isHelpfulClicked) {
    return Row(
      children: [
        if (isHelpfulClicked == null) ...[
          AgoraRoundedButton(
            icon: "ic_thumb_white.svg",
            label: QagStrings.utils,
            contentPadding: AgoraRoundedButtonPadding.normal,
            onPressed: () {
              if (isHelpfulClicked == null) {
                _trackFeedback(qagId);
                context.read<QagDetailsBloc>().add(SendFeedbackQagDetailsEvent(qagId: qagId, isHelpful: true));
              }
            },
          ),
          SizedBox(width: AgoraSpacings.base),
          AgoraRoundedButton(
            icon: "ic_thumb_down_white.svg",
            label: QagStrings.notUtils,
            contentPadding: AgoraRoundedButtonPadding.normal,
            iconPadding: EdgeInsets.only(right: AgoraSpacings.x0_5, top: AgoraSpacings.x0_5),
            onPressed: () {
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

  Widget _buildAnsweredNoResults(BuildContext context, QagDetailsFeedbackAnsweredNoResultsViewModel viewModel) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(QagStrings.feedback, style: AgoraTextStyles.regular14),
        const SizedBox(height: AgoraSpacings.base),
        AgoraButton(
          label: 'Modifier votre réponse',
          buttonStyle: AgoraButtonStyle.blueBorder,
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

  Widget _buildAnsweredResults(BuildContext context, QagDetailsFeedbackAnsweredResultsViewModel viewModel) {
    return Column(
      children: [
        AgoraConsultationResultBar(
          ratio: viewModel.feedbackResults.positiveRatio,
          response: QagStrings.utils,
          isUserResponse: viewModel.userResponse == true,
          minusPadding: AgoraSpacings.horizontalPadding * 2,
        ),
        SizedBox(height: AgoraSpacings.x0_75),
        AgoraConsultationResultBar(
          ratio: viewModel.feedbackResults.negativeRatio,
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
          child: AgoraButton(
            label: 'Modifier votre réponse',
            buttonStyle: AgoraButtonStyle.blueBorder,
            onPressed: () {
              context.read<QagDetailsBloc>().add(EditFeedbackQagDetailsEvent());
            },
          ),
        ),
      ],
    );
  }

  Widget _buildError() {
    return Column(
      children: [
        SizedBox(height: AgoraSpacings.base),
        AgoraErrorText(),
      ],
    );
  }

  void _trackFeedback(String qagId) {
    TrackerHelper.trackClick(
      clickName: "${AnalyticsEventNames.giveQagFeedback} $qagId",
      widgetName: AnalyticsScreenNames.qagDetailsPage,
    );
  }
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
