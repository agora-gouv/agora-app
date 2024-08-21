import 'package:agora/common/analytics/analytics_event_names.dart';
import 'package:agora/common/analytics/analytics_screen_names.dart';
import 'package:agora/common/helper/tracker_helper.dart';
import 'package:agora/common/manager/repository_manager.dart';
import 'package:agora/common/strings/qag_strings.dart';
import 'package:agora/design/custom_view/agora_main_toolbar.dart';
import 'package:agora/design/custom_view/agora_tracker.dart';
import 'package:agora/design/custom_view/text/agora_rich_text.dart';
import 'package:agora/design/style/agora_spacings.dart';
import 'package:agora/qag/ask/bloc/ask_qag_status_bloc.dart';
import 'package:agora/qag/ask/bloc/ask_qag_status_event.dart';
import 'package:agora/qag/ask/bloc/search/qag_search_bloc.dart';
import 'package:agora/qag/ask/pages/qags_ask_question_section.dart';
import 'package:agora/qag/widgets/qags_section.dart';
import 'package:agora/thematique/bloc/thematique_bloc.dart';
import 'package:agora/thematique/bloc/thematique_event.dart';
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
  late final GlobalKey onSearchAnchorKey;

  @override
  void initState() {
    super.initState();
    onSearchAnchorKey = GlobalKey();
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
            create: (BuildContext context) => AskQagStatusBloc(
              qagRepository: RepositoryManager.getQagRepository(),
            )..add(FetchAskQagStatusEvent()),
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
              ),
              SizedBox(height: AgoraSpacings.base),
              QagsAskQuestionSectionPage(key: onSearchAnchorKey),
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
                      onSearchAnchorKey.currentContext!,
                      duration: const Duration(milliseconds: 400),
                      curve: Curves.easeInOut,
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
