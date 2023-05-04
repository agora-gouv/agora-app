import 'package:agora/bloc/consultation/summary/consultation_summary_bloc.dart';
import 'package:agora/bloc/consultation/summary/consultation_summary_event.dart';
import 'package:agora/bloc/consultation/summary/consultation_summary_state.dart';
import 'package:agora/common/manager/helper_manager.dart';
import 'package:agora/common/manager/repository_manager.dart';
import 'package:agora/common/strings/consultation_strings.dart';
import 'package:agora/design/custom_view/agora_app_bar_with_tabs.dart';
import 'package:agora/design/custom_view/agora_error_view.dart';
import 'package:agora/design/custom_view/agora_scaffold.dart';
import 'package:agora/design/style/agora_colors.dart';
import 'package:agora/design/style/agora_text_styles.dart';
import 'package:agora/pages/consultation/consultations_page.dart';
import 'package:agora/pages/consultation/summary/consultation_summary_et_ensuite_tab_content.dart';
import 'package:agora/pages/consultation/summary/consultation_summary_results_tab_content.dart';
import 'package:agora/pages/loading_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ConsultationSummaryPage extends StatefulWidget {
  static const routeName = "/consultationSummaryPage";

  @override
  State<ConsultationSummaryPage> createState() => _ConsultationSummaryPageState();
}

class _ConsultationSummaryPageState extends State<ConsultationSummaryPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _tabController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final consultationId = ModalRoute.of(context)!.settings.arguments as String;
    return BlocProvider(
      create: (BuildContext context) {
        return ConsultationSummaryBloc(
          consultationRepository: RepositoryManager.getConsultationRepository(),
          deviceInfoHelper: HelperManager.getDeviceInfoHelper(),
        )..add(FetchConsultationSummaryEvent(consultationId: consultationId));
      },
      child: AgoraScaffold(
        child: BlocBuilder<ConsultationSummaryBloc, ConsultationSummaryState>(
          builder: (context, state) {
            if (state is ConsultationSummaryFetchedState) {
              final viewModel = state.viewModel;
              return NestedScrollView(
                headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
                  return [
                    AgoraAppBarWithTabs(
                      tabController: _tabController,
                      needTopDiagonal: false,
                      needToolbar: true,
                      onToolbarBackClick: () {
                        Navigator.pushNamedAndRemoveUntil(
                          context,
                          ConsultationsPage.routeName,
                          ModalRoute.withName(LoadingPage.routeName),
                        );
                      },
                      topChild: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            viewModel.title,
                            style: AgoraTextStyles.medium20.copyWith(color: AgoraColors.primaryGreen),
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
                          ConsultationSummaryResultsTabContent(
                            participantCount: viewModel.participantCount,
                            results: viewModel.results,
                          ),
                          ConsultationSummaryEtEnsuiteTabContent(
                            title: viewModel.title,
                            consultationId: consultationId,
                            etEnsuiteViewModel: viewModel.etEnsuite,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            } else if (state is ConsultationSummaryInitialLoadingState) {
              return Center(child: CircularProgressIndicator());
            } else {
              return AgoraErrorView();
            }
          },
        ),
      ),
    );
  }
}
