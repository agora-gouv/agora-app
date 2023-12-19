import 'package:agora/bloc/qag/search/qag_search_bloc.dart';
import 'package:agora/bloc/qag/search/qag_search_event.dart';
import 'package:agora/common/analytics/analytics_event_names.dart';
import 'package:agora/common/analytics/analytics_screen_names.dart';
import 'package:agora/common/extension/string_extension.dart';
import 'package:agora/common/helper/timer_helper.dart';
import 'package:agora/common/helper/tracker_helper.dart';
import 'package:agora/common/strings/qag_strings.dart';
import 'package:agora/common/strings/string_utils.dart';
import 'package:agora/design/custom_view/agora_search_bar.dart';
import 'package:agora/design/style/agora_colors.dart';
import 'package:agora/design/style/agora_spacings.dart';
import 'package:agora/design/style/agora_text_styles.dart';
import 'package:agora/domain/qag/qas_list_filter.dart';
import 'package:agora/pages/qag/list/qag_list_section.dart';
import 'package:agora/pages/qag/qags_search.dart';
import 'package:agora/pages/qag/qags_thematique_section.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

enum QagTab { search, trending, popular, latest, supporting }

class QagsSection extends StatefulWidget {
  final QagTab defaultSelected;
  final String? selectedThematiqueId;
  final Function(bool) onSearchBarOpen;

  const QagsSection({
    super.key,
    required this.defaultSelected,
    required this.selectedThematiqueId,
    required this.onSearchBarOpen,
  });

  @override
  State<QagsSection> createState() => _QagsSectionState();
}

class _QagsSectionState extends State<QagsSection> {
  late QagTab currentSelected;
  String? currentThematiqueId;
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
    return Column(
      children: [
        _buildTabBar(),
        Visibility(
          visible: isThematiquesVisible,
          child: QagsThematiqueSection(
            currentThematiqueId: currentThematiqueId,
            onThematiqueIdSelected: (String? thematiqueId) {
              if (currentThematiqueId != null || thematiqueId != null) {
                setState(() {
                  if (thematiqueId == currentThematiqueId) {
                    currentThematiqueId = null;
                  } else {
                    currentThematiqueId = thematiqueId;
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
    );
  }

  Widget _buildQags(BuildContext context) {
    switch (currentSelected) {
      case QagTab.search:
        return QagSearch();
      case QagTab.trending:
        return QagListSection(qagFilter: QagListFilter.trending, thematiqueId: currentThematiqueId);
      case QagTab.popular:
        return QagListSection(qagFilter: QagListFilter.top, thematiqueId: currentThematiqueId);
      case QagTab.latest:
        return QagListSection(qagFilter: QagListFilter.latest, thematiqueId: currentThematiqueId);
      case QagTab.supporting:
        return QagListSection(qagFilter: QagListFilter.supporting, thematiqueId: currentThematiqueId);
    }
  }

  Widget _buildTabBar() {
    final TextEditingController textController = TextEditingController(text: previousSearchKeywords);

    textController.addListener(() {
      previousSearchKeywords = textController.text;
      final sanitizedInput = StringUtils.replaceDiacriticsAndRemoveSpecialChars(textController.text);
      bool reloadQags = false;
      if (sanitizedInput.isNullOrBlank() || sanitizedInput.length < 3) {
        context.read<QagSearchBloc>().add(FetchQagsInitialEvent());
        previousSearchKeywordsSanitized = '';
      } else {
        if (previousSearchKeywordsSanitized.length != sanitizedInput.length) {
          reloadQags = true;
        }
        previousSearchKeywordsSanitized = sanitizedInput;
      }
      if (reloadQags) {
        context.read<QagSearchBloc>().add(FetchQagsLoadingEvent());
        timerHelper.startTimer(() => _loadQags(context, sanitizedInput));
      }
    });

    return Padding(
      padding: const EdgeInsets.only(left: AgoraSpacings.x0_5),
      child: Container(
        height: 100,
        alignment: Alignment.center,
        child: ListView(
          scrollDirection: Axis.horizontal,
          shrinkWrap: false,
          padding: isActiveSearchBar ? EdgeInsets.zero : const EdgeInsets.symmetric(vertical: 20.0),
          children: [
            AnimSearchBar(
              height: 40,
              width: MediaQuery.of(context).size.width * 0.95,
              textController: textController,
              boxShadow: false,
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
              searchBarOpen: (bool isSearchOpen) => {
                setState(() {
                  isActiveSearchBar = isSearchOpen;
                  currentSelected = isSearchOpen ? QagTab.search : QagTab.trending;
                }),
                widget.onSearchBarOpen(isActiveSearchBar),
              },
            ),
            Visibility(
              visible: !isActiveSearchBar,
              child: Semantics(
                header: true,
                child: _buildTabButton(
                  label: QagStrings.trending,
                  isSelected: currentSelected == QagTab.trending,
                  onTap: () {
                    TrackerHelper.trackClick(
                      clickName: AnalyticsEventNames.qagTrending,
                      widgetName: AnalyticsScreenNames.qagsPage,
                    );
                    setState(() => currentSelected = QagTab.trending);
                  },
                ),
              ),
            ),
            Visibility(
              visible: !isActiveSearchBar,
              child: Semantics(
                header: true,
                child: _buildTabButton(
                  label: QagStrings.popular,
                  isSelected: currentSelected == QagTab.popular,
                  onTap: () {
                    TrackerHelper.trackClick(
                      clickName: AnalyticsEventNames.qagPopular,
                      widgetName: AnalyticsScreenNames.qagsPage,
                    );
                    setState(() => currentSelected = QagTab.popular);
                  },
                ),
              ),
            ),
            Visibility(
              visible: !isActiveSearchBar,
              child: _buildTabButton(
                label: QagStrings.latest,
                isSelected: currentSelected == QagTab.latest,
                onTap: () {
                  TrackerHelper.trackClick(
                    clickName: AnalyticsEventNames.qagLatest,
                    widgetName: AnalyticsScreenNames.qagsPage,
                  );
                  setState(() => currentSelected = QagTab.latest);
                },
              ),
            ),
            Visibility(
              visible: !isActiveSearchBar,
              child: _buildTabButton(
                label: QagStrings.supporting,
                isSelected: currentSelected == QagTab.supporting,
                onTap: () {
                  TrackerHelper.trackClick(
                    clickName: AnalyticsEventNames.qagSupporting,
                    widgetName: AnalyticsScreenNames.qagsPage,
                  );
                  setState(() => currentSelected = QagTab.supporting);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTabButton({
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: () => onTap(),
      child: Column(
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

  void _loadQags(BuildContext context, String keywords) {
    context.read<QagSearchBloc>().add(FetchQagsSearchEvent(keywords: keywords));

    if (keywords.isNotEmpty == true) {
      TrackerHelper.trackSearch(
        widgetName: AnalyticsScreenNames.qagsPage,
        searchName: AnalyticsEventNames.qagsSearch,
        searchedKeywords: keywords,
      );
    }
  }
}
