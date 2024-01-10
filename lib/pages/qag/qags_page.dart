import 'package:agora/bloc/qag/ask_qag/ask_qag_bloc.dart';
import 'package:agora/bloc/qag/ask_qag/ask_qag_event.dart';
import 'package:agora/bloc/qag/response/qag_response_bloc.dart';
import 'package:agora/bloc/qag/response/qag_response_event.dart';
import 'package:agora/bloc/qag/search/qag_search_bloc.dart';
import 'package:agora/bloc/thematique/thematique_bloc.dart';
import 'package:agora/bloc/thematique/thematique_event.dart';
import 'package:agora/common/analytics/analytics_event_names.dart';
import 'package:agora/common/analytics/analytics_screen_names.dart';
import 'package:agora/common/helper/tracker_helper.dart';
import 'package:agora/common/manager/repository_manager.dart';
import 'package:agora/common/strings/qag_strings.dart';
import 'package:agora/design/custom_view/agora_main_toolbar.dart';
import 'package:agora/design/custom_view/agora_rich_text.dart';
import 'package:agora/design/custom_view/agora_tracker.dart';
import 'package:agora/design/style/agora_spacings.dart';
import 'package:agora/pages/profile/profile_page.dart';
import 'package:agora/pages/qag/qags_ask_question_section.dart';
import 'package:agora/pages/qag/qags_response_section.dart';
import 'package:agora/pages/qag/qags_section.dart';
import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class QagsPage extends StatefulWidget {
  static const routeName = "/qagsPage";

  @override
  State<QagsPage> createState() => _QagsPageState();
}

class _QagsPageState extends State<QagsPage> {
  final GlobalKey toolbarTitleKey = GlobalKey();
  String? currentThematiqueId;
  late final GlobalKey searchBarKey;

  @override
  void initState() {
    super.initState();
    searchBarKey = GlobalKey();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      toolbarTitleKey.currentContext?.findRenderObject()?.sendSemanticsEvent(FocusSemanticEvent());
    });
  }

  @override
  Widget build(BuildContext context) {
    return AgoraTracker(
      widgetName: AnalyticsScreenNames.qagsPage,
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (BuildContext context) => AskQagBloc(
              qagRepository: RepositoryManager.getQagRepository(),
            )..add(FetchAskQagStatusEvent()),
          ),
          BlocProvider(
            create: (BuildContext context) => QagResponseBloc(
              qagRepository: RepositoryManager.getQagRepository(),
            )..add(FetchQagsResponseEvent()),
          ),
          BlocProvider(
            create: (context) => ThematiqueBloc(
              repository: RepositoryManager.getThematiqueRepository(),
            )..add(FetchFilterThematiqueEvent()),
          ),
          BlocProvider(
            create: (context) => QagSearchBloc(
              qagRepository: RepositoryManager.getQagRepository(),
            ),
          ),
        ],
        child: SingleChildScrollView(
          physics: ClampingScrollPhysics(),
          child: Column(
            children: [
              AgoraMainToolbar(
                title: AgoraRichText(
                  key: toolbarTitleKey,
                  policeStyle: AgoraRichTextPoliceStyle.toolbar,
                  semantic: AgoraRichTextSemantic(focused: true),
                  items: [
                    AgoraRichTextItem(text: "${QagStrings.toolbarPart1}\n", style: AgoraRichTextItemStyle.bold),
                    AgoraRichTextItem(text: QagStrings.toolbarPart2, style: AgoraRichTextItemStyle.regular),
                  ],
                ),
                onProfileClick: () {
                  Navigator.pushNamed(context, ProfilePage.routeName);
                },
              ),
              SizedBox(height: AgoraSpacings.base),
              QagsResponseSection(),
              ..._handleQagState(context),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _handleQagState(BuildContext context) {
    return [
      QagsAskQuestionSectionPage(),
      QagsSection(
        defaultSelected: QagTab.trending,
        selectedThematiqueId: currentThematiqueId,
        onSearchBarOpen: (bool isSearchOpen) {
          if (isSearchOpen) {
            TrackerHelper.trackEvent(
              widgetName: AnalyticsScreenNames.qagsPage,
              eventName: AnalyticsEventNames.qagsSearch,
            );
            Scrollable.ensureVisible(
              searchBarKey.currentContext!,
              duration: const Duration(milliseconds: 400),
              curve: Curves.easeInOut,
            );
          }
        },
      ),
    ];
  }
}
