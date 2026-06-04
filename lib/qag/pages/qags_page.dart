import 'package:agora/common/analytics/analytics_event_names.dart';
import 'package:agora/common/analytics/analytics_screen_names.dart';
import 'package:agora/common/helper/all_purpose_status.dart';
import 'package:agora/common/helper/tracker_helper.dart';
import 'package:agora/common/manager/repository_manager.dart';
import 'package:agora/common/manager/storage_manager.dart';
import 'package:agora/common/strings/qag_strings.dart';
import 'package:agora/common/strings/semantics_strings.dart';
import 'package:agora/design/custom_view/agora_focus_helper.dart';
import 'package:agora/design/custom_view/agora_main_toolbar.dart';
import 'package:agora/design/custom_view/agora_more_information.dart';
import 'package:agora/design/custom_view/agora_pull_to_refresh.dart';
import 'package:agora/design/custom_view/agora_tracker.dart';
import 'package:agora/design/custom_view/button/agora_button.dart';
import 'package:agora/design/custom_view/skeletons.dart';
import 'package:agora/design/custom_view/text/agora_rich_text.dart';
import 'package:agora/design/style/agora_colors.dart';
import 'package:agora/design/style/agora_corners.dart';
import 'package:agora/design/style/agora_spacings.dart';
import 'package:agora/design/style/agora_text_styles.dart';
import 'package:agora/qag/ask/bloc/ask_qag_status_bloc.dart';
import 'package:agora/qag/ask/bloc/ask_qag_status_event.dart';
import 'package:agora/qag/ask/bloc/search/qag_search_bloc.dart';
import 'package:agora/qag/ask/pages/qag_ask_question_page.dart';
import 'package:agora/qag/domain/qag_theme_hebdo.dart';
import 'package:agora/qag/domain/qas_list_filter.dart';
import 'package:agora/qag/info/bloc/qags_info_bloc.dart';
import 'package:agora/qag/info/bloc/qags_info_event.dart';
import 'package:agora/qag/info/bloc/qags_info_state.dart';
import 'package:agora/qag/info/qags_info_bottom_sheet.dart';
import 'package:agora/qag/list/bloc/qag_list_bloc.dart';
import 'package:agora/qag/list/bloc/qag_list_event.dart';
import 'package:agora/qag/theme/bloc/qags_theme_bloc.dart';
import 'package:agora/qag/theme/bloc/qags_theme_event.dart';
import 'package:agora/qag/theme/bloc/qags_theme_state.dart';
import 'package:agora/qag/widgets/qags_section.dart';
import 'package:agora/thematique/bloc/thematique_bloc.dart';
import 'package:agora/thematique/bloc/thematique_event.dart';
import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

