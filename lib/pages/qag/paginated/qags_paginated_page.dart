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
import 'package:agora/common/helper/tracker_helper.dart';
import 'package:agora/common/manager/repository_manager.dart';
import 'package:agora/common/strings/qag_strings.dart';
import 'package:agora/design/custom_view/agora_app_bar_with_tabs.dart';
import 'package:agora/design/custom_view/agora_error_view.dart';
import 'package:agora/design/custom_view/agora_scaffold.dart';
import 'package:agora/design/custom_view/agora_toolbar.dart';
import 'package:agora/design/custom_view/agora_tracker.dart';
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

  final String? thematiqueId;
  final QagPaginatedTab initialTab;

  const QagsPaginatedPage({super.key, required this.thematiqueId, required this.initialTab});

  @override
  State<QagsPaginatedPage> createState() => _QagsPaginatedPageState();
}

class _QagsPaginatedPageState extends State<QagsPaginatedPage> with SingleTickerProviderStateMixin {
  final initialPage = 1;
  late TabController _tabController;
  String? currentThematiqueId;
  bool shouldInitializeListener = true;

  @override
  void initState() {
    super.initState();
    currentThematiqueId = widget.thematiqueId;
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
                      onToolbarBackClick: () => _popWithBackResult(context),
                      topChild: SingleChildScrollView(
                        physics: BouncingScrollPhysics(),
                        scrollDirection: Axis.horizontal,
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
                                _call(context);
                              });
                            }
                          },
                          needHorizontalSpacing: false,
                        ),
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
                            child: QagsPaginatedPopularContent(thematiqueId: currentThematiqueId),
                          ),
                          AgoraTracker(
                            widgetName: AnalyticsScreenNames.qagsPaginatedLatestPage,
                            child: QagsPaginatedLatestContent(thematiqueId: currentThematiqueId),
                          ),
                          AgoraTracker(
                            widgetName: AnalyticsScreenNames.qagsPaginatedSupportingPage,
                            child: QagsPaginatedSupportingContent(thematiqueId: currentThematiqueId),
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
    if (widget.initialTab == QagPaginatedTab.popular) {
      qagPaginatedPopularBloc.add(
        FetchQagsPaginatedEvent(
          thematiqueId: currentThematiqueId,
          pageNumber: initialPage,
        ),
      );
    }
    return qagPaginatedPopularBloc;
  }

  QagPaginatedLatestBloc _getQagPaginatedLatestBloc() {
    final qagPaginatedLatestBloc = QagPaginatedLatestBloc(
      qagRepository: RepositoryManager.getQagRepository(),
    );
    if (widget.initialTab == QagPaginatedTab.latest) {
      qagPaginatedLatestBloc.add(
        FetchQagsPaginatedEvent(
          thematiqueId: currentThematiqueId,
          pageNumber: initialPage,
        ),
      );
    }
    return qagPaginatedLatestBloc;
  }

  QagPaginatedSupportingBloc _getQagPaginatedSupportingBloc() {
    final qagPaginatedSupportingBloc = QagPaginatedSupportingBloc(
      qagRepository: RepositoryManager.getQagRepository(),
    );
    if (widget.initialTab == QagPaginatedTab.supporting) {
      qagPaginatedSupportingBloc.add(
        FetchQagsPaginatedEvent(
          thematiqueId: currentThematiqueId,
          pageNumber: initialPage,
        ),
      );
    }
    return qagPaginatedSupportingBloc;
  }

  void _initializeTabBarListener(BuildContext context) {
    if (shouldInitializeListener) {
      _tabController.addListener(() {
        _call(context);
      });
      shouldInitializeListener = false;
    }
  }

  void _call(BuildContext context) {
    switch (_tabController.index) {
      case 0:
        context.read<QagPaginatedPopularBloc>().add(
              FetchQagsPaginatedEvent(
                thematiqueId: currentThematiqueId,
                pageNumber: initialPage,
              ),
            );
        break;
      case 1:
        context.read<QagPaginatedLatestBloc>().add(
              FetchQagsPaginatedEvent(
                thematiqueId: currentThematiqueId,
                pageNumber: initialPage,
              ),
            );
        break;
      case 2:
        context.read<QagPaginatedSupportingBloc>().add(
              FetchQagsPaginatedEvent(
                thematiqueId: currentThematiqueId,
                pageNumber: initialPage,
              ),
            );
        break;
      default:
        throw Exception("QaGs paginated : tab index not exists");
    }
  }

  int _getInitialIndex() {
    switch (widget.initialTab) {
      case QagPaginatedTab.popular:
        return 0;
      case QagPaginatedTab.latest:
        return 1;
      case QagPaginatedTab.supporting:
        return 2;
    }
  }
}
