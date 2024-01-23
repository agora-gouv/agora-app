import 'package:agora/bloc/qag/qag_view_model.dart';
import 'package:agora/bloc/qag/search/qag_search_bloc.dart';
import 'package:agora/bloc/qag/search/qag_search_event.dart';
import 'package:agora/bloc/qag/search/qag_search_state.dart';
import 'package:agora/bloc/qag/support/qag_support_bloc.dart';
import 'package:agora/common/analytics/analytics_event_names.dart';
import 'package:agora/common/analytics/analytics_screen_names.dart';
import 'package:agora/common/helper/tracker_helper.dart';
import 'package:agora/common/manager/repository_manager.dart';
import 'package:agora/common/strings/qag_strings.dart';
import 'package:agora/design/custom_view/agora_error_view.dart';
import 'package:agora/design/custom_view/button/agora_rounded_button.dart';
import 'package:agora/design/style/agora_spacings.dart';
import 'package:agora/design/style/agora_text_styles.dart';
import 'package:agora/infrastructure/qag/presenter/qag_presenter.dart';
import 'package:agora/pages/qag/agora_qag_supportable_card.dart';
import 'package:agora/pages/qag/ask_question/qag_ask_question_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class QagSearch extends StatelessWidget {
  final bool fromHome;

  QagSearch([this.fromHome = true]);

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
          section = Align(
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
        } else if (viewModel is _QagSearchEmptyViewModel) {
          section = Align(
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
    SemanticsService.announce('La liste des questions au gourvernement a changé', TextDirection.ltr);
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
              AgoraQagSupportableCard(
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
    );
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
