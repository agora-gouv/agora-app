import 'package:agora/common/analytics/analytics_event_names.dart';
import 'package:agora/common/analytics/analytics_screen_names.dart';
import 'package:agora/common/extension/string_extension.dart';
import 'package:agora/common/helper/all_purpose_status.dart';
import 'package:agora/common/helper/tracker_helper.dart';
import 'package:agora/common/manager/repository_manager.dart';
import 'package:agora/common/strings/qag_strings.dart';
import 'package:agora/common/strings/semantics_strings.dart';
import 'package:agora/design/custom_view/agora_focus_helper.dart';
import 'package:agora/design/custom_view/agora_main_toolbar.dart';
import 'package:agora/design/custom_view/agora_more_information.dart';
import 'package:agora/design/custom_view/agora_tracker.dart';
import 'package:agora/design/custom_view/bottom_sheet/agora_bottom_sheet.dart';
import 'package:agora/design/custom_view/button/agora_button.dart';
import 'package:agora/design/custom_view/error/agora_error_view.dart';
import 'package:agora/design/custom_view/skeletons.dart';
import 'package:agora/design/custom_view/text/agora_rich_text.dart';
import 'package:agora/design/style/agora_colors.dart';
import 'package:agora/design/style/agora_spacings.dart';
import 'package:agora/design/style/agora_text_styles.dart';
import 'package:agora/qag/ask/bloc/ask_qag_status_bloc.dart';
import 'package:agora/qag/ask/bloc/ask_qag_status_event.dart';
import 'package:agora/qag/ask/bloc/ask_qag_status_state.dart';
import 'package:agora/qag/ask/bloc/search/qag_search_bloc.dart';
import 'package:agora/qag/ask/pages/qag_ask_question_page.dart';
import 'package:agora/qag/info/bloc/qags_info_bloc.dart';
import 'package:agora/qag/info/bloc/qags_info_event.dart';
import 'package:agora/qag/info/bloc/qags_info_state.dart';
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
          BlocProvider(
            create: (context) => QagsInfoBloc(
              qagRepository: RepositoryManager.getQagRepository(),
            )..add(FetchQagsInfoEvent()),
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
            child: BlocBuilder<QagsInfoBloc, QagsInfoState>(
              builder: (context, qagInfoState) => Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
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
                              AgoraRichTextItem(
                                text: "${QagStrings.toolbarPart1}\n",
                                style: AgoraRichTextItemStyle.bold,
                              ),
                              AgoraRichTextItem(text: QagStrings.toolbarPart2, style: AgoraRichTextItemStyle.regular),
                            ],
                          ),
                        ),
                        SizedBox(width: AgoraSpacings.base),
                        AgoraFocusHelper(
                          elementKey: firstFocusableElementKey,
                          child: _InfoBouton(focusKey: firstFocusableElementKey, state: qagInfoState),
                        ),
                      ],
                    ),
                  ),
                  switch (qagInfoState.status) {
                    AllPurposeStatus.error => SizedBox(),
                    AllPurposeStatus.notLoaded || AllPurposeStatus.loading => Padding(
                        padding: const EdgeInsets.symmetric(horizontal: AgoraSpacings.horizontalPadding),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: AgoraSpacings.base),
                            SkeletonBox(height: 12, width: 300, radius: 15),
                            SizedBox(height: 4),
                            SkeletonBox(height: 12, width: 200, radius: 15),
                            SizedBox(height: 4),
                            SkeletonBox(height: 12, width: 220, radius: 15),
                          ],
                        ),
                      ),
                    AllPurposeStatus.success => qagInfoState.texteTotalQuestions.isNotBlank()
                        ? Padding(
                            padding: const EdgeInsets.fromLTRB(
                              AgoraSpacings.horizontalPadding,
                              AgoraSpacings.base,
                              AgoraSpacings.horizontalPadding,
                              0,
                            ),
                            child: Text(qagInfoState.texteTotalQuestions, style: AgoraTextStyles.light14),
                          )
                        : SizedBox(),
                  },
                  QagsSection(
                    key: onSearchAnchorKey,
                    firstThematiqueKey: firstThematiqueKey,
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
  final QagsInfoState state;

  const _InfoBouton({required this.focusKey, required this.state});

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
              titre: "Informations",
              description: _InfoBottomSheetContent(state: state),
            ),
          );
        },
      ),
    );
  }
}

class _InfoBottomSheetContent extends StatelessWidget {
  final QagsInfoState state;

  const _InfoBottomSheetContent({required this.state});

  @override
  Widget build(BuildContext context) {
    return switch (state.status) {
      AllPurposeStatus.notLoaded || AllPurposeStatus.loading => Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(height: AgoraSpacings.x2),
            SkeletonBox(height: 15, width: 200, radius: 15),
            SizedBox(height: AgoraSpacings.base),
            SkeletonBox(height: 15, width: 200, radius: 15),
            SizedBox(height: AgoraSpacings.base),
            SkeletonBox(height: 15, width: 200, radius: 15),
            SizedBox(height: AgoraSpacings.x2),
          ],
        ),
      AllPurposeStatus.error => AgoraErrorView(
          onReload: () => context.read<QagsInfoBloc>().add(FetchQagsInfoEvent()),
        ),
      AllPurposeStatus.success => Text(
          state.infoText,
          style: AgoraTextStyles.light16,
          textAlign: TextAlign.center,
        ),
    };
  }
}
