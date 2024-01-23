import 'package:agora/bloc/qag/response/qag_response_bloc.dart';
import 'package:agora/bloc/qag/response/qag_response_state.dart';
import 'package:agora/bloc/qag/response/qag_response_view_model.dart';
import 'package:agora/common/analytics/analytics_event_names.dart';
import 'package:agora/common/analytics/analytics_screen_names.dart';
import 'package:agora/common/helper/tracker_helper.dart';
import 'package:agora/common/strings/generic_strings.dart';
import 'package:agora/common/strings/qag_strings.dart';
import 'package:agora/common/strings/semantics_strings.dart';
import 'package:agora/design/custom_view/agora_alert_dialog.dart';
import 'package:agora/design/custom_view/agora_error_view.dart';
import 'package:agora/design/custom_view/agora_more_information.dart';
import 'package:agora/design/custom_view/agora_qag_incoming_response_card.dart';
import 'package:agora/design/custom_view/agora_qag_response_card.dart';
import 'package:agora/design/custom_view/agora_rich_text.dart';
import 'package:agora/design/custom_view/button/agora_button.dart';
import 'package:agora/design/custom_view/button/agora_rounded_button.dart';
import 'package:agora/design/style/agora_button_style.dart';
import 'package:agora/design/style/agora_spacings.dart';
import 'package:agora/design/style/agora_text_styles.dart';
import 'package:agora/infrastructure/qag/presenter/qag_response_presenter.dart';
import 'package:agora/pages/qag/details/qag_details_page.dart';
import 'package:agora/pages/qag/qags_response_loading.dart';
import 'package:agora/pages/qag/response_paginated/qags_response_paginated_page.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intersperse/intersperse.dart';

