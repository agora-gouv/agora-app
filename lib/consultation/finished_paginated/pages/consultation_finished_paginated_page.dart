import 'package:agora/common/analytics/analytics_event_names.dart';
import 'package:agora/common/analytics/analytics_screen_names.dart';
import 'package:agora/common/helper/all_purpose_status.dart';
import 'package:agora/common/helper/launch_url_helper.dart';
import 'package:agora/common/helper/responsive_helper.dart';
import 'package:agora/common/helper/tracker_helper.dart';
import 'package:agora/common/manager/repository_manager.dart';
import 'package:agora/common/strings/consultation_strings.dart';
import 'package:agora/common/strings/generic_strings.dart';
import 'package:agora/common/strings/semantics_strings.dart';
import 'package:agora/consultation/dynamic/pages/dynamic_consultation_page.dart';
import 'package:agora/consultation/finished_paginated/bloc/consultation_finished_paginated_bloc.dart';
import 'package:agora/consultation/finished_paginated/bloc/consultation_finished_paginated_event.dart';
import 'package:agora/consultation/finished_paginated/bloc/consultation_finished_paginated_state.dart';
import 'package:agora/consultation/finished_paginated/bloc/consultation_finished_paginated_view_model.dart';
import 'package:agora/design/custom_view/agora_filtre.dart';
import 'package:agora/design/custom_view/agora_scaffold.dart';
import 'package:agora/design/custom_view/button/agora_button.dart';
import 'package:agora/design/custom_view/button/agora_secondary_style_view_button.dart';
import 'package:agora/design/custom_view/card/agora_consultation_finished_card.dart';
import 'package:agora/design/custom_view/error/agora_error_view.dart';
import 'package:agora/design/custom_view/text/agora_rich_text.dart';
import 'package:agora/design/style/agora_spacings.dart';
import 'package:agora/design/style/agora_text_styles.dart';
import 'package:agora/territorialisation/pays.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

enum ConsultationPaginatedPageType {
  finished,
  answered;
}

class ConsultationFinishedPaginatedPage extends StatelessWidget {
  static const routeName = "/consultationFinishedPaginatedPage";

  final ConsultationPaginatedPageType type;

  const ConsultationFinishedPaginatedPage(this.type);

  final initialPage = 1;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) {
        return ConsultationPaginatedBloc(
          consultationRepository: RepositoryManager.getConsultationRepository(),
          concertationRepository: RepositoryManager.getConcertationRepository(),
          referentielRepository: RepositoryManager.getReferentielRepository(),
          demographicRepository: RepositoryManager.getDemographicRepository(),
        )..add(FetchConsultationPaginatedEvent(pageNumber: initialPage, type: type));
      },
      child: AgoraScaffold(
        child: AgoraSecondaryStyleView(
          semanticPageLabel: SemanticsStrings.allConsultationTerminees,
          isTitleHasSemantic: true,
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
              return _Content(state, type);
            },
          ),
        ),
      ),
    );
  }
}

class _Content extends StatelessWidget {
  final ConsultationPaginatedState state;
  final ConsultationPaginatedPageType type;

  const _Content(this.state, this.type);

  @override
  Widget build(BuildContext context) {
    switch (state.territoireState.status) {
      case AllPurposeStatus.notLoaded:
      case AllPurposeStatus.loading:
        return Center(child: CircularProgressIndicator());
      case AllPurposeStatus.error:
        return AgoraErrorView(
          onReload: () => context.read<ConsultationPaginatedBloc>().add(
                FetchConsultationPaginatedEvent(
                  pageNumber: state.currentPageNumber,
                  type: type,
                ),
              ),
        );
      case AllPurposeStatus.success:
        return _Success(state, type);
    }
  }
}

class _Success extends StatelessWidget {
  final ConsultationPaginatedState state;
  final ConsultationPaginatedPageType type;

  const _Success(this.state, this.type);

  @override
  Widget build(BuildContext context) {
    final territoires = [Pays(label: "Tous"), Pays(label: "National"), ...state.territoireState.territoires];
    final filtreItems = territoires.map(
      (territoire) {
        return AgoraFiltreItem(
          label: territoire.label,
          isSelected: state.filtreTerritoire == null && territoire.label == "Tous"
              ? true
              : state.filtreTerritoire == territoire,
          onSelect: () {
            context.read<ConsultationPaginatedBloc>().add(
                  FetchConsultationPaginatedEvent(
                    pageNumber: state.currentPageNumber,
                    type: type,
                    filtreTerritoire: territoire.label == "Tous" ? null : territoire,
                  ),
                );
          },
        );
      },
    ).toList();
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AgoraSpacings.horizontalPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          AgoraFiltre(filtreItems),
          SizedBox(height: AgoraSpacings.base),
          _ListCard(state.currentPageNumber, type, state.consultationsListState),
          SizedBox(height: AgoraSpacings.base),
          if (state.currentPageNumber < state.maxPage) ...[
            AgoraButton.withLabel(
              label: GenericStrings.displayMore,
              buttonStyle: AgoraButtonStyle.tertiary,
              onPressed: () => context.read<ConsultationPaginatedBloc>().add(
                    FetchConsultationPaginatedEvent(
                      pageNumber: state.currentPageNumber + 1,
                      type: type,
                    ),
                  ),
            ),
            SizedBox(height: AgoraSpacings.base),
          ],
        ],
      ),
    );
  }
}

