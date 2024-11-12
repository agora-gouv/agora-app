import 'package:agora/common/analytics/analytics_event_names.dart';
import 'package:agora/common/analytics/analytics_screen_names.dart';
import 'package:agora/common/helper/semantics_helper.dart';
import 'package:agora/common/helper/timer_helper.dart';
import 'package:agora/common/helper/tracker_helper.dart';
import 'package:agora/common/strings/qag_strings.dart';
import 'package:agora/design/custom_view/agora_search_bar.dart';
import 'package:agora/design/style/agora_colors.dart';
import 'package:agora/design/style/agora_spacings.dart';
import 'package:agora/design/style/agora_text_styles.dart';
import 'package:agora/qag/ask/bloc/search/qag_search_bloc.dart';
import 'package:agora/qag/ask/bloc/search/qag_search_event.dart';
import 'package:agora/qag/ask/pages/qag_search_input_utils.dart';
import 'package:agora/qag/ask/pages/qags_search.dart';
import 'package:agora/qag/domain/qas_list_filter.dart';
import 'package:agora/qag/list/bloc/qag_list_bloc.dart';
import 'package:agora/qag/list/bloc/qag_list_event.dart';
import 'package:agora/qag/list/pages/qag_list_section.dart';
import 'package:agora/qag/pages/qags_page.dart';
import 'package:agora/qag/widgets/qags_thematique_section.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class QagsSection extends StatefulWidget {
  final GlobalKey firstThematiqueKey;
  final String? currentThematiqueId;
  final String? currentThematiqueLabel;
  final QagTab currentSelectedTab;
  final Function(String? id, String? label) onThematiqueSelected;
  final Function(QagTab tab) onSelectedTab;
  final Function(bool) onSearchBarOpen;

  const QagsSection({
    super.key,
    required this.currentThematiqueId,
    required this.currentThematiqueLabel,
    required this.currentSelectedTab,
    required this.firstThematiqueKey,
    required this.onThematiqueSelected,
    required this.onSelectedTab,
    required this.onSearchBarOpen,
  });

  @override
  State<QagsSection> createState() => _QagsSectionState();
}

class _QagsSectionState extends State<QagsSection> {
  String previousSearchKeywords = '';
  String previousSearchKeywordsSanitized = '';
  bool isActiveSearchBar = false;
  bool isActiveTrendingTab = true;

  final timerHelper = TimerHelper(countdownDurationInSecond: 1);

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final TextEditingController textController = TextEditingController(text: previousSearchKeywords);

    textController.addListener(() {
      previousSearchKeywords = textController.text;
      previousSearchKeywordsSanitized = processNewInput(
        context,
        textController,
        timerHelper,
        previousSearchKeywordsSanitized,
      );
    });

    final isThematiquesVisible = !isActiveSearchBar && widget.currentSelectedTab != QagTab.trending;

    return _Content(
      currentThematiqueId: widget.currentThematiqueId,
      currentThematiqueLabel: widget.currentThematiqueLabel,
      textController: textController,
      isThematiquesVisible: isThematiquesVisible,
      firstThematiqueKey: widget.firstThematiqueKey,
      isActiveSearchBar: isActiveSearchBar,
      currentSelectedTab: widget.currentSelectedTab,
      onSearchBarOpen: (bool isSearchOpen) {
        setState(() => isActiveSearchBar = isSearchOpen);
        widget.onSelectedTab(isSearchOpen ? QagTab.search : QagTab.trending);
        widget.onSearchBarOpen(isActiveSearchBar);
      },
      onSearchBarClose: () {
        setState(() {
          textController.clear();
          isActiveSearchBar = false;
        });
        widget.onSelectedTab(QagTab.trending);
        widget.onSearchBarOpen(isActiveSearchBar);
      },
      onSelectedTab: widget.onSelectedTab,
      onThematiqueSelected: (String? thematiqueId, String? thematicLabel) {
        if (thematiqueId == widget.currentThematiqueId) {
          widget.onThematiqueSelected(null, null);
        } else {
          widget.onThematiqueSelected(thematiqueId, thematicLabel);
          TrackerHelper.trackClick(
            clickName: "${AnalyticsEventNames.thematique} $widget.currentThematiqueId",
            widgetName: AnalyticsScreenNames.qagsPage,
          );
        }
      },
    );
  }
}

