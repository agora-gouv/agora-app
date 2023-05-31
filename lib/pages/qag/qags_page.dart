import 'package:agora/bloc/qag/qag_bloc.dart';
import 'package:agora/bloc/qag/qag_event.dart';
import 'package:agora/bloc/qag/qag_state.dart';
import 'package:agora/bloc/qag/support/qag_support_bloc.dart';
import 'package:agora/bloc/thematique/thematique_bloc.dart';
import 'package:agora/bloc/thematique/thematique_event.dart';
import 'package:agora/common/analytics/analytics_event_names.dart';
import 'package:agora/common/analytics/analytics_screen_names.dart';
import 'package:agora/common/helper/tracker_helper.dart';
import 'package:agora/common/manager/repository_manager.dart';
import 'package:agora/common/strings/qag_strings.dart';
import 'package:agora/design/custom_view/agora_error_view.dart';
import 'package:agora/design/custom_view/agora_main_toolbar.dart';
import 'package:agora/design/custom_view/agora_title_rich_text.dart';
import 'package:agora/design/custom_view/agora_tracker.dart';
import 'package:agora/design/style/agora_spacings.dart';
import 'package:agora/pages/qag/qags_ask_question_section.dart';
import 'package:agora/pages/qag/qags_response_section.dart';
import 'package:agora/pages/qag/qags_section.dart';
import 'package:agora/pages/qag/qags_thematique_section.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class QagsPage extends StatefulWidget {
  static const routeName = "/qagsPage";

  @override
  State<QagsPage> createState() => _QagsPageState();
}

class _QagsPageState extends State<QagsPage> {
  String? currentThematiqueId;

  @override
  Widget build(BuildContext context) {
    return AgoraTracker(
      widgetName: AnalyticsScreenNames.qagsPage,
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (BuildContext context) => QagBloc(
              qagRepository: RepositoryManager.getQagRepository(),
            )..add(FetchQagsEvent(thematiqueId: currentThematiqueId)),
          ),
          BlocProvider(
            create: (BuildContext context) => QagSupportBloc(qagRepository: RepositoryManager.getQagRepository()),
          ),
          BlocProvider(
            create: (context) => ThematiqueBloc(
              repository: RepositoryManager.getThematiqueRepository(),
            )..add(FetchThematiqueEvent()),
          ),
        ],
        child: BlocBuilder<QagBloc, QagState>(
          builder: (context, state) {
            return SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  AgoraMainToolbar(
                    title: AgoraRichText(
                      policeStyle: AgoraRichTextPoliceStyle.toolbar,
                      items: [
                        AgoraRichTextTextItem(text: "${QagStrings.toolbarPart1}\n", style: AgoraRichTextItemStyle.bold),
                        AgoraRichTextTextItem(text: QagStrings.toolbarPart2, style: AgoraRichTextItemStyle.regular),
                      ],
                    ),
                  ),
                  Column(children: _handleQagState(context, state)),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  List<Widget> _handleQagState(BuildContext context, QagState state) {
    if (state is QagFetchedState) {
      return [
        QagsResponseSection(qagResponseViewModels: state.qagResponseViewModels),
        QagsAskQuestionSectionPage(),
        QagsThematiqueSection(
          currentThematiqueId: currentThematiqueId,
          onThematiqueIdSelected: (String thematiqueId) {
            setState(() {
              if (thematiqueId == currentThematiqueId) {
                // TODO track all thematique id
                currentThematiqueId = null;
              } else {
                currentThematiqueId = thematiqueId;
                TrackerHelper.trackClick(
                  clickName: "${AnalyticsEventNames.thematique} $currentThematiqueId",
                  widgetName: AnalyticsScreenNames.qagsPage,
                );
              }
              context.read<QagBloc>().add(FetchQagsEvent(thematiqueId: currentThematiqueId));
            });
          },
        ),
        QagsSection(
          defaultSelected: QagTab.popular,
          popularViewModels: state.popularViewModels,
          latestViewModels: state.latestViewModels,
          supportingViewModels: state.supportingViewModels,
          selectedThematiqueId: currentThematiqueId,
        ),
      ];
    } else if (state is QagInitialLoadingState) {
      return [
        SizedBox(height: MediaQuery.of(context).size.height / 10 * 3.5),
        Center(child: CircularProgressIndicator()),
        SizedBox(height: AgoraSpacings.x2),
      ];
    } else if (state is QagErrorState) {
      return [
        SizedBox(height: MediaQuery.of(context).size.height / 10 * 3.5),
        Center(child: AgoraErrorView()),
        SizedBox(height: AgoraSpacings.x2),
      ];
    }
    return [];
  }
}