enum QagTab { search, trending, top, latest, supporting }

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
  ValueNotifier<bool> showLabelFloatingButton = ValueNotifier(true);

  String? currentThematiqueId;
  String? currentThematiqueLabel;
  QagTab currentSelectedTab = QagTab.trending;

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
          BlocProvider(
            create: (context) => QagsThemeBloc(
              qagRepository: RepositoryManager.getQagRepository(),
            )..add(FetchQagsThemeEvent()),
          ),
          BlocProvider(
            lazy: false,
            create: (context) => QagListBloc(
              qagRepository: RepositoryManager.getQagRepository(),
              headerQagStorageClient: StorageManager.getHeaderQagStorageClient(),
            )..add(
                FetchQagsListEvent(
                  thematiqueId: currentThematiqueId,
                  thematiqueLabel: currentThematiqueLabel,
                  qagFilter: toQagListFilter(currentSelectedTab),
                  forceRefresh: true,
                ),
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
                if (askQagStatusState.status == AllPurposeStatus.success) {
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
          body: BlocBuilder<QagsInfoBloc, QagsInfoState>(
            builder: (context, qagInfoState) => Column(
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
                            AgoraRichTextItem(
                              text: QagStrings.toolbarPart2,
                              style: AgoraRichTextItemStyle.regular,
                            ),
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
                Expanded(
                  child: AgoraPullToRefresh(
                    onRefresh: () async {
                      context.read<QagsThemeBloc>().add(FetchQagsThemeEvent());
                      context.read<QagListBloc>().add(
                            FetchQagsListEvent(
                              thematiqueId: currentThematiqueId,
                              thematiqueLabel: currentThematiqueLabel,
                              qagFilter: toQagListFilter(currentSelectedTab),
                              forceRefresh: true,
                            ),
                          );
                    },
                    child: SingleChildScrollView(
                      physics: ClampingScrollPhysics(),
                      controller: scrollController,
                      child: ConstrainedBox(
                        constraints: BoxConstraints(minHeight: MediaQuery.of(context).size.height - 100),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            BlocBuilder<QagsThemeBloc, QagsThemeState>(
                              builder: (context, qagThemeState) {
                                switch (qagThemeState.status) {
                                  case AllPurposeStatus.error:
                                    return SizedBox();
                                  case AllPurposeStatus.notLoaded || AllPurposeStatus.loading:
                                    return Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                        AgoraSpacings.horizontalPadding,
                                        AgoraSpacings.base,
                                        AgoraSpacings.horizontalPadding,
                                        0,
                                      ),
                                      child: SkeletonBox(height: 300, width: 300, radius: 15),
                                    );
                                  case AllPurposeStatus.success:
                                    final QagThemeHebdo theme = qagThemeState.qagThemeHebdo!;
                                    return Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                        AgoraSpacings.horizontalPadding,
                                        AgoraSpacings.base,
                                        AgoraSpacings.horizontalPadding,
                                        0,
                                      ),
                                      child: _TuileSemaine(theme: theme),
                                    );
                                }
                              },
                            ),
                            QagsSection(
                              key: onSearchAnchorKey,
                              firstThematiqueKey: firstThematiqueKey,
                              currentThematiqueId: currentThematiqueId,
                              currentThematiqueLabel: currentThematiqueLabel,
                              currentSelectedTab: currentSelectedTab,
                              onSelectedTab: (QagTab tab) => setState(() => currentSelectedTab = tab),
                              onThematiqueSelected: (String? thematiqueId, String? thematiqueLabel) {
                                setState(() {
                                  currentThematiqueId = thematiqueId;
                                  currentThematiqueLabel = thematiqueLabel;
                                });
                              },
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _TuileSemaine extends StatelessWidget {
  final QagThemeHebdo theme;

  const _TuileSemaine({required this.theme});

  @override
  Widget build(BuildContext context) => Material(
        textStyle: AgoraTextStyles.regular14White,
        color: AgoraColors.primaryBlue,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(AgoraCorners.rounded12),
        ),
        child: Padding(
          padding: const EdgeInsets.all(AgoraSpacings.base),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("${theme.titre}  ·  ${theme.periode}", style: AgoraTextStyles.medium16White),
              SizedBox(height: AgoraSpacings.base),
              Text(theme.sousTitre),
              SizedBox(height: AgoraSpacings.x0_25),
              Text(theme.theme, style: AgoraTextStyles.medium32White),
              SizedBox(height: AgoraSpacings.x0_5),
              Row(
                children: [
                  SizedBox(
                    width: 48,
                    height: 48,
                    child: ClipOval(
                      child: Image.network(theme.avatarUrl),
                    ),
                  ),
                  SizedBox(width: AgoraSpacings.x0_5),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(theme.nom, style: AgoraTextStyles.medium16White),
                        SizedBox(height: AgoraSpacings.x0_25),
                        Text(theme.fonction, style: AgoraTextStyles.light14White),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: AgoraSpacings.base),
              Row(
                children: [
                  SvgPicture.asset(
                    "assets/ic_timer.svg",
                    colorFilter: ColorFilter.mode(AgoraColors.white, BlendMode.srcIn),
                    width: 16,
                    height: 16,
                  ),
                  SizedBox(width: AgoraSpacings.x0_5),
                  Text("${theme.titreCompteur} ${theme.dateFinTheme}", style: AgoraTextStyles.medium14White),
                ],
              ),
              SizedBox(height: AgoraSpacings.x0_5),
              if (theme.prochainsThemes.isNotEmpty) ...[
                Divider(thickness: 1, color: AgoraColors.invertedBlueFrance),
                SizedBox(height: AgoraSpacings.x0_5),
                Text("LES PROCHAINES SEMAINES"),
                SizedBox(height: AgoraSpacings.base),
                Row(
                  children: theme.prochainsThemes
                      .map(
                        (prochainTheme) => Container(
                          margin: EdgeInsetsGeometry.only(right: AgoraSpacings.x0_5),
                          decoration: BoxDecoration(
                            border: Border.all(width: 1, color: AgoraColors.white),
                            borderRadius: BorderRadius.circular(50),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              vertical: AgoraSpacings.x0_25,
                              horizontal: AgoraSpacings.x0_5,
                            ),
                            child: Text(prochainTheme),
                          ),
                        ),
                      )
                      .toList(),
                ),
              ],
            ],
          ),
        ),
      );
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
                  padding: const EdgeInsets.only(left: AgoraSpacings.x0_5),
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
            builder: (context) => QagsInformationBottomSheet(),
          );
        },
      ),
    );
  }
}
