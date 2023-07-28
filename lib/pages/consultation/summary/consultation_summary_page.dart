import 'package:agora/bloc/consultation/summary/consultation_summary_bloc.dart';
import 'package:agora/bloc/consultation/summary/consultation_summary_event.dart';
import 'package:agora/bloc/consultation/summary/consultation_summary_state.dart';
import 'package:agora/common/analytics/analytics_event_names.dart';
import 'package:agora/common/analytics/analytics_screen_names.dart';
import 'package:agora/common/helper/notification_helper.dart';
import 'package:agora/common/helper/tracker_helper.dart';
import 'package:agora/common/manager/repository_manager.dart';
import 'package:agora/common/strings/consultation_strings.dart';
import 'package:agora/design/custom_view/agora_app_bar_with_tabs.dart';
import 'package:agora/design/custom_view/agora_error_view.dart';
import 'package:agora/design/custom_view/agora_scaffold.dart';
import 'package:agora/design/custom_view/agora_toolbar.dart';
import 'package:agora/design/custom_view/agora_tracker.dart';
import 'package:agora/design/style/agora_colors.dart';
import 'package:agora/design/style/agora_text_styles.dart';
import 'package:agora/pages/consultation/consultations_page.dart';
import 'package:agora/pages/consultation/summary/consultation_summary_et_ensuite_tab_content.dart';
import 'package:agora/pages/consultation/summary/consultation_summary_results_tab_content.dart';
import 'package:agora/pages/loading_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ConsultationSummaryArguments {
  final String consultationId;
  final bool shouldReloadConsultationsWhenPop;
  final String? notificationTitle;
  final String? notificationDescription;

  ConsultationSummaryArguments({
    required this.consultationId,
    this.shouldReloadConsultationsWhenPop = true,
    this.notificationTitle,
    this.notificationDescription,
  });
}

class ConsultationSummaryPage extends StatefulWidget {
  static const routeName = "/consultationSummaryPage";

  final String consultationId;
  final bool shouldReloadConsultationsWhenPop;
  final String? notificationTitle;
  final String? notificationDescription;

  const ConsultationSummaryPage({
    super.key,
    required this.consultationId,
    required this.shouldReloadConsultationsWhenPop,
    this.notificationTitle,
    this.notificationDescription,
  });

  @override
  State<ConsultationSummaryPage> createState() => _ConsultationSummaryPageState();
}

class _ConsultationSummaryPageState extends State<ConsultationSummaryPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final ScrollController scrollController = ScrollController();

  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);
    super.initState();
    NotificationHelper.displayNotificationWithDialog(
      context: context,
      notificationTitle: widget.notificationTitle,
      notificationDescription: widget.notificationDescription,
    );
  }

  @override
  void dispose() {
    super.dispose();
    _tabController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final consultationId = widget.consultationId;
    final shouldReloadConsultationsWhenPop = widget.shouldReloadConsultationsWhenPop;
    return BlocProvider(
      create: (BuildContext context) {
        return ConsultationSummaryBloc(consultationRepository: RepositoryManager.getConsultationRepository())
          ..add(FetchConsultationSummaryEvent(consultationId: consultationId));
      },
      child: AgoraScaffold(
        popAction: () {
          _onBackClick(context, consultationId, shouldReloadConsultationsWhenPop);
          return true;
        },
        child: BlocBuilder<ConsultationSummaryBloc, ConsultationSummaryState>(
          builder: (context, state) {
            if (state is ConsultationSummaryFetchedState) {
              final viewModel = state.viewModel;
              return NestedScrollView(
                controller: scrollController,
                headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
                  return [
                    AgoraAppBarWithTabs(
                      tabController: _tabController,
                      needTopDiagonal: false,
                      needToolbar: true,
                      onToolbarBackClick: () => _onBackClick(
                        context,
                        consultationId,
                        shouldReloadConsultationsWhenPop,
                      ),
                      topChild: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            viewModel.title,
                            style: AgoraTextStyles.medium20.copyWith(color: AgoraColors.primaryBlue),
                          ),
                        ],
                      ),
                      tabChild: [
                        Tab(text: ConsultationStrings.summaryTabResult),
                        Tab(text: ConsultationStrings.summaryTabEtEnsuite),
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
                            widgetName: "${AnalyticsScreenNames.consultationSummaryResultPage} $consultationId",
                            child: ConsultationSummaryResultsTabContent(
                              participantCount: viewModel.participantCount,
                              results: viewModel.results,
                              nestedScrollController: scrollController,
                            ),
                          ),
                          AgoraTracker(
                            widgetName: "${AnalyticsScreenNames.consultationSummaryEtEnsuitePage} $consultationId",
                            child: ConsultationSummaryEtEnsuiteTabContent(
                              consultationTitle: viewModel.title,
                              consultationId: consultationId,
                              etEnsuiteViewModel: viewModel.etEnsuite,
                              onBackToConsultationClick: () => _onBackToMenuClick(
                                context,
                                consultationId,
                                shouldReloadConsultationsWhenPop,
                              ),
                              nestedScrollController: scrollController,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            } else if (state is ConsultationSummaryInitialLoadingState) {
              return Column(
                children: [
                  AgoraToolbar(
                    onBackClick: () => _onBackClick(
                      context,
                      consultationId,
                      shouldReloadConsultationsWhenPop,
                    ),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height / 10 * 4),
                  Center(child: CircularProgressIndicator()),
                ],
              );
            } else {
              return Column(
                children: [
                  AgoraToolbar(
                    onBackClick: () => _onBackClick(
                      context,
                      consultationId,
                      shouldReloadConsultationsWhenPop,
                    ),
                  ),
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

  void _onBackClick(
    BuildContext context,
    String consultationId,
    bool shouldReloadConsultationWhenPop,
  ) {
    TrackerHelper.trackClick(
      clickName: AnalyticsEventNames.back,
      widgetName: "${AnalyticsScreenNames.consultationSummaryResultPage} $consultationId",
    );
    _navigateToConsultationsPage(context, shouldReloadConsultationWhenPop);
  }

  void _onBackToMenuClick(
    BuildContext context,
    String consultationId,
    bool shouldReloadConsultationsWhenPop,
  ) {
    TrackerHelper.trackClick(
      clickName: AnalyticsEventNames.backToMenu,
      widgetName: "${AnalyticsScreenNames.consultationSummaryEtEnsuitePage} $consultationId",
    );
    _navigateToConsultationsPage(context, shouldReloadConsultationsWhenPop);
  }

  void _navigateToConsultationsPage(BuildContext context, bool shouldReloadConsultationsWhenPop) {
    if (shouldReloadConsultationsWhenPop) {
      Navigator.pushNamedAndRemoveUntil(
        context,
        ConsultationsPage.routeName,
        ModalRoute.withName(LoadingPage.routeName),
      );
    } else {
      Navigator.pop(context);
    }
  }
}
