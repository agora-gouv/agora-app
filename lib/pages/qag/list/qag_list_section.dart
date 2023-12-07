import 'package:agora/bloc/qag/list/qag_list_bloc.dart';
import 'package:agora/bloc/qag/list/qag_list_event.dart';
import 'package:agora/bloc/qag/list/qag_list_state.dart';
import 'package:agora/bloc/qag/qag_view_model.dart';
import 'package:agora/bloc/qag/support/qag_support_bloc.dart';
import 'package:agora/common/analytics/analytics_screen_names.dart';
import 'package:agora/common/manager/repository_manager.dart';
import 'package:agora/common/strings/qag_strings.dart';
import 'package:agora/design/custom_view/agora_error_view.dart';
import 'package:agora/design/custom_view/button/agora_rounded_button.dart';
import 'package:agora/design/style/agora_spacings.dart';
import 'package:agora/design/style/agora_text_styles.dart';
import 'package:agora/domain/qag/qas_list_filter.dart';
import 'package:agora/infrastructure/qag/presenter/qag_presenter.dart';
import 'package:agora/pages/qag/agora_qag_supportable_card.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class QagListSection extends StatelessWidget {
  final String? thematiqueId;
  final QagListFilter qagFilter;

  const QagListSection({required this.qagFilter, required this.thematiqueId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: QagListBloc(qagRepository: RepositoryManager.getQagRepository(), qagFilter: qagFilter)
        ..add(FetchQagsListEvent(thematiqueId: thematiqueId)),
      child: BlocSelector<QagListBloc, QagListState, _ViewModel>(
        selector: _ViewModel.fromState,
        builder: (context, viewModel) {
          final Widget section;

          if (viewModel is _QagListLoadingViewModel) {
            section = Center(child: CircularProgressIndicator());
          } else if (viewModel is _QagListWithResultViewModel) {
            section = _buildQagSearchListView(context, viewModel);
          } else if (viewModel is _QagListNoResultViewModel) {
            section = Center(
              child: Text(
                QagStrings.searchQagEmptyList,
                style: AgoraTextStyles.regular14,
              ),
            );
          } else {
            section = Center(child: AgoraErrorView());
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

  ListView _buildQagSearchListView(BuildContext context, _QagListWithResultViewModel viewModel) {
    return ListView.separated(
      physics: const NeverScrollableScrollPhysics(),
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      itemCount: viewModel.isLoadMoreVisible ? viewModel.qags.length + 1 : viewModel.qags.length,
      itemBuilder: (context, index) {
        if (index != viewModel.qags.length) {
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
        } else {
          if (viewModel.isLoadingMore) {
            return Center(child: CircularProgressIndicator());
          }
          if (viewModel.isLoadMoreVisible) {
            return Center(
              child: AgoraRoundedButton(
                label: QagStrings.displayMore,
                style: AgoraRoundedButtonStyle.primaryButtonStyle,
                onPressed: () {
                  context.read<QagListBloc>().add(UpdateQagsListEvent(thematiqueId: thematiqueId));
                },
              ),
            );
          }
          return SizedBox();
        }
      },
      separatorBuilder: (BuildContext context, int index) {
        return SizedBox(height: AgoraSpacings.base);
      },
    );
  }
}

abstract class _ViewModel extends Equatable {
  static _ViewModel fromState(QagListState state) {
    if (state is QagListInitialState) {
      return _QagListLoadingViewModel();
    } else if (state is QagListLoadedState) {
      if (state.qags.isNotEmpty) {
        return _QagListWithResultViewModel(
          qags: QagPresenter.presentQag(state.qags),
          isLoadMoreVisible: state.currentPage < state.maxPage,
          isLoadingMore: state.isLoadingMore,
        );
      } else {
        return _QagListNoResultViewModel();
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
  final bool isLoadMoreVisible;
  final bool isLoadingMore;

  _QagListWithResultViewModel({
    required this.qags,
    required this.isLoadMoreVisible,
    required this.isLoadingMore,
  });

  @override
  List<Object?> get props => [qags, isLoadMoreVisible, isLoadingMore];
}

class _QagListNoResultViewModel extends _ViewModel {
  @override
  List<Object?> get props => [];
}

class _QagListErrorViewModel extends _ViewModel {
  @override
  List<Object?> get props => [];
}
