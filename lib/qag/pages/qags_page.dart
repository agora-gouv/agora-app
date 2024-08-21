import 'package:agora/common/analytics/analytics_event_names.dart';
import 'package:agora/common/analytics/analytics_screen_names.dart';
import 'package:agora/common/helper/tracker_helper.dart';
import 'package:agora/common/manager/repository_manager.dart';
import 'package:agora/common/strings/generic_strings.dart';
import 'package:agora/common/strings/qag_strings.dart';
import 'package:agora/common/strings/reponse_strings.dart';
import 'package:agora/common/strings/semantics_strings.dart';
import 'package:agora/design/custom_view/agora_alert_dialog.dart';
import 'package:agora/design/custom_view/agora_main_toolbar.dart';
import 'package:agora/design/custom_view/agora_more_information.dart';
import 'package:agora/design/custom_view/agora_tracker.dart';
import 'package:agora/design/custom_view/button/agora_button.dart';
import 'package:agora/design/custom_view/text/agora_rich_text.dart';
import 'package:agora/design/style/agora_colors.dart';
import 'package:agora/design/style/agora_spacings.dart';
import 'package:agora/design/style/agora_text_styles.dart';
import 'package:agora/qag/ask/bloc/ask_qag_status_bloc.dart';
import 'package:agora/qag/ask/bloc/ask_qag_status_event.dart';
import 'package:agora/qag/ask/bloc/search/qag_search_bloc.dart';
import 'package:agora/qag/ask/pages/qag_ask_question_page.dart';
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
    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        icon: Icon(Icons.chat),
        label: Text(QagStrings.askQuestion, style: AgoraTextStyles.medium14.copyWith(color: AgoraColors.white)),
        onPressed: () {
          TrackerHelper.trackClick(
            clickName: AnalyticsEventNames.askQuestion,
            widgetName: AnalyticsScreenNames.qagsPage,
          );
          Navigator.pushNamed(
            context,
            QagAskQuestionPage.routeName,
          );
        },
      ),
      body: AgoraTracker(
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
                  title: Row(
                    children: [
                      AgoraRichText(
                        key: toolbarTitleKey,
                        policeStyle: AgoraRichTextPoliceStyle.toolbar,
                        semantic: AgoraRichTextSemantic(focused: true),
                        items: [
                          AgoraRichTextItem(text: "${QagStrings.toolbarPart1}\n", style: AgoraRichTextItemStyle.bold),
                          AgoraRichTextItem(text: QagStrings.toolbarPart2, style: AgoraRichTextItemStyle.regular),
                        ],
                      ),
                      Spacer(),
                      _InfoBouton(),
                    ],
                  ),
                ),
                SizedBox(height: AgoraSpacings.base),
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
      ),
    );
  }
}

class _InfoBouton extends StatelessWidget {
  const _InfoBouton();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: AgoraSpacings.x0_5),
      child: AgoraMoreInformation(
        semanticsLabel: SemanticsStrings.moreInformationAboutGovernmentResponse,
        onClick: () {
          showAgoraDialog(
            context: context,
            columnChildren: [
              Text(ReponseStrings.qagResponseInfoBubble, style: AgoraTextStyles.light16),
              SizedBox(height: AgoraSpacings.x0_75),
              AgoraButton(
                label: GenericStrings.close,
                buttonStyle: AgoraButtonStyle.primary,
                onPressed: () => Navigator.pop(context),
              ),
            ],
          );
        },
      ),
    );
  }
}