class QagsResponseSection extends StatelessWidget {
  const QagsResponseSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildQagResponseHeader(context),
        BlocSelector<QagResponseBloc, QagResponseState, _ViewModel>(
          selector: _ViewModel.fromState,
          builder: (context, viewModel) => Padding(
            padding: const EdgeInsets.only(
              left: AgoraSpacings.horizontalPadding,
              top: AgoraSpacings.base,
              bottom: AgoraSpacings.x2,
            ),
            child: switch (viewModel) {
              _LoadingViewModel _ => _buildLoadingWidget(),
              _EmptyViewModel _ => _buildEmptyWidget(),
              _ErrorViewModel _ => _buildErrorWidget(),
              final _ResponseListViewModel viewModel => _buildResponseListWidget(context, viewModel.viewModels),
            },
          ),
        ),
      ],
    );
  }

  Widget _buildQagResponseHeader(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: AgoraSpacings.horizontalPadding),
      child: Row(
        children: [
          Expanded(
            child: Row(
              children: [
                AgoraRichText(
                  items: [
                    AgoraRichTextItem(text: "${QagStrings.qagResponsePart1}\n", style: AgoraRichTextItemStyle.bold),
                    AgoraRichTextItem(text: QagStrings.qagResponsePart2, style: AgoraRichTextItemStyle.regular),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 16.0),
                  child: AgoraMoreInformation(
                    semanticsLabel: SemanticsStrings.moreInformationAboutGovernmentResponse,
                    onClick: () {
                      showAgoraDialog(
                        context: context,
                        columnChildren: [
                          Text(QagStrings.qagResponseInfoBubble, style: AgoraTextStyles.light16),
                          SizedBox(height: AgoraSpacings.x0_75),
                          AgoraButton(
                            label: GenericStrings.close,
                            style: AgoraButtonStyle.primaryButtonStyle,
                            onPressed: () => Navigator.pop(context),
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: AgoraSpacings.x0_75),
          AgoraRoundedButton(
            label: GenericStrings.all,
            style: AgoraRoundedButtonStyle.greyBorderButtonStyle,
            onPressed: () => Navigator.pushNamed(context, QagResponsePaginatedPage.routeName),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingWidget() {
    return QagsResponseLoading();
  }

  Widget _buildEmptyWidget() {
    return Container();
  }

  Widget _buildErrorWidget() {
    return Center(child: AgoraErrorView());
  }

  Widget _buildResponseListWidget(BuildContext context, List<QagResponseTypeViewModel> viewModels) {
    return Column(
      children: [
        LayoutBuilder(
          builder: (context, constraint) {
            return SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              scrollDirection: Axis.horizontal,
              child: ConstrainedBox(
                constraints: BoxConstraints(minWidth: constraint.maxWidth),
                child: IntrinsicHeight(
                  // IntrinsicHeight : make all card same height
                  child: Row(
                    children: _buildQagResponseCards(viewModels, context),
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  List<Widget> _buildQagResponseCards(List<QagResponseTypeViewModel> viewModels, BuildContext context) {
    return viewModels
        .map(
          (viewModel) => switch (viewModel) {
            final QagResponseViewModel viewModel =>
              _buildQagResponseCard(viewModel, context, viewModels.length, viewModels.indexOf(viewModel) + 1),
            final QagResponseIncomingViewModel viewModel =>
              _buildQagIncomingResponseCard(viewModel, context, viewModels.length, viewModels.indexOf(viewModel) + 1),
          },
        )
        .intersperseOuter(SizedBox(width: AgoraSpacings.x0_5))
        .skip(1)
        .toList();
  }

  Widget _buildQagResponseCard(
    QagResponseViewModel qagResponse,
    BuildContext context,
    int maxIndex,
    int index,
  ) {
    return ConstrainedBox(
      constraints: BoxConstraints(maxWidth: 400),
      child: AgoraQagResponseCard(
        title: qagResponse.title,
        thematique: qagResponse.thematique,
        authorImageUrl: qagResponse.authorPortraitUrl,
        author: qagResponse.author,
        date: qagResponse.responseDate,
        style: AgoraQagResponseStyle.small,
        index: index,
        maxIndex: maxIndex,
        onClick: () {
          TrackerHelper.trackClick(
            clickName: "${AnalyticsEventNames.answeredQag} ${qagResponse.qagId}",
            widgetName: AnalyticsScreenNames.qagsPage,
          );
          Navigator.pushNamed(
            context,
            QagDetailsPage.routeName,
            arguments: QagDetailsArguments(qagId: qagResponse.qagId, reload: null),
          );
        },
      ),
    );
  }

  Widget _buildQagIncomingResponseCard(
    QagResponseIncomingViewModel qagResponse,
    BuildContext context,
    int maxIndex,
    int index,
  ) {
    return ConstrainedBox(
      constraints: BoxConstraints(maxWidth: 400),
      child: AgoraQagIncomingResponseCard(
        title: qagResponse.title,
        thematique: qagResponse.thematique,
        supportCount: qagResponse.supportCount,
        isSupported: qagResponse.isSupported,
        index: index,
        maxIndex: maxIndex,
        onClick: () {
          TrackerHelper.trackClick(
            clickName: "${AnalyticsEventNames.incomingAnsweredQag} ${qagResponse.qagId}",
            widgetName: AnalyticsScreenNames.qagsPage,
          );
          Navigator.pushNamed(
            context,
            QagDetailsPage.routeName,
            arguments: QagDetailsArguments(qagId: qagResponse.qagId, reload: null),
          );
        },
      ),
    );
  }
}

sealed class _ViewModel extends Equatable {
  static _ViewModel fromState(QagResponseState state) {
    return switch (state) {
      QagResponseInitialLoadingState _ => _LoadingViewModel(),
      QagResponseErrorState _ => _ErrorViewModel(),
      final QagResponseFetchedState state => _ViewModel._fromFetchedState(state),
    };
  }

  static _ViewModel _fromFetchedState(QagResponseFetchedState state) {
    final qagResponseViewModels = QagResponsePresenter.presentQagResponse(
      incomingQagResponses: state.incomingQagResponses,
      qagResponses: state.qagResponses,
    );
    if (qagResponseViewModels.isEmpty) {
      return _EmptyViewModel();
    } else {
      return _ResponseListViewModel(viewModels: qagResponseViewModels);
    }
  }

  @override
  List<Object?> get props => [];
}

class _LoadingViewModel extends _ViewModel {}

class _ErrorViewModel extends _ViewModel {}

class _EmptyViewModel extends _ViewModel {}

class _ResponseListViewModel extends _ViewModel {
  final List<QagResponseTypeViewModel> viewModels;

  _ResponseListViewModel({required this.viewModels});

  @override
  List<Object?> get props => [viewModels];
}
