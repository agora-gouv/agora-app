import 'package:agora/bloc/qag/paginated/bloc/qag_paginated_latest_bloc.dart';
import 'package:agora/bloc/qag/paginated/bloc/qag_paginated_popular_bloc.dart';
import 'package:agora/bloc/qag/paginated/bloc/qag_paginated_supporting_bloc.dart';
import 'package:agora/bloc/qag/paginated/qag_paginated_event.dart';
import 'package:agora/bloc/qag/support/qag_support_bloc.dart';
import 'package:agora/bloc/thematique/thematique_bloc.dart';
import 'package:agora/bloc/thematique/thematique_event.dart';
import 'package:agora/bloc/thematique/thematique_state.dart';
import 'package:agora/common/analytics/analytics_event_names.dart';
import 'package:agora/common/analytics/analytics_screen_names.dart';
import 'package:agora/common/helper/thematique_helper.dart';
import 'package:agora/common/helper/timer_helper.dart';
import 'package:agora/common/helper/tracker_helper.dart';
import 'package:agora/common/manager/repository_manager.dart';
import 'package:agora/common/strings/qag_strings.dart';
import 'package:agora/design/custom_view/agora_app_bar_with_tabs.dart';
import 'package:agora/design/custom_view/agora_error_view.dart';
import 'package:agora/design/custom_view/agora_scaffold.dart';
import 'package:agora/design/custom_view/agora_text_field.dart';
import 'package:agora/design/custom_view/agora_toolbar.dart';
import 'package:agora/design/custom_view/agora_tracker.dart';
import 'package:agora/design/style/agora_spacings.dart';
import 'package:agora/pages/loading_page.dart';
import 'package:agora/pages/qag/paginated/qags_paginated_latest_content.dart';
import 'package:agora/pages/qag/paginated/qags_paginated_popular_content.dart';
import 'package:agora/pages/qag/paginated/qags_paginated_supporting_content.dart';
import 'package:agora/pages/qag/qags_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

enum QagPaginatedTab { popular, latest, supporting }

class QagsPaginatedArguments {
  final String? thematiqueId;
  final QagPaginatedTab initialTab;

  QagsPaginatedArguments({required this.thematiqueId, required this.initialTab});
}

class QagsPaginatedPage extends StatefulWidget {
  static const routeName = "/qagsPaginatedPage";

  final QagsPaginatedArguments arguments;

  const QagsPaginatedPage({super.key, required this.arguments});

  @override
  State<QagsPaginatedPage> createState() => _QagsPaginatedPageState();
}

class _QagsPaginatedPageState extends State<QagsPaginatedPage> with SingleTickerProviderStateMixin {
  final initialPage = 1;
  late TabController _tabController;
  String? currentThematiqueId;
  String? currentKeywords;
  bool shouldInitializeListener = true;

  final timerHelper = TimerHelper(countdownDurationInSecond: 3);

  @override
  void initState() {
    super.initState();
    currentThematiqueId = widget.arguments.thematiqueId;
    _tabController = TabController(length: 3, vsync: this, initialIndex: _getInitialIndex());
  }

