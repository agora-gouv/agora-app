import 'package:agora/bloc/qag/list/qag_list_bloc.dart';
import 'package:agora/bloc/qag/list/qag_list_event.dart';
import 'package:agora/bloc/qag/list/qag_list_state.dart';
import 'package:agora/bloc/qag/qag_list_footer_type.dart';
import 'package:agora/bloc/qag/qag_view_model.dart';
import 'package:agora/bloc/qag/support/qag_support_bloc.dart';
import 'package:agora/common/analytics/analytics_event_names.dart';
import 'package:agora/common/analytics/analytics_screen_names.dart';
import 'package:agora/common/helper/tracker_helper.dart';
import 'package:agora/common/manager/repository_manager.dart';
import 'package:agora/common/manager/storage_manager.dart';
import 'package:agora/common/strings/generic_strings.dart';
import 'package:agora/common/strings/qag_strings.dart';
import 'package:agora/design/custom_view/agora_error_view.dart';
import 'package:agora/design/custom_view/agora_qag_header.dart';
import 'package:agora/design/custom_view/button/agora_rounded_button.dart';
import 'package:agora/design/style/agora_spacings.dart';
import 'package:agora/design/style/agora_text_styles.dart';
import 'package:agora/domain/qag/qas_list_filter.dart';
import 'package:agora/infrastructure/qag/presenter/qag_presenter.dart';
import 'package:agora/pages/qag/agora_qag_supportable_card.dart';
import 'package:agora/pages/qag/ask_question/qag_ask_question_page.dart';
import 'package:agora/pages/qag/qags_list_loading.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class QagListSection extends StatelessWidget {
  final String? thematiqueId;
  final String? thematiqueLabel;
  final QagListFilter qagFilter;

  const QagListSection({
    required this.qagFilter,
    required this.thematiqueId,
    this.thematiqueLabel,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: QagListBloc(
        qagRepository: RepositoryManager.getQagRepository(),
        headerQagStorageClient: StorageManager.getHeaderQagStorageClient(),
        qagFilter: qagFilter,
      )..add(FetchQagsListEvent(thematiqueId: thematiqueId, thematiqueLabel: thematiqueLabel)),
      child: BlocSelector<QagListBloc, QagListState, _ViewModel>(
        selector: _ViewModel.fromState,
        builder: (context, viewModel) {
          final Widget section;

          if (viewModel is _QagListLoadingViewModel) {
            section = QagsListLoading();
          } else if (viewModel is _QagListWithResultViewModel) {
            section = _buildQagSearchListView(context, viewModel);
          } else if (viewModel is _QagListNoResultViewModel) {
            section = _buildNoResultsWidget(context, viewModel);
          } else {
            section = Column(
              children: [
                SizedBox(height: AgoraSpacings.base),
                AgoraErrorView(
                  onReload: () => context.read<QagListBloc>().add(
                        FetchQagsListEvent(
                          thematiqueId: thematiqueId,
                          thematiqueLabel: thematiqueLabel,
                        ),
                      ),
                ),
              ],
            );
          }
          return ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: MediaQuery.of(context).size.height * 0.70,
            ),
            child: section,
          );
        },
      ),
    );
  }

  Widget _buildQagSearchListView(BuildContext context, _QagListWithResultViewModel viewModel) {
    return Column(
      children: [
        ..._buildHeaderQagWidget(context, viewModel.header),
        Semantics(
          label: 'Liste des questions au gouvernement',
          child: ListView.separated(
            physics: const NeverScrollableScrollPhysics(),
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            separatorBuilder: (BuildContext context, int index) {
              return SizedBox(height: AgoraSpacings.base);
            },
            itemCount: viewModel.hasFooter ? viewModel.qags.length + 1 : viewModel.qags.length,
            itemBuilder: (context, index) {
              if (index < viewModel.qags.length) {
                final item = viewModel.qags[index];
                return BlocProvider.value(
                  value: QagSupportBloc(qagRepository: RepositoryManager.getQagRepository()),
                  child: AgoraQagSupportableCard(
                    qagViewModel: item,
                    widgetName: AnalyticsScreenNames.qagsPage,
                    onQagSupportChange: (qagSupport) {
                      context.read<QagListBloc>().add(UpdateQagListSupportEvent(qagSupport: qagSupport));
                    },
                  ),
                );
              } else if (viewModel.hasFooter) {
                switch (viewModel.footerType) {
                  case QagListFooterType.loading:
                    return Center(child: CircularProgressIndicator());
                  case QagListFooterType.loaded:
                    return Center(
                      child: AgoraRoundedButton(
                        label: GenericStrings.displayMore,
                        style: AgoraRoundedButtonStyle.primaryButtonStyle,
                        onPressed: () {
                          context.read<QagListBloc>().add(UpdateQagsListEvent(thematiqueId: thematiqueId));
                        },
                      ),
                    );
                  case QagListFooterType.error:
                    return AgoraErrorView(
                      onReload: () => context.read<QagListBloc>().add(UpdateQagsListEvent(thematiqueId: thematiqueId)),
                    );
                }
              }
              return null;
            },
          ),
        ),
      ],
    );
  }

  Widget _buildNoResultsWidget(BuildContext context, _QagListNoResultViewModel viewModel) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ..._buildHeaderQagWidget(context, viewModel.header),
        Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                QagStrings.emptyList,
                style: AgoraTextStyles.medium14,
                textAlign: TextAlign.center,
              ),
              SizedBox(height: AgoraSpacings.x1_5),
              AgoraRoundedButton(
                label: QagStrings.askQuestion,
                onPressed: () {
                  TrackerHelper.trackClick(
                    clickName: AnalyticsEventNames.askQuestionInEmptyList,
                    widgetName: AnalyticsScreenNames.qagsPage,
                  );
                  Navigator.pushNamed(context, QagAskQuestionPage.routeName);
                },
              ),
            ],
          ),
        ),
        SizedBox(height: AgoraSpacings.x3 * 2),
      ],
    );
  }

  List<Widget> _buildHeaderQagWidget(BuildContext context, _QagListHeaderViewModel? viewModel) {
    if (viewModel != null) {
      return [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AgoraSpacings.horizontalPadding),
          child: Center(
            child: AgoraQagHeader(
              id: viewModel.id,
              title: viewModel.title,
              message: viewModel.message,
              onCloseHeader: (headerId) {
                context.read<QagListBloc>().add(CloseHeaderQagListEvent(headerId: headerId));
              },
            ),
          ),
        ),
        SizedBox(height: AgoraSpacings.base),
      ];
    }
    return [];
  }
}