class _ListCard extends StatelessWidget {
  final int currentPageNumber;
  final ConsultationPaginatedPageType type;
  final ConsultationsListState consultationsListState;

  const _ListCard(this.currentPageNumber, this.type, this.consultationsListState);

  @override
  Widget build(BuildContext context) {
    return switch (consultationsListState.status) {
      AllPurposeStatus.notLoaded || AllPurposeStatus.loading => Center(child: CircularProgressIndicator()),
      AllPurposeStatus.error => AgoraErrorView(
          onReload: () => context.read<ConsultationPaginatedBloc>().add(
                FetchConsultationPaginatedEvent(
                  pageNumber: currentPageNumber,
                  type: type,
                ),
              ),
        ),
      AllPurposeStatus.success => _ListSuccess(consultationsListState.consultationViewModels),
    };
  }
}

class _ListSuccess extends StatelessWidget {
  final List<ConsultationPaginatedViewModel> consultationFinishedViewModels;

  const _ListSuccess(this.consultationFinishedViewModels);

  @override
  Widget build(BuildContext context) {
    final largerThanMobile = ResponsiveHelper.isLargerThanMobile(context);
    final List<Widget> children = [];
    if (largerThanMobile) {
      for (var index = 0; index < consultationFinishedViewModels.length; index = index + 2) {
        final finishedViewModel1 = consultationFinishedViewModels[index];
        ConsultationPaginatedViewModel? finishedViewModel2;
        if (index + 1 < consultationFinishedViewModels.length) {
          finishedViewModel2 = consultationFinishedViewModels[index + 1];
        }
        children.add(
          IntrinsicHeight(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Expanded(
                  child: AgoraConsultationFinishedCard(
                    id: finishedViewModel1.id,
                    titre: finishedViewModel1.title,
                    thematique: finishedViewModel1.thematique,
                    imageUrl: finishedViewModel1.coverUrl,
                    flammeLabel: finishedViewModel1.label,
                    style: AgoraConsultationFinishedStyle.grid,
                    onTap: () => _onCardClick(
                      context,
                      finishedViewModel1.id,
                      finishedViewModel1.title,
                      finishedViewModel1.externalLink,
                    ),
                    isExternalLink: finishedViewModel1.externalLink != null,
                    index: consultationFinishedViewModels.indexOf(finishedViewModel1),
                    maxIndex: consultationFinishedViewModels.length,
                    badgeLabel: finishedViewModel1.badgeLabel,
                    badgeColor: finishedViewModel1.badgeColor,
                    badgeTextColor: finishedViewModel1.badgeTextColor,
                  ),
                ),
                SizedBox(width: AgoraSpacings.horizontalPadding),
                finishedViewModel2 != null
                    ? Expanded(
                        child: AgoraConsultationFinishedCard(
                          id: finishedViewModel2.id,
                          titre: finishedViewModel2.title,
                          thematique: finishedViewModel2.thematique,
                          imageUrl: finishedViewModel2.coverUrl,
                          flammeLabel: finishedViewModel2.label,
                          style: AgoraConsultationFinishedStyle.grid,
                          onTap: () => _onCardClick(
                            context,
                            finishedViewModel2!.id,
                            finishedViewModel2.title,
                            finishedViewModel2.externalLink,
                          ),
                          isExternalLink: finishedViewModel2.externalLink != null,
                          index: consultationFinishedViewModels.indexOf(finishedViewModel2),
                          maxIndex: consultationFinishedViewModels.length,
                          badgeLabel: finishedViewModel2.badgeLabel,
                          badgeColor: finishedViewModel2.badgeColor,
                          badgeTextColor: finishedViewModel2.badgeTextColor,
                        ),
                      )
                    : Expanded(child: Container()),
              ],
            ),
          ),
        );
        children.add(SizedBox(height: AgoraSpacings.base));
      }
    } else {
      for (final finishedViewModel in consultationFinishedViewModels) {
        children.add(
          AgoraConsultationFinishedCard(
            id: finishedViewModel.id,
            titre: finishedViewModel.title,
            thematique: finishedViewModel.thematique,
            imageUrl: finishedViewModel.coverUrl,
            flammeLabel: finishedViewModel.label,
            style: AgoraConsultationFinishedStyle.column,
            onTap: () => _onCardClick(
              context,
              finishedViewModel.id,
              finishedViewModel.title,
              finishedViewModel.externalLink,
            ),
            isExternalLink: finishedViewModel.externalLink != null,
            index: consultationFinishedViewModels.indexOf(finishedViewModel),
            maxIndex: consultationFinishedViewModels.length,
            fixedSize: false,
            badgeLabel: finishedViewModel.badgeLabel,
            badgeColor: finishedViewModel.badgeColor,
            badgeTextColor: finishedViewModel.badgeTextColor,
          ),
        );
        children.add(SizedBox(height: AgoraSpacings.base));
      }
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ...children,
        if (consultationFinishedViewModels.isEmpty)
          Text(
            ConsultationStrings.noFinishedConsultation,
            style: AgoraTextStyles.medium14,
            textAlign: TextAlign.center,
          ),
      ],
    );
  }

  void _onCardClick(BuildContext context, String consultationId, String consultationTitle, String? externalLink) {
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
          consultationIdOrSlug: consultationId,
          consultationTitle: consultationTitle,
          shouldReloadConsultationsWhenPop: false,
        ),
      );
    }
  }
}
