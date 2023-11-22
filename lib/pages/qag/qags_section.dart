import 'package:agora/bloc/qag/popup_view_model.dart';
import 'package:agora/bloc/qag/qag_bloc.dart';
import 'package:agora/bloc/qag/qag_event.dart';
import 'package:agora/bloc/qag/qag_view_model.dart';
import 'package:agora/bloc/qag/search/qag_search_bloc.dart';
import 'package:agora/bloc/qag/search/qag_search_event.dart';
import 'package:agora/bloc/qag/support/qag_support_bloc.dart';
import 'package:agora/bloc/qag/support/qag_support_event.dart';
import 'package:agora/bloc/qag/support/qag_support_state.dart';
import 'package:agora/common/analytics/analytics_event_names.dart';
import 'package:agora/common/analytics/analytics_screen_names.dart';
import 'package:agora/common/extension/string_extension.dart';
import 'package:agora/common/helper/timer_helper.dart';
import 'package:agora/common/helper/tracker_helper.dart';
import 'package:agora/common/manager/repository_manager.dart';
import 'package:agora/common/strings/generic_strings.dart';
import 'package:agora/common/strings/qag_strings.dart';
import 'package:agora/common/strings/string_utils.dart';
import 'package:agora/design/custom_view/agora_alert_dialog.dart';
import 'package:agora/design/custom_view/agora_error_view.dart';
import 'package:agora/design/custom_view/agora_qag_card.dart';
import 'package:agora/design/custom_view/agora_search_bar.dart';
import 'package:agora/design/custom_view/button/agora_button.dart';
import 'package:agora/design/custom_view/button/agora_rounded_button.dart';
import 'package:agora/design/style/agora_button_style.dart';
import 'package:agora/design/style/agora_colors.dart';
import 'package:agora/design/style/agora_corners.dart';
import 'package:agora/design/style/agora_spacings.dart';
import 'package:agora/design/style/agora_text_styles.dart';
import 'package:agora/pages/profile/participation_charter_page.dart';
import 'package:agora/pages/qag/ask_question/qag_ask_question_page.dart';
import 'package:agora/pages/qag/details/qag_details_page.dart';
import 'package:agora/pages/qag/paginated/qags_paginated_page.dart';
import 'package:agora/pages/qag/qags_search.dart';
import 'package:agora/pages/qag/qags_thematique_section.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

enum QagTab { search, popular, latest, supporting }

class QagsSection extends StatefulWidget {
  final bool isLoading;
  final QagTab defaultSelected;
  final List<QagViewModel> popularViewModels;
  final List<QagViewModel> latestViewModels;
  final List<QagViewModel> supportingViewModels;
  final String? selectedThematiqueId;
  final String? askQuestionErrorCase;
  final PopupQagViewModel? popupViewModel;

  const QagsSection({
    super.key,
    required this.isLoading,
    required this.defaultSelected,
    required this.popularViewModels,
    required this.latestViewModels,
    required this.supportingViewModels,
    required this.selectedThematiqueId,
    required this.askQuestionErrorCase,
    required this.popupViewModel,
  });

  @override
  State<QagsSection> createState() => _QagsSectionState();
}

class _QagsSectionState extends State<QagsSection> {
  late QagTab currentSelected;
  String? currentThematiqueId;
  String previousSearchKeywords = '';
  bool isActiveSearchBar = false;

  final timerHelper = TimerHelper(countdownDurationInSecond: 3);

