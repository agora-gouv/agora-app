import 'package:agora/common/analytics/analytics_event_names.dart';
import 'package:agora/common/analytics/analytics_screen_names.dart';
import 'package:agora/common/helper/semantics_helper.dart';
import 'package:agora/common/helper/tracker_helper.dart';
import 'package:agora/common/manager/repository_manager.dart';
import 'package:agora/common/strings/qag_strings.dart';
import 'package:agora/design/custom_view/button/agora_rounded_button.dart';
import 'package:agora/design/custom_view/error/agora_error_text.dart';
import 'package:agora/design/custom_view/skeletons.dart';
import 'package:agora/design/style/agora_spacings.dart';
import 'package:agora/design/style/agora_text_styles.dart';
import 'package:agora/qag/ask/bloc/search/qag_search_bloc.dart';
import 'package:agora/qag/ask/bloc/search/qag_search_event.dart';
import 'package:agora/qag/ask/bloc/search/qag_search_state.dart';
import 'package:agora/qag/ask/pages/qag_ask_question_page.dart';
import 'package:agora/qag/details/bloc/support/qag_support_bloc.dart';
import 'package:agora/qag/repository/presenter/qag_display_model.dart';
import 'package:agora/qag/repository/presenter/qag_presenter.dart';
import 'package:agora/qag/widgets/qags_supportable_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class QagSearch extends StatelessWidget {
  final bool fromHome;

  QagSearch([this.fromHome = true]);

  @override
  Widget build(BuildContext context) {
    return BlocSelector<QagSearchBloc, QagSearchState, _ViewModel>(
      selector: _ViewModel.fromState,
      builder: (context, viewModel) {
        return switch (viewModel) {
          _QagSearchWithResultViewModel _ => _QagSearchListView(viewModel: viewModel.qags),
          _QagSearchLoadingViewModel _ => _LoadingView(),
          _QagSearchNoResultViewModel _ => _NoResultView(fromHome: fromHome),
          _QagSearchEmptyViewModel _ => _EmptyView(),
          _QagSearchErrorViewModel _ => _ErrorView(),
        };
      },
    );
  }
}

class _QagSearchListView extends StatelessWidget {
  final List<QagDisplayModel> viewModel;

  const _QagSearchListView({required this.viewModel});

  @override
  Widget build(BuildContext context) {
    SemanticsHelper.announceNewQagsInList();
    return ConstrainedBox(
      constraints: BoxConstraints(
        minHeight: MediaQuery.of(context).size.height * 0.70,
      ),
      child: ListView.builder(
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
                QagsSupportableCard(
                  qagViewModel: item,
                  widgetName: AnalyticsScreenNames.qagsPage,
                  onQagSupportChange: (qagSupport) {
                    context.read<QagSearchBloc>().add(UpdateQagSearchSupportEvent(qagSupport));
                  },
                ),
                SizedBox(height: AgoraSpacings.base),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _ErrorView extends StatelessWidget {
  const _ErrorView();

  @override
  Widget build(BuildContext context) {
    SemanticsHelper.announceGenericError();
    return Center(child: AgoraErrorText());
  }
}

class _EmptyView extends StatelessWidget {
  const _EmptyView();

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topCenter,
      child: Padding(
        padding: const EdgeInsets.only(
          top: AgoraSpacings.base,
          left: AgoraSpacings.base,
          right: AgoraSpacings.base,
        ),
        child: Text(
          QagStrings.searchQagEnterSomeCharacteres,
          style: AgoraTextStyles.regular14,
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}

class _NoResultView extends StatelessWidget {
  const _NoResultView({required this.fromHome});

  final bool fromHome;

  @override
  Widget build(BuildContext context) {
    SemanticsHelper.announceEmptyResult();
    return Align(
      alignment: Alignment.topCenter,
      child: Padding(
        padding: const EdgeInsets.only(top: AgoraSpacings.base),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              QagStrings.searchQagEmptyList,
              style: AgoraTextStyles.regular14,
            ),
            const SizedBox(height: AgoraSpacings.base),
            AgoraRoundedButton(
              label: QagStrings.askQuestion,
              onPressed: () {
                TrackerHelper.trackClick(
                  clickName: AnalyticsEventNames.askQuestion,
                  widgetName: AnalyticsScreenNames.qagsPage,
                );
                if (fromHome) {
                  Navigator.pushNamed(context, QagAskQuestionPage.routeName);
                } else {
                  Navigator.pop(context);
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _LoadingView extends StatelessWidget {
  const _LoadingView();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AgoraSpacings.base),
      child: Column(
        children: [
          SkeletonBox(height: 100),
          const SizedBox(height: AgoraSpacings.base),
          SkeletonBox(height: 100),
        ],
      ),
    );
  }
}

sealed class _ViewModel {
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
  final List<QagDisplayModel> qags;

  _QagSearchWithResultViewModel({required this.qags});
}

class _QagSearchNoResultViewModel extends _ViewModel {}

class _QagSearchLoadingViewModel extends _ViewModel {}

class _QagSearchEmptyViewModel extends _ViewModel {}

class _QagSearchErrorViewModel extends _ViewModel {}