class _Content extends StatelessWidget {
  final String? currentThematiqueId;
  final String? currentThematiqueLabel;
  final TextEditingController textController;
  final bool isThematiquesVisible;
  final GlobalKey firstThematiqueKey;
  final Function(bool) onSearchBarOpen;
  final void Function() onSearchBarClose;
  final bool isActiveSearchBar;
  final QagTab currentSelectedTab;
  final void Function(QagTab) onSelectedTab;
  final void Function(String? thematiqueId, String? thematicLabel) onThematiqueSelected;

  const _Content({
    required this.currentThematiqueId,
    required this.currentThematiqueLabel,
    required this.textController,
    required this.isThematiquesVisible,
    required this.firstThematiqueKey,
    required this.onSearchBarOpen,
    required this.onSearchBarClose,
    required this.isActiveSearchBar,
    required this.currentSelectedTab,
    required this.onSelectedTab,
    required this.onThematiqueSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.max,
      children: [
        _TabBar(
          textController,
          onSearchBarOpen,
          () {
            onSearchBarClose();
            context.read<QagSearchBloc>().add(FetchQagsInitialEvent());
          },
          isActiveSearchBar,
          currentSelectedTab,
          (QagTab tab) {
            onSelectedTab(tab);
            context.read<QagListBloc>().add(
                  FetchQagsListEvent(
                    thematiqueId: currentThematiqueId,
                    thematiqueLabel: currentThematiqueLabel,
                    qagFilter: toQagListFilter(tab),
                  ),
                );
          },
        ),
        _ThematiqueFilter(
          isThematiquesVisible: isThematiquesVisible,
          firstThematiqueKey: firstThematiqueKey,
          currentThematiqueId: currentThematiqueId,
          currentThematiqueLabel: currentThematiqueLabel,
          currentSelectedTab: currentSelectedTab,
          onThematiqueSelected: onThematiqueSelected,
        ),
        Padding(
          padding: isThematiquesVisible
              ? const EdgeInsets.symmetric(vertical: AgoraSpacings.base)
              : const EdgeInsets.only(bottom: AgoraSpacings.base),
          child: _Qags(currentSelectedTab, currentThematiqueId, currentThematiqueLabel),
        ),
      ],
    );
  }
}

class _TabBar extends StatelessWidget {
  final TextEditingController textController;
  final void Function(bool) onSearchBarOpen;
  final void Function() onSearchBarClose;
  final bool isActiveSearchBar;
  final QagTab currentSelectedTab;
  final void Function(QagTab) onSelectedTab;

