import 'package:agora/common/analytics/analytics_event_names.dart';
import 'package:agora/common/analytics/analytics_screen_names.dart';
import 'package:agora/common/helper/tracker_helper.dart';
import 'package:agora/common/manager/repository_manager.dart';
import 'package:agora/common/strings/qag_strings.dart';
import 'package:agora/common/strings/reponse_strings.dart';
import 'package:agora/common/strings/semantics_strings.dart';
import 'package:agora/design/custom_view/agora_bottom_sheet.dart';
import 'package:agora/design/custom_view/agora_focus_helper.dart';
import 'package:agora/design/custom_view/agora_main_toolbar.dart';
import 'package:agora/design/custom_view/agora_more_information.dart';
import 'package:agora/design/custom_view/agora_tracker.dart';
import 'package:agora/design/custom_view/text/agora_rich_text.dart';
import 'package:agora/design/style/agora_colors.dart';
import 'package:agora/design/style/agora_corners.dart';
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
import 'package:flutter_svg/flutter_svg.dart';

class QagsPage extends StatefulWidget {
  static const routeName = "/qagsPage";

  @override
  State<QagsPage> createState() => _QagsPageState();
}

class _QagsPageState extends State<QagsPage> {
  final firstFocusableElementKey = GlobalKey();
  final toolbarTitleKey = GlobalKey();
  final onSearchAnchorKey = GlobalKey();
  final firstThematiqueKey = GlobalKey();
  String? currentThematiqueId;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      toolbarTitleKey.currentContext?.findRenderObject()?.sendSemanticsEvent(FocusSemanticEvent());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: _PoserMaQuestionBouton(),
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
                      AgoraFocusHelper(
                        elementKey: firstFocusableElementKey,
                        child: _InfoBouton(focusKey: firstFocusableElementKey),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: AgoraSpacings.base),
                QagsSection(
                  key: onSearchAnchorKey,
                  firstThematiqueKey: firstThematiqueKey,
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

class _PoserMaQuestionBouton extends StatelessWidget {
  const _PoserMaQuestionBouton();

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 200),
      curve: Curves.easeIn,
      child: FloatingActionButton.extended(
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
        backgroundColor: AgoraColors.primaryBlue,
        focusColor: AgoraColors.neutral400,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(AgoraCorners.rounded)),
        icon: SvgPicture.asset(
          "assets/ic_question.svg",
          colorFilter: const ColorFilter.mode(AgoraColors.white, BlendMode.srcIn),
          excludeFromSemantics: true,
        ),
        label: Text(
          QagStrings.askQuestion,
          style: AgoraTextStyles.medium14.copyWith(color: AgoraColors.white),
        ),
      ),
    );
  }
}

class _InfoBouton extends StatelessWidget {
  final GlobalKey focusKey;

  const _InfoBouton({required this.focusKey});

  @override
  Widget build(BuildContext context) {
    return Padding(
      key: focusKey,
      padding: const EdgeInsets.only(left: AgoraSpacings.x0_5),
      child: AgoraMoreInformation(
        semanticsLabel: SemanticsStrings.moreInformationAboutGovernmentResponse,
        onClick: () {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            backgroundColor: AgoraColors.transparent,
            builder: (context) => AgoraInformationBottomSheet(
              title: "Informations",
              description: Text(
                ReponseStrings.qagResponseInfoBubble,
                style: AgoraTextStyles.light16,
                textAlign: TextAlign.center,
              ),
            ),
          );
        },
      ),
    );
  }
}
