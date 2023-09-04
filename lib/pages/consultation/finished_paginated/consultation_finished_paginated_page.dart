import 'package:agora/bloc/consultation/finished_paginated/consultation_finished_paginated_bloc.dart';
import 'package:agora/bloc/consultation/finished_paginated/consultation_finished_paginated_event.dart';
import 'package:agora/bloc/consultation/finished_paginated/consultation_finished_paginated_state.dart';
import 'package:agora/common/analytics/analytics_event_names.dart';
import 'package:agora/common/analytics/analytics_screen_names.dart';
import 'package:agora/common/helper/tracker_helper.dart';
import 'package:agora/common/manager/repository_manager.dart';
import 'package:agora/common/strings/consultation_strings.dart';
import 'package:agora/common/strings/qag_strings.dart';
import 'package:agora/design/custom_view/agora_consultation_finished_card.dart';
import 'package:agora/design/custom_view/agora_error_view.dart';
import 'package:agora/design/custom_view/agora_rich_text.dart';
import 'package:agora/design/custom_view/agora_scaffold.dart';
import 'package:agora/design/custom_view/agora_secondary_style_view.dart';
import 'package:agora/design/custom_view/button/agora_rounded_button.dart';
import 'package:agora/design/style/agora_spacings.dart';
import 'package:agora/pages/consultation/summary/consultation_summary_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ConsultationFinishedPaginatedPage extends StatelessWidget {
  static const routeName = "/consultationFinishedPaginatedPage";

  final initialPage = 1;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (BuildContext context) => ConsultationFinishedPaginatedBloc(
            consultationRepository: RepositoryManager.getConsultationRepository(),
          )..add(FetchConsultationFinishedPaginatedEvent(pageNumber: initialPage)),
        ),
      ],
      child: AgoraScaffold(
        child: AgoraSecondaryStyleView(
          scrollType: AgoraSecondaryScrollType.custom,
          title: AgoraRichText(
            policeStyle: AgoraRichTextPoliceStyle.toolbar,
            items: [
              AgoraRichTextItem(
                text: "${ConsultationStrings.finishConsultationPart1} ",
                style: AgoraRichTextItemStyle.regular,
              ),
              AgoraRichTextItem(
                text: ConsultationStrings.finishConsultationPart2,
                style: AgoraRichTextItemStyle.bold,
              ),
            ],
          ),
          child: BlocBuilder<ConsultationFinishedPaginatedBloc, ConsultationFinishedPaginatedState>(
            builder: (context, state) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: AgoraSpacings.horizontalPadding),
                child: Column(children: _buildContent(context, state)),
              );
            },
          ),
        ),
      ),
    );
  }

  List<Widget> _buildContent(BuildContext context, ConsultationFinishedPaginatedState state) {
    final List<Widget> widgets = [];
    for (final finishedViewModel in state.consultationFinishedViewModels) {
      widgets.add(
        AgoraConsultationFinishedCard(
          id: finishedViewModel.id,
          title: finishedViewModel.title,
          thematique: finishedViewModel.thematique,
          imageUrl: finishedViewModel.coverUrl,
          step: finishedViewModel.step,
          style: AgoraConsultationFinishedStyle.large,
          onClick: () {
            TrackerHelper.trackClick(
              clickName: "${AnalyticsEventNames.finishedConsultation} ${finishedViewModel.id}",
              widgetName: AnalyticsScreenNames.consultationsFinishedPaginatedPage,
            );
            Navigator.pushNamed(
              context,
              ConsultationSummaryPage.routeName,
              arguments: ConsultationSummaryArguments(
                consultationId: finishedViewModel.id,
                shouldReloadConsultationsWhenPop: false,
                initialTab: ConsultationSummaryInitialTab.etEnsuite,
              ),
            );
          },
        ),
      );
      widgets.add(SizedBox(height: AgoraSpacings.base));
    }

    if (state is ConsultationFinishedPaginatedInitialState || state is ConsultationFinishedPaginatedLoadingState) {
      widgets.add(Center(child: CircularProgressIndicator()));
      widgets.add(SizedBox(height: AgoraSpacings.base));
    } else if (state is ConsultationFinishedPaginatedErrorState) {
      widgets.add(AgoraErrorView());
      widgets.add(SizedBox(height: AgoraSpacings.base));
      widgets.add(
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AgoraRoundedButton(
              label: QagStrings.retry,
              style: AgoraRoundedButtonStyle.primaryButtonStyle,
              onPressed: () => context
                  .read<ConsultationFinishedPaginatedBloc>()
                  .add(FetchConsultationFinishedPaginatedEvent(pageNumber: state.currentPageNumber)),
            ),
          ],
        ),
      );
      widgets.add(SizedBox(height: AgoraSpacings.base));
    } else {
      if (state.currentPageNumber < state.maxPage) {
        widgets.add(
          AgoraRoundedButton(
            label: QagStrings.displayMore,
            style: AgoraRoundedButtonStyle.primaryButtonStyle,
            onPressed: () => context
                .read<ConsultationFinishedPaginatedBloc>()
                .add(FetchConsultationFinishedPaginatedEvent(pageNumber: state.currentPageNumber + 1)),
          ),
        );
        widgets.add(SizedBox(height: AgoraSpacings.base));
      }
    }
    widgets.add(SizedBox(height: AgoraSpacings.x0_5));
    return widgets;
  }
}
