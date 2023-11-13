import 'package:agora/bloc/qag/qag_view_model.dart';
import 'package:agora/bloc/qag/search/qag_search_bloc.dart';
import 'package:agora/bloc/qag/search/qag_search_state.dart';
import 'package:agora/bloc/qag/support/qag_support_bloc.dart';
import 'package:agora/bloc/qag/support/qag_support_event.dart';
import 'package:agora/common/analytics/analytics_event_names.dart';
import 'package:agora/common/analytics/analytics_screen_names.dart';
import 'package:agora/common/helper/tracker_helper.dart';
import 'package:agora/design/custom_view/agora_error_view.dart';
import 'package:agora/design/custom_view/agora_qag_card.dart';
import 'package:agora/design/style/agora_spacings.dart';
import 'package:agora/pages/qag/details/qag_details_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class QagSearch extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocSelector<QagSearchBloc, QagSearchState, _ViewModel>(
      selector: _ViewModel.fromState,
      builder: (context, viewModel) {
        if (viewModel is _QagSearchLoadedViewModel) {
          return ListView.builder(
            physics: const NeverScrollableScrollPhysics(),
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            itemCount: viewModel.qags.length,
            itemBuilder: (context, index) {
              final item = viewModel.qags[index];
              return Column(
                children: [
                  AgoraQagCard(
                    id: item.id,
                    thematique: item.thematique,
                    title: item.title,
                    username: item.username,
                    date: item.date,
                    supportCount: item.supportCount,
                    isSupported: item.isSupported,
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
                  ),
                  SizedBox(height: AgoraSpacings.base),
                ],
              );
            },
          );
        } else if (viewModel is _QagSearchLoadingViewModel) {
          return CircularProgressIndicator();
        } else if (viewModel is _QagSearchEmptyViewModel) {
          return SizedBox(height: AgoraSpacings.base);
        } else {
          return AgoraErrorView();
        }
      },
    );
  }
}

abstract class _ViewModel {
  static _ViewModel fromState(QagSearchState state) {
    if (state is QagSearchLoadedState) {
      return _QagSearchLoadedViewModel(
        qags: state.qagViewModels,
      );
    } else if (state is QagSearchLoadingState) {
      return _QagSearchLoadingViewModel();
    } else if (state is QagSearchInitialState) {
      return _QagSearchEmptyViewModel();
    } else {
      return _QagSearchErrorViewModel();
    }
  }
}

class _QagSearchLoadedViewModel extends _ViewModel {
  final List<QagViewModel> qags;

  _QagSearchLoadedViewModel({required this.qags});
}

class _QagSearchLoadingViewModel extends _ViewModel {}

class _QagSearchEmptyViewModel extends _ViewModel {}

class _QagSearchErrorViewModel extends _ViewModel {}
