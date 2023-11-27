import 'package:agora/bloc/qag/qag_view_model.dart';
import 'package:agora/bloc/qag/search/qag_search_bloc.dart';
import 'package:agora/bloc/qag/search/qag_search_state.dart';
import 'package:agora/bloc/qag/support/qag_support_bloc.dart';
import 'package:agora/bloc/qag/support/qag_support_event.dart';
import 'package:agora/bloc/qag/support/qag_support_state.dart';
import 'package:agora/common/analytics/analytics_event_names.dart';
import 'package:agora/common/analytics/analytics_screen_names.dart';
import 'package:agora/common/helper/tracker_helper.dart';
import 'package:agora/common/manager/repository_manager.dart';
import 'package:agora/common/strings/qag_strings.dart';
import 'package:agora/design/custom_view/agora_error_view.dart';
import 'package:agora/design/custom_view/agora_qag_card.dart';
import 'package:agora/design/style/agora_spacings.dart';
import 'package:agora/design/style/agora_text_styles.dart';
import 'package:agora/infrastructure/qag/presenter/qag_presenter.dart';
import 'package:agora/pages/qag/details/qag_details_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class QagSearch extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocSelector<QagSearchBloc, QagSearchState, _ViewModel>(
      selector: _ViewModel.fromState,
      builder: (context, viewModel) {
        final Widget section;

        if (viewModel is _QagSearchWithResultViewModel) {
          section = _buildQagSearchListView(context, viewModel.qags);
        } else if (viewModel is _QagSearchLoadingViewModel) {
          section = Center(child: CircularProgressIndicator());
        } else if (viewModel is _QagSearchNoResultViewModel) {
          section = Center(
            child: Text(
              QagStrings.searchQagEmptyList,
              style: AgoraTextStyles.regular14,
            ),
          );
        } else if (viewModel is _QagSearchEmptyViewModel) {
          section = Center();
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
    );
  }

  ListView _buildQagSearchListView(BuildContext context, List<QagViewModel> viewModel) {
    return ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      itemCount: viewModel.length,
      itemBuilder: (context, index) {
        final item = viewModel[index];
        return BlocProvider.value(
          value: QagSupportBloc(qagRepository: RepositoryManager.getQagRepository()),
          child: Column(
            children: [
              BlocBuilder<QagSupportBloc, QagSupportState>(
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
              SizedBox(height: AgoraSpacings.base),
            ],
          ),
        );
      },
    );
  }

  int _buildCount(QagViewModel qagViewModel, QagSupportState supportState) {
    final supportCount = qagViewModel.supportCount - (qagViewModel.isSupported ? 1 : 0);
    if (supportState is QagSupportInitialState) {
      return qagViewModel.supportCount;
    } else if (supportState is QagSupportSuccessState) {
      return supportCount + 1;
    } else if (supportState is QagDeleteSupportSuccessState) {
      return supportCount;
    }
    return supportCount;
  }

  bool _buildIsSupported(bool isSupported, QagSupportState supportState) {
    if (supportState is QagSupportInitialState) {
      return isSupported;
    } else if (supportState is QagSupportLoadingState) {
      return !isSupported;
    } else {
      if (supportState is QagSupportSuccessState || supportState is QagDeleteSupportErrorState) {
        return true;
      } else if (supportState is QagSupportErrorState || supportState is QagDeleteSupportSuccessState) {
        return false;
      }
    }
    return false;
  }
}

abstract class _ViewModel {
  static _ViewModel fromState(QagSearchState state) {
    if (state is QagSearchLoadedState && state.qags.isEmpty) {
      return _QagSearchNoResultViewModel();
    } else if (state is QagSearchLoadedState && state.qags.isNotEmpty) {
      return _QagSearchWithResultViewModel(
        qags: QagPresenter.presentQag(state.qags),
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

class _QagSearchWithResultViewModel extends _ViewModel {
  final List<QagViewModel> qags;

  _QagSearchWithResultViewModel({required this.qags});
}

class _QagSearchNoResultViewModel extends _ViewModel {}

class _QagSearchLoadingViewModel extends _ViewModel {}

class _QagSearchEmptyViewModel extends _ViewModel {}

class _QagSearchErrorViewModel extends _ViewModel {}
