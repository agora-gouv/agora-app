import 'package:agora/bloc/qag/list/qag_list_bloc.dart';
import 'package:agora/bloc/qag/list/qag_list_state.dart';
import 'package:agora/bloc/qag/qag_view_model.dart';
import 'package:agora/bloc/qag/support/qag_support_bloc.dart';
import 'package:agora/bloc/qag/support/qag_support_state.dart';
import 'package:agora/common/analytics/analytics_event_names.dart';
import 'package:agora/common/analytics/analytics_screen_names.dart';
import 'package:agora/common/helper/tracker_helper.dart';
import 'package:agora/common/manager/repository_manager.dart';
import 'package:agora/common/strings/qag_strings.dart';
import 'package:agora/design/custom_view/agora_qag_card.dart';
import 'package:agora/design/style/agora_spacings.dart';
import 'package:agora/design/style/agora_text_styles.dart';
import 'package:agora/domain/qag/qas_list_filter.dart';
import 'package:agora/infrastructure/qag/presenter/qag_presenter.dart';
import 'package:agora/pages/qag/details/qag_details_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class QagListSection extends StatelessWidget {
  final QagListFilter qagFilter;

  const QagListSection({required this.qagFilter});

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: QagListBloc(qagRepository: RepositoryManager.getQagRepository(), qagFilter: qagFilter),
      child: BlocSelector<QagListBloc, QagListState, _ViewModel>(
        selector: _ViewModel.fromState,
        builder: (context, viewModel) {
          if (viewModel is _QagListLoadingViewModel) {
            return Center(child: CircularProgressIndicator());
          } else if (viewModel is _QagListWithResultViewModel) {
            return _buildQagSearchListView(context, viewModel.qags);
          } else if (viewModel is _QagListNoResultViewModel) {
            return Center(
              child: Text(
                QagStrings.searchQagEmptyList,
                style: AgoraTextStyles.regular14,
              ),
            );
          } else if (viewModel is _QagListErrorViewModel) {
            return SizedBox();
          }
        },
      ),
    );
  }

  ListView _buildQagSearchListView(BuildContext context, List<QagViewModel> viewModel) {
    return ListView.separated(
      physics: const NeverScrollableScrollPhysics(),
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      itemCount: viewModel.length,
      itemBuilder: (context, index) {
        final item = viewModel[index];
        return BlocProvider.value(
          value: QagSupportBloc(qagRepository: RepositoryManager.getQagRepository()),
          child: BlocBuilder<QagSupportBloc, QagSupportState>(
            builder: (context, state) {
              return AgoraQagCard(
                id: item.id,
                thematique: item.thematique,
                title: item.title,
                username: item.username,
                date: item.date,
                supportCount: _buildCount(item, state),
                isSupported: _buildIsSupported(item.isSupported, state),
                isAuthor: item.isAuthor,
                onSupportClick: (bool support) {
                  if (support) {
                    TrackerHelper.trackClick(
                      clickName: AnalyticsEventNames.likeQag,
                      widgetName: AnalyticsScreenNames.qagsPage,
                    );
                    context.read<QagSupportBloc>().add(SupportQagEvent(qagId: item.id));
                  } else {
                    TrackerHelper.trackClick(
                      clickName: AnalyticsEventNames.unlikeQag,
                      widgetName: AnalyticsScreenNames.qagsPage,
                    );
                    context.read<QagSupportBloc>().add(DeleteSupportQagEvent(qagId: item.id));
                  }
                },
                onCardClick: () {
                  Navigator.pushNamed(
                    context,
                    QagDetailsPage.routeName,
                    arguments: QagDetailsArguments(qagId: item.id, reload: QagReload.qagsPaginatedPage),
                  );
                },
              );
            },
          ),
        );
      },
      separatorBuilder: (BuildContext context, int index) {
        return SizedBox(height: AgoraSpacings.base);
      },
    );
  }
}

abstract class _ViewModel {
  static _ViewModel fromState(QagListState state) {
    if (state is QagListInitialState) {
      return _QagListLoadingViewModel();
    } else if (state is QagListLoadedState) {
      if (state.qags.isNotEmpty) {
        return _QagListWithResultViewModel(qags: QagPresenter.presentQag(state.qags));
      } else {
        return _QagListNoResultViewModel();
      }
    } else {
      return _QagListErrorViewModel();
    }
  }
}

class _QagListLoadingViewModel extends _ViewModel {}

class _QagListWithResultViewModel extends _ViewModel {
  final List<QagViewModel> qags;

  _QagListWithResultViewModel({required this.qags});
}

class _QagListNoResultViewModel extends _ViewModel {}

class _QagListErrorViewModel extends _ViewModel {}
