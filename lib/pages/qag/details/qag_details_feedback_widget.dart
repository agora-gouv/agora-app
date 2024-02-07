import 'package:agora/bloc/qag/details/qag_details_bloc.dart';
import 'package:agora/bloc/qag/details/qag_details_event.dart';
import 'package:agora/bloc/qag/details/qag_details_state.dart';
import 'package:agora/bloc/qag/details/qag_details_view_model.dart';
import 'package:agora/common/analytics/analytics_event_names.dart';
import 'package:agora/common/analytics/analytics_screen_names.dart';
import 'package:agora/common/extension/string_extension.dart';
import 'package:agora/common/helper/tracker_helper.dart';
import 'package:agora/common/strings/qag_strings.dart';
import 'package:agora/design/custom_view/agora_consultation_result_bar.dart';
import 'package:agora/design/custom_view/agora_error_view.dart';
import 'package:agora/design/custom_view/button/agora_rounded_button.dart';
import 'package:agora/design/style/agora_colors.dart';
import 'package:agora/design/style/agora_spacings.dart';
import 'package:agora/design/style/agora_text_styles.dart';
import 'package:agora/domain/qag/details/qag_details.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

class QagDetailsFeedbackWidget extends StatelessWidget {
  const QagDetailsFeedbackWidget({super.key});

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
          _build(context, viewModel.qagId, viewModel.viewModel),
        ],
      ),
    );
  }

  Widget _build(BuildContext context, String qagId, QagDetailsFeedbackViewModel viewModel) {
    if (viewModel is QagDetailsFeedbackNotAnsweredViewModel || viewModel is QagDetailsFeedbackLoadingViewModel) {
      final isHelpfulButtonClicked =
          viewModel is QagDetailsFeedbackLoadingViewModel ? viewModel.isHelpfulClicked : null;
      return _buildNotAnswered(context, qagId, isHelpfulButtonClicked);
    } else if (viewModel is QagDetailsFeedbackAnsweredNoResultsViewModel) {
      return _buildAnsweredNoResults();
    } else if (viewModel is QagDetailsFeedbackAnsweredResultsViewModel) {
      return _buildAnsweredResults(viewModel.feedbackResults);
    } else {
      return _buildError();
    }
  }

  Widget _buildNotAnswered(BuildContext context, String qagId, bool? isHelpfulClicked) {
    return Row(
      children: [
        AgoraRoundedButton(
          icon: "ic_thumb_white.svg",
          label: QagStrings.utils,
          contentPadding: AgoraRoundedButtonPadding.short,
          isLoading: isHelpfulClicked == true,
          onPressed: () {
            if (isHelpfulClicked == null) {
              _trackFeedback(qagId);
              context.read<QagDetailsBloc>().add(SendFeedbackEvent(qagId: qagId, isHelpful: true));
            }
          },
        ),
        SizedBox(width: AgoraSpacings.base),
        AgoraRoundedButton(
          icon: "ic_thumb_down_white.svg",
          label: QagStrings.notUtils,
          contentPadding: AgoraRoundedButtonPadding.short,
          isLoading: isHelpfulClicked == false,
          onPressed: () {
            if (isHelpfulClicked == null) {
              _trackFeedback(qagId);
              context.read<QagDetailsBloc>().add(SendFeedbackEvent(qagId: qagId, isHelpful: false));
            }
          },
        ),
      ],
    );
  }

  Widget _buildAnsweredNoResults() {
    return Text(QagStrings.feedback);
  }

  Widget _buildAnsweredResults(QagFeedbackResults results) {
    return Column(
      children: [
        AgoraConsultationResultBar(
          ratio: results.positiveRatio,
          response: QagStrings.utils,
          isUserResponse: false,
          minusPadding: AgoraSpacings.horizontalPadding * 2,
        ),
        SizedBox(height: AgoraSpacings.x0_75),
        AgoraConsultationResultBar(
          ratio: results.negativeRatio,
          response: QagStrings.notUtils,
          isUserResponse: false,
          minusPadding: AgoraSpacings.horizontalPadding * 2,
        ),
        SizedBox(height: AgoraSpacings.x1_5),
        Row(
          children: [
            SvgPicture.asset("assets/ic_person.svg", excludeFromSemantics: true),
            SizedBox(width: AgoraSpacings.x0_5),
            Text(QagStrings.feedbackAnswerCount.format(results.count.toString()), style: AgoraTextStyles.light14),
          ],
        ),
      ],
    );
  }

  Widget _buildError() {
    return Column(
      children: [
        SizedBox(height: AgoraSpacings.base),
        AgoraErrorView(),
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