  @override
  void initState() {
    super.initState();
    currentSelected = widget.defaultSelected;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildTabBar(),
        Visibility(
          visible: !isActiveSearchBar,
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
                  context.read<QagBloc>().add(FetchQagsEvent(thematiqueId: currentThematiqueId));
                });
              }
            },
          ),
        ),
        widget.isLoading
            ? Padding(
                padding: const EdgeInsets.symmetric(horizontal: AgoraSpacings.horizontalPadding),
                child: Column(
                  children: [
                    SizedBox(height: AgoraSpacings.x2),
                    CircularProgressIndicator(),
                    SizedBox(height: AgoraSpacings.x3 * 2),
                  ],
                ),
              )
            : Padding(
                padding: const EdgeInsets.symmetric(vertical: AgoraSpacings.base),
                child: Column(
                  children: [
                    if (!isActiveSearchBar) _getPopupWidget(context) ?? SizedBox(),
                    Column(children: _buildQags(context)),
                  ],
                ),
              ),
      ],
    );
  }

  Widget? _getPopupWidget(BuildContext context) {
    if (widget.popupViewModel != null) {
      return Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AgoraSpacings.base),
            child: InkWell(
              onTap: () => {Navigator.pushNamed(context, ParticipationCharterPage.routeName)},
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.all(AgoraCorners.rounded),
                  color: AgoraColors.blue525opacity06,
                ),
                padding: const EdgeInsets.all(AgoraSpacings.base),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.popupViewModel!.title,
                      textAlign: TextAlign.start,
                      style: AgoraTextStyles.medium14,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: AgoraSpacings.base),
                      child: Text(
                        widget.popupViewModel!.description,
                        style: AgoraTextStyles.regular14,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(height: AgoraSpacings.base),
        ],
      );
    }
    return null;
  }

  List<Widget> _buildQags(BuildContext context) {
    switch (currentSelected) {
      case QagTab.search:
        return [QagSearch()];
      case QagTab.popular:
        return _buildQagWidgets(context, widget.popularViewModels, currentSelected);
      case QagTab.latest:
        return _buildQagWidgets(context, widget.latestViewModels, currentSelected);
      case QagTab.supporting:
        return _buildQagWidgets(context, widget.supportingViewModels, currentSelected);
    }
  }

  List<Widget> _buildQagWidgets(BuildContext context, List<QagViewModel> qagViewModels, QagTab qagTab) {
    final List<Widget> qagsWidgets = [];
    if (qagViewModels.isNotEmpty) {
      for (final qagViewModel in qagViewModels) {
        qagsWidgets.add(
          BlocProvider.value(
            value: QagSupportBloc(qagRepository: RepositoryManager.getQagRepository()),
            child: BlocConsumer<QagSupportBloc, QagSupportState>(
              listenWhen: (previousState, currentState) {
                return (currentState is QagSupportSuccessState && currentState.qagId == qagViewModel.id) ||
                    (currentState is QagDeleteSupportSuccessState && currentState.qagId == qagViewModel.id) ||
                    (currentState is QagSupportErrorState && currentState.qagId == qagViewModel.id) ||
                    (currentState is QagDeleteSupportErrorState && currentState.qagId == qagViewModel.id);
              },
              listener: (previousState, currentState) {
                if (currentState is QagSupportSuccessState || currentState is QagDeleteSupportSuccessState) {
                  context.read<QagBloc>().add(
                        UpdateQagsEvent(
                          qagId: qagViewModel.id,
                          thematique: qagViewModel.thematique,
                          title: qagViewModel.title,
                          username: qagViewModel.username,
                          date: qagViewModel.date,
                          supportCount: _buildCount(qagViewModel, currentState),
                          isSupported: !qagViewModel.isSupported,
                          isAuthor: qagViewModel.isAuthor,
                        ),
                      );
                } else if (currentState is QagSupportErrorState || currentState is QagDeleteSupportErrorState) {
                  showAgoraDialog(
                    context: context,
                    columnChildren: [
                      AgoraErrorView(),
                      SizedBox(height: AgoraSpacings.x0_75),
                      AgoraButton(
                        label: GenericStrings.close,
                        style: AgoraButtonStyle.primaryButtonStyle,
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  );
                }
              },
              buildWhen: (previousState, currentState) {
                return currentState is QagSupportInitialState ||
                    currentState is QagSupportLoadingState ||
                    currentState is QagDeleteSupportLoadingState ||
                    (currentState is QagSupportSuccessState && currentState.qagId == qagViewModel.id) ||
                    (currentState is QagDeleteSupportSuccessState && currentState.qagId == qagViewModel.id);
              },
              builder: (context, state) {
                return AgoraQagCard(
                  id: qagViewModel.id,
                  thematique: qagViewModel.thematique,
                  title: qagViewModel.title,
                  username: qagViewModel.username,
                  date: qagViewModel.date,
                  supportCount: qagViewModel.supportCount,
                  isSupported: qagViewModel.isSupported,
                  isAuthor: qagViewModel.isAuthor,
                  onSupportClick: (support) {
                    if (support) {
                      TrackerHelper.trackClick(
                        clickName: AnalyticsEventNames.likeQag,
                        widgetName: AnalyticsScreenNames.qagsPage,
                      );
                      context.read<QagSupportBloc>().add(SupportQagEvent(qagId: qagViewModel.id));
                    } else {
                      TrackerHelper.trackClick(
                        clickName: AnalyticsEventNames.unlikeQag,
                        widgetName: AnalyticsScreenNames.qagsPage,
                      );
                      context.read<QagSupportBloc>().add(DeleteSupportQagEvent(qagId: qagViewModel.id));
                    }
                  },
                  onCardClick: () {
                    Navigator.pushNamed(
                      context,
                      QagDetailsPage.routeName,
                      arguments: QagDetailsArguments(qagId: qagViewModel.id, reload: QagReload.qagsPage),
                    ).then((result) {
                      final qagDetailsBackResult = result as QagDetailsBackResult?;
                      if (qagDetailsBackResult != null) {
                        context.read<QagBloc>().add(
                              UpdateQagsEvent(
                                qagId: qagDetailsBackResult.qagId,
                                thematique: qagDetailsBackResult.thematique,
                                title: qagDetailsBackResult.title,
                                username: qagDetailsBackResult.username,
                                date: qagDetailsBackResult.date,
                                supportCount: qagDetailsBackResult.supportCount,
                                isSupported: qagDetailsBackResult.isSupported,
                                isAuthor: qagDetailsBackResult.isAuthor,
                              ),
                            );
                        setState(() {}); // do not remove: utils to update screen
                      }
                    });
                  },
                );
              },
            ),
          ),
        );
        qagsWidgets.add(SizedBox(height: AgoraSpacings.base));
      }
      switch (qagTab) {
        case QagTab.search:
          break;
        case QagTab.popular:
          qagsWidgets.add(_buildAllButton(QagPaginatedTab.popular));
          break;
        case QagTab.latest:
          qagsWidgets.add(_buildAllButton(QagPaginatedTab.latest));
          break;
        case QagTab.supporting:
          qagsWidgets.add(_buildAllButton(QagPaginatedTab.supporting));
          break;
      }
      return qagsWidgets;
    } else {
      return [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AgoraSpacings.horizontalPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: AgoraSpacings.base),
              Text(QagStrings.emptyList, style: AgoraTextStyles.medium14),
              SizedBox(height: AgoraSpacings.x1_5),
              AgoraRoundedButton(
                label: QagStrings.askQuestion,
                onPressed: () {
                  TrackerHelper.trackClick(
                    clickName: AnalyticsEventNames.askQuestionInEmptyList,
                    widgetName: AnalyticsScreenNames.qagsPage,
                  );
                  Navigator.pushNamed(context, QagAskQuestionPage.routeName, arguments: widget.askQuestionErrorCase);
                },
              ),
              SizedBox(height: AgoraSpacings.x3 * 2),
            ],
          ),
        ),
      ];
    }
  }

  int _buildCount(QagViewModel qagViewModel, QagSupportState supportState) {
    final supportCount = qagViewModel.supportCount;
    if (supportState is QagSupportSuccessState) {
      return supportCount + 1;
    } else if (supportState is QagDeleteSupportSuccessState) {
      return supportCount - 1;
    }
    return supportCount;
  }

  Widget _buildAllButton(QagPaginatedTab initialTab) {
    return AgoraRoundedButton(
      label: GenericStrings.all,
      style: AgoraRoundedButtonStyle.primaryButtonStyle,
      onPressed: () {
        Navigator.pushNamed(
          context,
          QagsPaginatedPage.routeName,
          arguments: QagsPaginatedArguments(thematiqueId: widget.selectedThematiqueId, initialTab: initialTab),
        );
      },
    );
  }

  Widget _buildTabBar() {
    final TextEditingController textController = TextEditingController();

    textController.addListener(() {
      final sanitizedInput = StringUtils.replaceDiacriticsAndRemoveSpecialChars(textController.text);
      bool reloadQags = false;
      if (sanitizedInput.isNullOrBlank() || sanitizedInput.length < 3) {
        context.read<QagSearchBloc>().add(FetchQagsInitialEvent());
        previousSearchKeywords = '';
      } else {
        if (previousSearchKeywords.length != sanitizedInput.length) {
          reloadQags = true;
        }
        previousSearchKeywords = sanitizedInput;
      }
      if (reloadQags) {
        context.read<QagSearchBloc>().add(FetchQagsLoadingEvent());
        timerHelper.startTimer(() => _loadQags(context, sanitizedInput));
      }
    });

    return Column(
      children: [
        SizedBox(height: AgoraSpacings.base),
        Row(
          children: [
            AnimSearchBar(
              height: 40,
              width: MediaQuery.of(context).size.width,
              textController: textController,
              boxShadow: false,
              onClose: () {
                setState(() {
                  textController.clear();
                  isActiveSearchBar = false;
                  currentSelected = QagTab.popular;
                });
                context.read<QagSearchBloc>().add(FetchQagsInitialEvent());
              },
              helpText: QagStrings.searchQagHint,
              onClearText: () {},
              onSubmitted: (String e) {},
              autoFocus: false,
              searchBarOpen: (bool isSearchOpen) => {
                setState(() {
                  isActiveSearchBar = isSearchOpen;
                  currentSelected = isSearchOpen ? QagTab.search : QagTab.popular;
                }),
              },
            ),
            Visibility(
              visible: !isActiveSearchBar,
              child: Expanded(
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
            ),
            Visibility(
              visible: !isActiveSearchBar,
              child: Expanded(
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
            ),
            Visibility(
              visible: !isActiveSearchBar,
              child: Expanded(
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
            ),
          ],
        ),
      ],
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