abstract class _ViewModel extends Equatable {
  static _ViewModel fromState(QagListState state) {
    if (state is QagListInitialState) {
      return _QagListLoadingViewModel();
    } else if (state is QagListLoadedState) {
      final header = state.header != null
          ? _QagListHeaderViewModel(
              id: state.header!.id,
              title: state.header!.title,
              message: state.header!.message,
            )
          : null;

      if (state.qags.isNotEmpty) {
        return _QagListWithResultViewModel(
          qags: QagPresenter.presentQag(state.qags),
          header: header,
          hasFooter: state.currentPage < state.maxPage,
          footerType: state.footerType,
        );
      } else {
        return _QagListNoResultViewModel(header: header);
      }
    } else {
      return _QagListErrorViewModel();
    }
  }
}

class _QagListLoadingViewModel extends _ViewModel {
  @override
  List<Object?> get props => [];
}

class _QagListWithResultViewModel extends _ViewModel {
  final List<QagViewModel> qags;
  final _QagListHeaderViewModel? header;
  final bool hasFooter;
  final QagListFooterType footerType;

  _QagListWithResultViewModel({
    required this.qags,
    required this.header,
    required this.hasFooter,
    required this.footerType,
  });

  @override
  List<Object?> get props => [qags, header, hasFooter, footerType];
}

class _QagListNoResultViewModel extends _ViewModel {
  final _QagListHeaderViewModel? header;

  _QagListNoResultViewModel({required this.header});

  @override
  List<Object?> get props => [header];
}

class _QagListErrorViewModel extends _ViewModel {
  @override
  List<Object?> get props => [];
}

class _QagListHeaderViewModel extends Equatable {
  final String id;
  final String title;
  final String message;

  _QagListHeaderViewModel({
    required this.id,
    required this.title,
    required this.message,
  });

  @override
  List<Object?> get props => [id, title, message];
}
