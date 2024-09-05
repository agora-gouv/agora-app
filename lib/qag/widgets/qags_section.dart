import 'package:agora/common/analytics/analytics_event_names.dart';
import 'package:agora/common/analytics/analytics_screen_names.dart';
import 'package:agora/common/helper/semantics_helper.dart';
import 'package:agora/common/helper/timer_helper.dart';
import 'package:agora/common/helper/tracker_helper.dart';
import 'package:agora/common/manager/repository_manager.dart';
import 'package:agora/common/manager/storage_manager.dart';
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
import 'package:agora/qag/widgets/qags_thematique_section.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

enum QagTab { search, trending, top, latest, supporting }

class QagsSection extends StatefulWidget {
  final QagTab defaultSelected;
  final String? selectedThematiqueId;
  final GlobalKey firstThematiqueKey;
  final Function(bool) onSearchBarOpen;

  const QagsSection({
    super.key,
    required this.defaultSelected,
    required this.selectedThematiqueId,
    required this.firstThematiqueKey,
    required this.onSearchBarOpen,
  });

  @override
  State<QagsSection> createState() => _QagsSectionState();
}

class _QagsSectionState extends State<QagsSection> {
  late QagTab currentSelected;
  String? currentThematiqueId;
  String? currentThematiqueLabel;
  String previousSearchKeywords = '';
  String previousSearchKeywordsSanitized = '';
  bool isActiveSearchBar = false;
  bool isActiveTrendingTab = true;

  final timerHelper = TimerHelper(countdownDurationInSecond: 1);

  @override
  void initState() {
    super.initState();
    currentSelected = widget.defaultSelected;
  }

  @override
  Widget build(BuildContext context) {
    final isThematiquesVisible = !isActiveSearchBar && currentSelected != QagTab.trending;
    return BlocProvider(
      create: (context) => QagListBloc(
        qagRepository: RepositoryManager.getQagRepository(),
        headerQagStorageClient: StorageManager.getHeaderQagStorageClient(),
      )..add(
          FetchQagsListEvent(
            thematiqueId: currentThematiqueId,
            thematiqueLabel: currentThematiqueLabel,
            qagFilter: QagListFilter.trending,
          ),
        ),
      child: Column(
        children: [
          _buildTabBar(),
          Visibility(
            visible: isThematiquesVisible,
            child: QagsThematiqueSection(
              firstThematiqueKey: widget.firstThematiqueKey,
              currentThematiqueId: currentThematiqueId,
              onThematiqueIdSelected: (String? thematiqueId, String? thematicLabel) {
                if (currentThematiqueId != null || thematiqueId != null) {
                  setState(() {
                    if (thematiqueId == currentThematiqueId) {
                      currentThematiqueId = null;
                      currentThematiqueLabel = null;
                    } else {
                      currentThematiqueId = thematiqueId;
                      currentThematiqueLabel = thematicLabel;
                    }
                    TrackerHelper.trackClick(
                      clickName: "${AnalyticsEventNames.thematique} $currentThematiqueId",
                      widgetName: AnalyticsScreenNames.qagsPage,
                    );
                  });
                }
              },
            ),
          ),
          Padding(
            padding: isThematiquesVisible
                ? const EdgeInsets.symmetric(vertical: AgoraSpacings.base)
                : const EdgeInsets.only(bottom: AgoraSpacings.base),
            child: _buildQags(context),
          ),
        ],
      ),
    );
  }