  @override
  void dispose() {
    super.dispose();
    _tabController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => ThematiqueBloc(
            repository: RepositoryManager.getThematiqueRepository(),
          )..add(FetchFilterThematiqueEvent()),
        ),
        BlocProvider(
          create: (BuildContext context) => QagSupportBloc(qagRepository: RepositoryManager.getQagRepository()),
        ),
        BlocProvider(create: (context) => _getQagPaginatedPopularBloc()),
        BlocProvider(create: (context) => _getQagPaginatedLatestBloc()),
        BlocProvider(create: (context) => _getQagPaginatedSupportingBloc()),
      ],
      child: AgoraScaffold(
        popAction: () {
          _popWithBackResult(context);
          return true;
        },
        child: BlocBuilder<ThematiqueBloc, ThematiqueState>(
          builder: (context, thematiqueState) {
            if (thematiqueState is ThematiqueSuccessState) {
              _initializeTabBarListener(context);
              return NestedScrollView(
                headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
                  return [
                    AgoraAppBarWithTabs(
                      tabController: _tabController,
                      needTopDiagonal: false,
                      needToolbar: true,
                      initialToolBarHeight: 200,
                      onToolbarBackClick: () => _popWithBackResult(context),
                      topChild: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SingleChildScrollView(
                            physics: BouncingScrollPhysics(),
                            scrollDirection: Axis.horizontal,
                            child: Padding(
                              padding: EdgeInsets.only(
                                left: AgoraSpacings.horizontalPadding,
                                right: AgoraSpacings.horizontalPadding,
                                top: AgoraSpacings.x0_25,
                              ),
                              child: ThematiqueHelper.buildThematiques(
                                thematiques: thematiqueState.thematiqueViewModels,
                                selectedThematiqueId: currentThematiqueId,
                                onThematiqueIdSelected: (thematiqueId) {
                                  if (currentThematiqueId != null || thematiqueId != null) {
                                    setState(() {
                                      if (thematiqueId == currentThematiqueId) {
                                        currentThematiqueId = null;
                                      } else {
                                        currentThematiqueId = thematiqueId;
                                      }
                                      TrackerHelper.trackClick(
                                        clickName: "${AnalyticsEventNames.thematique} $currentThematiqueId",
                                        widgetName: AnalyticsScreenNames.qagsPaginatedPage,
                                      );
                                      _loadQags(context);
                                    });
                                  }
                                },
                                needHorizontalSpacing: false,
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(
                              left: AgoraSpacings.horizontalPadding,
                              right: AgoraSpacings.horizontalPadding,
                              top: AgoraSpacings.base,
                            ),
                            child: AgoraTextField(
                              hintText: QagStrings.searchQuestion,
                              rightIcon: TextFieldIcon.search,
                              textInputAction: TextInputAction.search,
                              maxLength: 75,
                              showCounterText: true,
                              onChanged: (String input) {
                                currentKeywords = input;
                                _displayLoader(context);
                                timerHelper.startTimer(() => _loadQags(context));
                              },
                            ),
                          ),
                        ],
                      ),
                      tabChild: [
                        Semantics(header: true, child: Tab(text: QagStrings.popular)),
                        Tab(text: QagStrings.latest),
                        Tab(text: QagStrings.supporting),
                      ],
                    ),
                  ];
                },
                body: Column(
                  children: [
                    Expanded(
                      child: TabBarView(
                        controller: _tabController,
                        children: [
                          AgoraTracker(
                            widgetName: AnalyticsScreenNames.qagsPaginatedPopularPage,
                            child: QagsPaginatedPopularContent(
                              thematiqueId: currentThematiqueId,
                              keywords: currentKeywords,
                            ),
                          ),
                          AgoraTracker(
                            widgetName: AnalyticsScreenNames.qagsPaginatedLatestPage,
                            child: QagsPaginatedLatestContent(
                              thematiqueId: currentThematiqueId,
                              keywords: currentKeywords,
                            ),
                          ),
                          AgoraTracker(
                            widgetName: AnalyticsScreenNames.qagsPaginatedSupportingPage,
                            child: QagsPaginatedSupportingContent(
                              thematiqueId: currentThematiqueId,
                              keywords: currentKeywords,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            } else if (thematiqueState is ThematiqueInitialLoadingState) {
              return Column(
                children: [
                  AgoraToolbar(onBackClick: () => _popWithBackResult(context)),
                  SizedBox(height: MediaQuery.of(context).size.height / 10 * 4),
                  Center(child: CircularProgressIndicator()),
                ],
              );
            } else {
              return Column(
                children: [
                  AgoraToolbar(onBackClick: () => _popWithBackResult(context)),
                  SizedBox(height: MediaQuery.of(context).size.height / 10 * 4),
                  AgoraErrorView(),
                ],
              );
            }
          },
        ),
      ),
    );
  }

  void _popWithBackResult(BuildContext context) {
    Navigator.pushNamedAndRemoveUntil(
      context,
      QagsPage.routeName,
      ModalRoute.withName(LoadingPage.routeName),
    );
  }

  QagPaginatedPopularBloc _getQagPaginatedPopularBloc() {
    final qagPaginatedPopularBloc = QagPaginatedPopularBloc(
      qagRepository: RepositoryManager.getQagRepository(),
    );
    if (widget.arguments.initialTab == QagPaginatedTab.popular) {
      qagPaginatedPopularBloc.add(
        FetchQagsPaginatedEvent(
          thematiqueId: currentThematiqueId,
          pageNumber: initialPage,
          keywords: currentKeywords,
        ),
      );
    }
    return qagPaginatedPopularBloc;
  }

  QagPaginatedLatestBloc _getQagPaginatedLatestBloc() {
    final qagPaginatedLatestBloc = QagPaginatedLatestBloc(
      qagRepository: RepositoryManager.getQagRepository(),
    );
    if (widget.arguments.initialTab == QagPaginatedTab.latest) {
      qagPaginatedLatestBloc.add(
        FetchQagsPaginatedEvent(
          thematiqueId: currentThematiqueId,
          pageNumber: initialPage,
          keywords: currentKeywords,
        ),
      );
    }
    return qagPaginatedLatestBloc;
  }

  QagPaginatedSupportingBloc _getQagPaginatedSupportingBloc() {
    final qagPaginatedSupportingBloc = QagPaginatedSupportingBloc(
      qagRepository: RepositoryManager.getQagRepository(),
    );
    if (widget.arguments.initialTab == QagPaginatedTab.supporting) {
      qagPaginatedSupportingBloc.add(
        FetchQagsPaginatedEvent(
          thematiqueId: currentThematiqueId,
          pageNumber: initialPage,
          keywords: currentKeywords,
        ),
      );
    }
    return qagPaginatedSupportingBloc;
  }

  void _initializeTabBarListener(BuildContext context) {
    if (shouldInitializeListener) {
      _tabController.addListener(() {
        _loadQags(context);
      });
      shouldInitializeListener = false;
    }
  }

  void _loadQags(BuildContext context) {
    switch (_tabController.index) {
      case 0:
        context.read<QagPaginatedPopularBloc>().add(
              FetchQagsPaginatedEvent(
                thematiqueId: currentThematiqueId,
                pageNumber: initialPage,
                keywords: currentKeywords,
              ),
            );
        break;
      case 1:
        context.read<QagPaginatedLatestBloc>().add(
              FetchQagsPaginatedEvent(
                thematiqueId: currentThematiqueId,
                pageNumber: initialPage,
                keywords: currentKeywords,
              ),
            );
        break;
      case 2:
        context.read<QagPaginatedSupportingBloc>().add(
              FetchQagsPaginatedEvent(
                thematiqueId: currentThematiqueId,
                pageNumber: initialPage,
                keywords: currentKeywords,
              ),
            );
        break;
      default:
        throw Exception("QaGs paginated : tab index not exists");
    }
  }

  void _displayLoader(BuildContext context) {
    switch (_tabController.index) {
      case 0:
        context.read<QagPaginatedPopularBloc>().add(QagPaginatedDisplayLoaderEvent());
        break;
      case 1:
        context.read<QagPaginatedLatestBloc>().add(QagPaginatedDisplayLoaderEvent());
        break;
      case 2:
        context.read<QagPaginatedSupportingBloc>().add(QagPaginatedDisplayLoaderEvent());
        break;
      default:
        throw Exception("QaGs paginated : tab index not exists");
    }
  }

  int _getInitialIndex() {
    switch (widget.arguments.initialTab) {
      case QagPaginatedTab.popular:
        return 0;
      case QagPaginatedTab.latest:
        return 1;
      case QagPaginatedTab.supporting:
        return 2;
    }
  }
}
