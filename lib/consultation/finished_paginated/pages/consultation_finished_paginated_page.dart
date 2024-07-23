import 'package:agora/common/analytics/analytics_event_names.dart';
import 'package:agora/common/analytics/analytics_screen_names.dart';
import 'package:agora/common/helper/launch_url_helper.dart';
import 'package:agora/common/helper/responsive_helper.dart';
import 'package:agora/common/helper/tracker_helper.dart';
import 'package:agora/common/manager/repository_manager.dart';
import 'package:agora/common/strings/consultation_strings.dart';
import 'package:agora/common/strings/generic_strings.dart';
import 'package:agora/consultation/dynamic/pages/dynamic_consultation_page.dart';
import 'package:agora/consultation/finished_paginated/bloc/consultation_finished_paginated_bloc.dart';
import 'package:agora/consultation/finished_paginated/bloc/consultation_finished_paginated_event.dart';
import 'package:agora/consultation/finished_paginated/bloc/consultation_finished_paginated_state.dart';
import 'package:agora/consultation/finished_paginated/bloc/consultation_finished_paginated_view_model.dart';
import 'package:agora/design/custom_view/agora_scaffold.dart';
import 'package:agora/design/custom_view/button/agora_button.dart';
import 'package:agora/design/custom_view/button/agora_secondary_style_view_button.dart';
import 'package:agora/design/custom_view/card/agora_consultation_finished_card.dart';
import 'package:agora/design/custom_view/error/agora_error_view.dart';
import 'package:agora/design/custom_view/text/agora_rich_text.dart';
import 'package:agora/design/style/agora_spacings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ConsultationFinishedPaginatedPage extends StatelessWidget {
  static const routeName = "/consultationFinishedPaginatedPage";

  final ConsultationPaginatedPageType type;

  const ConsultationFinishedPaginatedPage(this.type);

  final initialPage = 1;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (BuildContext context) => ConsultationPaginatedBloc(
            consultationRepository: RepositoryManager.getConsultationRepository(),
            concertationRepository: RepositoryManager.getConcertationRepository(),
          )..add(FetchConsultationPaginatedEvent(pageNumber: initialPage, type: type)),
        ),
      ],
      child: AgoraScaffold(
        child: AgoraSecondaryStyleView(
          pageLabel: "${ConsultationStrings.finishConsultationPart1} ${ConsultationStrings.finishConsultationPart2}",
          title: AgoraRichText(
            policeStyle: AgoraRichTextPoliceStyle.toolbar,
            items: [
              AgoraRichTextItem(
                text: type == ConsultationPaginatedPageType.answered
                    ? ConsultationStrings.answeredConsultationPart1
                    : "${ConsultationStrings.finishConsultationPart1} ",
                style: AgoraRichTextItemStyle.regular,
              ),
              AgoraRichTextItem(
                text: type == ConsultationPaginatedPageType.answered
                    ? ConsultationStrings.answeredConsultationPart2
                    : ConsultationStrings.finishConsultationPart2,
                style: AgoraRichTextItemStyle.bold,
              ),
            ],
          ),
          child: BlocBuilder<ConsultationPaginatedBloc, ConsultationPaginatedState>(
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

  List<Widget> _buildContent(BuildContext context, ConsultationPaginatedState state) {
    final List<Widget> widgets = [];
    final consultationFinishedViewModels = state.consultationPaginatedViewModels;
    final largerThanMobile = ResponsiveHelper.isLargerThanMobile(context);
    if (largerThanMobile) {
      for (var index = 0; index < consultationFinishedViewModels.length; index = index + 2) {
        final finishedViewModel1 = consultationFinishedViewModels[index];
        ConsultationPaginatedViewModel? finishedViewModel2;
        if (index + 1 < consultationFinishedViewModels.length) {
          finishedViewModel2 = consultationFinishedViewModels[index + 1];
        }
        widgets.add(
          IntrinsicHeight(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Expanded(
                  child: AgoraConsultationFinishedCard(
                    id: finishedViewModel1.id,
                    title: finishedViewModel1.title,
                    thematique: finishedViewModel1.thematique,
                    imageUrl: finishedViewModel1.coverUrl,
                    label: finishedViewModel1.label,
                    style: AgoraConsultationFinishedStyle.grid,
                    onClick: () => _onCardClick(context, finishedViewModel1.id, finishedViewModel1.externalLink),
                    isExternalLink: finishedViewModel1.externalLink != null,
                    index: consultationFinishedViewModels.indexOf(finishedViewModel1),
                    maxIndex: consultationFinishedViewModels.length,
                  ),
                ),
                SizedBox(width: AgoraSpacings.horizontalPadding),
                finishedViewModel2 != null
                    ? Expanded(
                        child: AgoraConsultationFinishedCard(
                          id: finishedViewModel2.id,
                          title: finishedViewModel2.title,
                          thematique: finishedViewModel2.thematique,
                          imageUrl: finishedViewModel2.coverUrl,
                          label: finishedViewModel2.label,
                          style: AgoraConsultationFinishedStyle.grid,
                          onClick: () => _onCardClick(context, finishedViewModel2!.id, finishedViewModel2.externalLink),
                          isExternalLink: finishedViewModel2.externalLink != null,
                          index: consultationFinishedViewModels.indexOf(finishedViewModel2),
                          maxIndex: consultationFinishedViewModels.length,
                        ),
                      )
                    : Expanded(child: Container()),
              ],
            ),
          ),
        );
        widgets.add(SizedBox(height: AgoraSpacings.base));
      }
    } else {
      for (final finishedViewModel in consultationFinishedViewModels) {
        widgets.add(
          AgoraConsultationFinishedCard(
            id: finishedViewModel.id,
            title: finishedViewModel.title,
            thematique: finishedViewModel.thematique,
            imageUrl: finishedViewModel.coverUrl,
            label: finishedViewModel.label,
            style: AgoraConsultationFinishedStyle.column,
            onClick: () => _onCardClick(context, finishedViewModel.id, finishedViewModel.externalLink),
            isExternalLink: finishedViewModel.externalLink != null,
            index: consultationFinishedViewModels.indexOf(finishedViewModel),
            maxIndex: consultationFinishedViewModels.length,
            fixedSize: false,
          ),
        );
        widgets.add(SizedBox(height: AgoraSpacings.base));
      }
    }

    if (state is ConsultationFinishedPaginatedInitialState || state is ConsultationFinishedPaginatedLoadingState) {
      widgets.add(Center(child: CircularProgressIndicator()));
      widgets.add(SizedBox(height: AgoraSpacings.base));
    } else if (state is ConsultationPaginatedErrorState) {
      widgets.add(
        AgoraErrorView(
          onReload: () => context.read<ConsultationPaginatedBloc>().add(
                FetchConsultationPaginatedEvent(
                  pageNumber: state.currentPageNumber,
                  type: type,
                ),
              ),
        ),
      );
      widgets.add(SizedBox(height: AgoraSpacings.base));
    } else {
      if (state.currentPageNumber < state.maxPage) {
        widgets.add(
          AgoraButton(
            label: GenericStrings.displayMore,
            isRounded: true,
            onTap: () => context.read<ConsultationPaginatedBloc>().add(
                  FetchConsultationPaginatedEvent(
                    pageNumber: state.currentPageNumber + 1,
                    type: type,
                  ),
                ),
          ),
        );
        widgets.add(SizedBox(height: AgoraSpacings.base));
      }
    }
    widgets.add(SizedBox(height: AgoraSpacings.x0_5));
    return widgets;
  }

  void _onCardClick(BuildContext context, String consultationId, String? externalLink) {
    TrackerHelper.trackClick(
      clickName: "${AnalyticsEventNames.finishedConsultation} $consultationId",
      widgetName: AnalyticsScreenNames.consultationsFinishedPaginatedPage,
    );
    if (externalLink != null) {
      LaunchUrlHelper.webview(context, externalLink);
    } else {
      Navigator.pushNamed(
        context,
        DynamicConsultationPage.routeName,
        arguments: DynamicConsultationPageArguments(
          consultationId: consultationId,
          shouldReloadConsultationsWhenPop: false,
        ),
      );
    }
  }
}

enum ConsultationPaginatedPageType {
  finished,
  answered;
}