  _TabBar(
    this.textController,
    this.onSearchBarOpen,
    this.onSearchBarClose,
    this.isActiveSearchBar,
    this.currentSelectedTab,
    this.onSelectedTab,
  );

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: AgoraSpacings.x0_5, top: AgoraSpacings.x0_75, bottom: AgoraSpacings.base),
      child: Scrollbar(
        child: LayoutBuilder(
          builder: (context, constraint) {
            return SingleChildScrollView(
              padding: const EdgeInsets.only(bottom: AgoraSpacings.x0_5),
              scrollDirection: Axis.horizontal,
              child: ConstrainedBox(
                constraints: BoxConstraints(minWidth: constraint.maxWidth),
                child: IntrinsicWidth(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      AnimSearchBar(
                        height: 48,
                        width: MediaQuery.of(context).size.width * 0.95,
                        textController: textController,
                        textFieldColor: AgoraColors.doctor,
                        color: AgoraColors.transparent,
                        onClose: onSearchBarClose,
                        helpText: QagStrings.searchQagHint,
                        textInputAction: TextInputAction.search,
                        onClearText: () {},
                        onSubmitted: (String e) {},
                        autoFocus: true,
                        isSearchBarDisplayed: isActiveSearchBar,
                        searchBarOpen: (bool isSearchOpen) => onSearchBarOpen(isSearchOpen),
                      ),
                      Expanded(
                        child: Visibility(
                          visible: !isActiveSearchBar,
                          child: Semantics(
                            label: 'Liste des catégories, 4 éléments',
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                _QagFilterTabButton(
                                  tabLabel: QagStrings.trending,
                                  isSelectedTab: currentSelectedTab == QagTab.trending,
                                  semanticTooltip: 'Élément 1 sur 4',
                                  onSelectedTab: () => onSelectedTab(QagTab.trending),
                                ),
                                _QagFilterTabButton(
                                  tabLabel: QagStrings.top,
                                  isSelectedTab: currentSelectedTab == QagTab.top,
                                  semanticTooltip: 'Élément 2 sur 4',
                                  onSelectedTab: () => onSelectedTab(QagTab.top),
                                ),
                                _QagFilterTabButton(
                                  tabLabel: QagStrings.latest,
                                  isSelectedTab: currentSelectedTab == QagTab.latest,
                                  semanticTooltip: 'Élément 3 sur 4',
                                  onSelectedTab: () => onSelectedTab(QagTab.latest),
                                ),
                                _QagFilterTabButton(
                                  tabLabel: QagStrings.supporting,
                                  isSelectedTab: currentSelectedTab == QagTab.supporting,
                                  semanticTooltip: 'Élément 4 sur 4',
                                  onSelectedTab: () => onSelectedTab(QagTab.supporting),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _ThematiqueFilter extends StatelessWidget {
  final bool isThematiquesVisible;
  final GlobalKey firstThematiqueKey;
  final String? currentThematiqueId;
  final String? currentThematiqueLabel;
  final QagTab currentSelectedTab;
  final void Function(String?, String?) onThematiqueSelected;

  const _ThematiqueFilter({
    required this.isThematiquesVisible,
    required this.firstThematiqueKey,
    required this.currentSelectedTab,
    required this.onThematiqueSelected,
    this.currentThematiqueId,
    this.currentThematiqueLabel,
  });

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: isThematiquesVisible,
      child: QagsThematiqueSection(
        firstThematiqueKey: firstThematiqueKey,
        currentThematiqueId: currentThematiqueId,
        onThematiqueSelected: (String? thematiqueId, String? thematicLabel) {
          if (currentThematiqueId != null || thematiqueId != null) {
            onThematiqueSelected(thematiqueId, thematicLabel);
            context.read<QagListBloc>().add(
                  FetchQagsListEvent(
                    thematiqueId: thematiqueId,
                    thematiqueLabel: thematicLabel,
                    qagFilter: toQagListFilter(currentSelectedTab),
                  ),
                );
          }
        },
      ),
    );
  }
}

class _QagFilterTabButton extends StatelessWidget {
  final String tabLabel;
  final bool isSelectedTab;
  final String semanticTooltip;
  final void Function() onSelectedTab;

  const _QagFilterTabButton({
    required this.tabLabel,
    required this.isSelectedTab,
    required this.semanticTooltip,
    required this.onSelectedTab,
  });

  @override
  Widget build(BuildContext context) {
    return Semantics(
      header: true,
      button: true,
      selected: isSelectedTab,
      tooltip: semanticTooltip,
      child: _TabButton(
        label: tabLabel,
        isSelected: isSelectedTab,
        onTap: () {
          TrackerHelper.trackClick(
            clickName: AnalyticsEventNames.qagSupporting,
            widgetName: AnalyticsScreenNames.qagsPage,
          );
          if (!isSelectedTab) {
            Future.delayed(Duration(seconds: 1)).then((value) => SemanticsHelper.announceNewQagsInList());
            onSelectedTab();
          }
        },
      ),
    );
  }
}

class _TabButton extends StatelessWidget {
  final String label;
  final bool isSelected;
  final void Function() onTap;

  const _TabButton({required this.label, required this.isSelected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onTap(),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.all(AgoraSpacings.base),
            child: Text(label, style: isSelected ? AgoraTextStyles.medium14 : AgoraTextStyles.light14),
          ),
          if (isSelected)
            Container(
              color: AgoraColors.blue525,
              height: 3,
              width: MediaQuery.of(context).size.width * 0.3,
            ),
        ],
      ),
    );
  }
}

class _Qags extends StatelessWidget {
  final QagTab currentSelected;
  final String? currentThematiqueId;
  final String? currentThematiqueLabel;

  const _Qags(this.currentSelected, this.currentThematiqueId, this.currentThematiqueLabel);

  @override
  Widget build(BuildContext context) {
    switch (currentSelected) {
      case QagTab.search:
        return QagSearch();
      case QagTab.trending:
        return QagListSection(
          qagFilter: QagListFilter.trending,
          thematiqueId: currentThematiqueId,
          thematiqueLabel: currentThematiqueLabel,
        );
      case QagTab.top:
        return QagListSection(
          qagFilter: QagListFilter.top,
          thematiqueId: currentThematiqueId,
          thematiqueLabel: currentThematiqueLabel,
        );
      case QagTab.latest:
        return QagListSection(
          qagFilter: QagListFilter.latest,
          thematiqueId: currentThematiqueId,
          thematiqueLabel: currentThematiqueLabel,
        );
      case QagTab.supporting:
        return QagListSection(
          qagFilter: QagListFilter.supporting,
          thematiqueId: currentThematiqueId,
          thematiqueLabel: currentThematiqueLabel,
        );
    }
  }
}