  Widget _buildQags(BuildContext context) {
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

  Widget _buildTabBar() {
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
                        onClose: () {
                          setState(() {
                            textController.clear();
                            isActiveSearchBar = false;
                            currentSelected = QagTab.trending;
                          });
                          widget.onSearchBarOpen(isActiveSearchBar);
                          context.read<QagSearchBloc>().add(FetchQagsInitialEvent());
                        },
                        helpText: QagStrings.searchQagHint,
                        textInputAction: TextInputAction.search,
                        onClearText: () {},
                        onSubmitted: (String e) {},
                        autoFocus: true,
                        isSearchBarDisplayed: isActiveSearchBar,
                        searchBarOpen: (bool isSearchOpen) => {
                          setState(() {
                            isActiveSearchBar = isSearchOpen;
                            currentSelected = isSearchOpen ? QagTab.search : QagTab.trending;
                          }),
                          widget.onSearchBarOpen(isActiveSearchBar),
                        },
                      ),
                      Expanded(
                        child: Visibility(
                          visible: !isActiveSearchBar,
                          child: Semantics(
                            label: 'Liste des catégories, 4 éléments',
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Semantics(
                                  header: true,
                                  button: true,
                                  selected: currentSelected == QagTab.trending,
                                  tooltip: 'Élément 1 sur 4',
                                  child: _TabButton(
                                    label: QagStrings.trending,
                                    isSelected: currentSelected == QagTab.trending,
                                    onTap: () {
                                      TrackerHelper.trackClick(
                                        clickName: AnalyticsEventNames.qagTrending,
                                        widgetName: AnalyticsScreenNames.qagsPage,
                                      );
                                      if (currentSelected != QagTab.trending) {
                                        Future.delayed(Duration(seconds: 1))
                                            .then((value) => SemanticsHelper.announceNewQagsInList());
                                        setState(() {
                                          currentSelected = QagTab.trending;
                                          context.read<QagListBloc>().add(
                                                FetchQagsListEvent(
                                                  thematiqueId: currentThematiqueId,
                                                  thematiqueLabel: currentThematiqueLabel,
                                                  qagFilter: QagListFilter.trending,
                                                ),
                                              );
                                        });
                                      }
                                    },
                                  ),
                                ),
                                Semantics(
                                  header: true,
                                  button: true,
                                  selected: currentSelected == QagTab.top,
                                  tooltip: 'Élément 2 sur 4',
                                  child: _TabButton(
                                    label: QagStrings.popular,
                                    isSelected: currentSelected == QagTab.top,
                                    onTap: () {
                                      TrackerHelper.trackClick(
                                        clickName: AnalyticsEventNames.qagPopular,
                                        widgetName: AnalyticsScreenNames.qagsPage,
                                      );
                                      if (currentSelected != QagTab.top) {
                                        Future.delayed(Duration(seconds: 1))
                                            .then((value) => SemanticsHelper.announceNewQagsInList());
                                        setState(() {
                                          currentSelected = QagTab.top;
                                          context.read<QagListBloc>().add(
                                                FetchQagsListEvent(
                                                  thematiqueId: currentThematiqueId,
                                                  thematiqueLabel: currentThematiqueLabel,
                                                  qagFilter: QagListFilter.top,
                                                ),
                                              );
                                        });
                                      }
                                    },
                                  ),
                                ),
                                Semantics(
                                  header: true,
                                  button: true,
                                  selected: currentSelected == QagTab.latest,
                                  tooltip: 'Élément 3 sur 4',
                                  child: _TabButton(
                                    label: QagStrings.latest,
                                    isSelected: currentSelected == QagTab.latest,
                                    onTap: () {
                                      TrackerHelper.trackClick(
                                        clickName: AnalyticsEventNames.qagLatest,
                                        widgetName: AnalyticsScreenNames.qagsPage,
                                      );
                                      if (currentSelected != QagTab.latest) {
                                        Future.delayed(Duration(seconds: 1))
                                            .then((value) => SemanticsHelper.announceNewQagsInList());
                                        setState(() {
                                          currentSelected = QagTab.latest;
                                          context.read<QagListBloc>().add(
                                                FetchQagsListEvent(
                                                  thematiqueId: currentThematiqueId,
                                                  thematiqueLabel: currentThematiqueLabel,
                                                  qagFilter: QagListFilter.latest,
                                                ),
                                              );
                                        });
                                      }
                                    },
                                  ),
                                ),
                                Semantics(
                                  header: true,
                                  button: true,
                                  selected: currentSelected == QagTab.supporting,
                                  tooltip: 'Élément 4 sur 4',
                                  child: _TabButton(
                                    label: QagStrings.supporting,
                                    isSelected: currentSelected == QagTab.supporting,
                                    onTap: () {
                                      TrackerHelper.trackClick(
                                        clickName: AnalyticsEventNames.qagSupporting,
                                        widgetName: AnalyticsScreenNames.qagsPage,
                                      );
                                      if (currentSelected != QagTab.supporting) {
                                        Future.delayed(Duration(seconds: 1))
                                            .then((value) => SemanticsHelper.announceNewQagsInList());
                                        setState(() {
                                          currentSelected = QagTab.supporting;
                                          context.read<QagListBloc>().add(
                                                FetchQagsListEvent(
                                                  thematiqueId: currentThematiqueId,
                                                  thematiqueLabel: currentThematiqueLabel,
                                                  qagFilter: QagListFilter.supporting,
                                                ),
                                              );
                                        });
                                      }
                                    },
                                  ),
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
