import 'package:agora/bloc/qag/response/qag_response_a_venir_view_model.dart';
import 'package:agora/bloc/qag/response/qag_response_bloc.dart';
import 'package:agora/bloc/qag/response/qag_response_event.dart';
import 'package:agora/bloc/qag/response/qag_response_state.dart';
import 'package:agora/common/analytics/analytics_event_names.dart';
import 'package:agora/common/analytics/analytics_screen_names.dart';
import 'package:agora/common/helper/tracker_helper.dart';
import 'package:agora/common/strings/generic_strings.dart';
import 'package:agora/common/strings/reponse_strings.dart';
import 'package:agora/common/strings/semantics_strings.dart';
import 'package:agora/design/custom_view/agora_alert_dialog.dart';
import 'package:agora/design/custom_view/agora_error_view.dart';
import 'package:agora/design/custom_view/agora_horizontal_scroll_helper.dart';
import 'package:agora/design/custom_view/agora_more_information.dart';
import 'package:agora/design/custom_view/agora_qag_reponse_a_venir_card.dart';
import 'package:agora/design/custom_view/agora_rich_text.dart';
import 'package:agora/design/custom_view/button/agora_button.dart';
import 'package:agora/design/style/agora_button_style.dart';
import 'package:agora/design/style/agora_spacings.dart';
import 'package:agora/design/style/agora_text_styles.dart';
import 'package:agora/infrastructure/qag/presenter/qag_response_presenter.dart';
import 'package:agora/pages/qag/details/qag_details_page.dart';
import 'package:agora/pages/qag/qags_response_loading.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class QagReponsesAVenirSection extends StatelessWidget {
  const QagReponsesAVenirSection();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _ReponsesAVenirHeader(),
        BlocSelector<QagResponseBloc, QagResponseState, _ViewModel>(
          selector: _ViewModel.fromState,
          builder: (context, viewModel) => Padding(
            padding: const EdgeInsets.only(
              left: AgoraSpacings.horizontalPadding,
              top: AgoraSpacings.base,
              bottom: AgoraSpacings.x2,
            ),
            child: switch (viewModel) {
              _LoadingViewModel _ => QagsResponseLoading(),
              _EmptyViewModel _ => SizedBox(),
              _ErrorViewModel _ => Center(
                  child: AgoraErrorView(onReload: () => context.read<QagResponseBloc>().add(FetchQagsResponseEvent())),
                ),
              final _ResponseListViewModel viewModel => _ReponseAVenirListWidget(viewModel.viewModels),
            },
          ),
        ),
      ],
    );
  }
}

class _ReponsesAVenirHeader extends StatelessWidget {
  const _ReponsesAVenirHeader();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: AgoraSpacings.horizontalPadding),
      child: Row(
        children: [
          Expanded(
            child: Row(
              children: [
                AgoraRichText(
                  items: [
                    AgoraRichTextItem(
                      text: "${ReponseStrings.reponsesAVenirTitrePart1}\n",
                      style: AgoraRichTextItemStyle.bold,
                    ),
                    AgoraRichTextItem(
                      text: ReponseStrings.reponsesAVenirTitrePart2,
                      style: AgoraRichTextItemStyle.regular,
                    ),
                  ],
                ),
                Padding(
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
        ],
      ),
    );
  }
}

class _ReponseAVenirListWidget extends StatelessWidget {
  final List<QagResponseAVenirViewModel> viewModels;

  const _ReponseAVenirListWidget(this.viewModels);

  @override
  Widget build(BuildContext context) {
    final scrollController = ScrollController();
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        LayoutBuilder(
          builder: (context, constraint) {
            return SingleChildScrollView(
              controller: scrollController,
              physics: BouncingScrollPhysics(),
              scrollDirection: Axis.horizontal,
              child: ConstrainedBox(
                constraints: BoxConstraints(minWidth: constraint.maxWidth),
                child: IntrinsicHeight(
                  // IntrinsicHeight : make all card same height
                  child: _ReponseAVenirCards(viewModels),
                ),
              ),
            );
          },
        ),
        if (viewModels.length > 1) ...[
          const SizedBox(height: AgoraSpacings.base),
          HorizontalScrollHelper(
            itemsCount: viewModels.length + 1,
            scrollController: scrollController,
            key: _questionScrollHelperKey,
          ),
        ],
      ],
    );
  }
}

class _ReponseAVenirCards extends StatelessWidget {
  final List<QagResponseAVenirViewModel> viewModels;

  const _ReponseAVenirCards(this.viewModels);

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ...viewModels.map(
          (viewModel) => _ReponseAVenirCard(viewModel, viewModels.length, viewModels.indexOf(viewModel)),
        ),
      ],
    );
  }
}

class _ReponseAVenirCard extends StatelessWidget {
  final QagResponseAVenirViewModel qagResponse;
  final int maxIndex;
  final int index;

  const _ReponseAVenirCard(this.qagResponse, this.maxIndex, this.index);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: AgoraSpacings.base),
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: 400),
        child: AgoraQagResponseAVenirCard(
          title: qagResponse.title,
          thematique: qagResponse.thematique,
          supportCount: qagResponse.supportCount,
          isSupported: qagResponse.isSupported,
          index: index,
          maxIndex: maxIndex,
          semaineGagnanteLabel: qagResponse.semaineGagnanteLabel,
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
  final List<QagResponseAVenirViewModel> viewModels;

  _ResponseListViewModel({required this.viewModels});

  @override
  List<Object?> get props => [viewModels];
}

final _questionScrollHelperKey = GlobalKey();
