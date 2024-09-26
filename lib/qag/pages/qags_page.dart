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
import 'package:agora/design/custom_view/button/agora_button.dart';
import 'package:agora/design/custom_view/text/agora_rich_text.dart';
import 'package:agora/design/style/agora_colors.dart';
import 'package:agora/design/style/agora_spacings.dart';
import 'package:agora/design/style/agora_text_styles.dart';
import 'package:agora/qag/ask/bloc/ask_qag_status_bloc.dart';
import 'package:agora/qag/ask/bloc/ask_qag_status_event.dart';
import 'package:agora/qag/ask/bloc/ask_qag_status_state.dart';
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
  final scrollController = ScrollController();
  String? currentThematiqueId;
  ValueNotifier<bool> showLabelFloatingButton = ValueNotifier(true);

  @override
  void initState() {
    super.initState();
    scrollController.addListener(() {
      if (scrollController.offset > 50 && showLabelFloatingButton.value) {
        showLabelFloatingButton.value = false;
      } else if (scrollController.offset < 50 && !showLabelFloatingButton.value) {
        showLabelFloatingButton.value = true;
      }
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      toolbarTitleKey.currentContext?.findRenderObject()?.sendSemanticsEvent(FocusSemanticEvent());
    });
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AgoraTracker(
      widgetName: AnalyticsScreenNames.qagsPage,
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            lazy: false,
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
        child: Scaffold(
          floatingActionButton: ListenableBuilder(
            listenable: showLabelFloatingButton,
            builder: (context, __) => _PoserMaQuestionBouton(
              showLabelFloatingButton: showLabelFloatingButton.value,
              onTap: () {
                final askQagStatusState = BlocProvider.of<AskQagStatusBloc>(context).state;
                String? errorLabel;
                if (askQagStatusState is AskQagStatusFetchedState) {
                  errorLabel = askQagStatusState.askQagError;
                }
                TrackerHelper.trackClick(
                  clickName: AnalyticsEventNames.askQuestion,
                  widgetName: AnalyticsScreenNames.qagsPage,
                );
                Navigator.pushNamed(
                  context,
                  QagAskQuestionPage.routeName,
                  arguments: errorLabel,
                );
              },
            ),
          ),
          body: SingleChildScrollView(
            controller: scrollController,
            physics: ClampingScrollPhysics(),
            child: Column(
              children: [
                AgoraMainToolbar(
                  title: Row(
                    children: [
                      Expanded(
                        child: AgoraRichText(
                          key: toolbarTitleKey,
                          policeStyle: AgoraRichTextPoliceStyle.toolbar,
                          semantic: AgoraRichTextSemantic(focused: true),
                          items: [
                            AgoraRichTextItem(text: "${QagStrings.toolbarPart1}\n", style: AgoraRichTextItemStyle.bold),
                            AgoraRichTextItem(text: QagStrings.toolbarPart2, style: AgoraRichTextItemStyle.regular),
                          ],
                        ),
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
  final bool showLabelFloatingButton;
  final void Function() onTap;

  const _PoserMaQuestionBouton({required this.showLabelFloatingButton, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return AgoraButton.withChildren(
      buttonStyle: AgoraButtonStyle.primary,
      semanticLabel: QagStrings.askQuestion,
      onPressed: onTap,
      children: [
        SvgPicture.asset(
          "assets/ic_question.svg",
          colorFilter: const ColorFilter.mode(AgoraColors.white, BlendMode.srcIn),
          excludeFromSemantics: true,
        ),
        AnimatedSwitcher(
          duration: Duration(milliseconds: 300),
          transitionBuilder: (Widget child, Animation<double> animation) {
            return SizeTransition(
              axis: Axis.horizontal,
              axisAlignment: 1.0,
              sizeFactor: animation,
              child: child,
            );
          },
          child: showLabelFloatingButton
              ? Padding(
                  padding: const EdgeInsets.only(left: 8),
                  child: Text(
                    QagStrings.askQuestion,
                    key: ValueKey(1),
                    style: AgoraTextStyles.primaryButton,
                  ),
                )
              : SizedBox(key: ValueKey(2)),
        ),
      ],
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
