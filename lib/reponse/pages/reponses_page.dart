import 'package:agora/common/analytics/analytics_event_names.dart';
import 'package:agora/common/analytics/analytics_screen_names.dart';
import 'package:agora/common/helper/all_purpose_status.dart';
import 'package:agora/common/helper/tracker_helper.dart';
import 'package:agora/common/manager/repository_manager.dart';
import 'package:agora/common/strings/generic_strings.dart';
import 'package:agora/common/strings/reponse_strings.dart';
import 'package:agora/design/custom_view/agora_focus_helper.dart';
import 'package:agora/design/custom_view/agora_main_toolbar.dart';
import 'package:agora/design/custom_view/agora_pull_to_refresh.dart';
import 'package:agora/design/custom_view/agora_tracker.dart';
import 'package:agora/design/custom_view/button/agora_button.dart';
import 'package:agora/design/custom_view/card/agora_qag_response_card.dart';
import 'package:agora/design/custom_view/error/agora_error_view.dart';
import 'package:agora/design/custom_view/skeletons.dart';
import 'package:agora/design/custom_view/text/agora_rich_text.dart';
import 'package:agora/design/style/agora_spacings.dart';
import 'package:agora/qag/details/pages/qag_details_page.dart';
import 'package:agora/reponse/bloc/paginated/qag_response_paginated_bloc.dart';
import 'package:agora/reponse/bloc/paginated/qag_response_paginated_event.dart';
import 'package:agora/reponse/bloc/paginated/qag_response_paginated_state.dart';
import 'package:agora/reponse/bloc/qag_response_bloc.dart';
import 'package:agora/reponse/bloc/qag_response_event.dart';
import 'package:agora/reponse/widgets/qag_reponse_a_venir_section.dart';
import 'package:agora/thematique/bloc/thematique_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ReponsesPage extends StatelessWidget {
  static const routeName = '/reponsesPage';

  const ReponsesPage();

  @override
  Widget build(BuildContext context) {
    return AgoraTracker(
      widgetName: AnalyticsScreenNames.reponsesPage,
      child: MultiBlocProvider(
        providers: [
          BlocProvider<QagResponsePaginatedBloc>(
            lazy: false,
            create: (BuildContext context) => QagResponsePaginatedBloc.fromRepository(
              qagRepository: RepositoryManager.getQagCacheRepository(),
            )..add(FetchQagsResponsePaginatedEvent(pageNumber: 1)),
          ),
          BlocProvider<QagResponseBloc>(
            lazy: false,
            create: (BuildContext context) => QagResponseBloc.fromRepository(
              qagRepository: RepositoryManager.getQagCacheRepository(),
            )..add(FetchQagsResponseEvent()),
          ),
        ],
        child: _Content(),
      ),
    );
  }
}

class _Content extends StatelessWidget {
  const _Content();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AgoraMainToolbar(
          title: AgoraRichText(
            policeStyle: AgoraRichTextPoliceStyle.toolbar,
            semantic: AgoraRichTextSemantic(focused: true),
            items: [
              AgoraRichTextItem(
                text: "${ReponseStrings.reponsesTitrePart1}\n",
                style: AgoraRichTextItemStyle.bold,
              ),
              AgoraRichTextItem(text: ReponseStrings.reponsesTitrePart2, style: AgoraRichTextItemStyle.regular),
            ],
          ),
        ),
        Expanded(
          child: AgoraPullToRefresh(
            onRefresh: () async {
              context.read<QagResponsePaginatedBloc>().add(
                    FetchQagsResponsePaginatedEvent(pageNumber: 1, forceRefresh: true),
                  );
              context.read<QagResponseBloc>().add(FetchQagsResponseEvent(forceRefresh: true));
            },
            child: SingleChildScrollView(
              physics: ClampingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(height: AgoraSpacings.base),
                  _ReponsesSection(),
                  SizedBox(height: AgoraSpacings.x2),
                  QagReponsesAVenirSection(),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _ReponsesSection extends StatelessWidget {
  const _ReponsesSection();

  final initialPage = 1;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<QagResponsePaginatedBloc, QagResponsePaginatedState>(
      builder: (context, state) {
        if (state.status == AllPurposeStatus.error) {
          return AgoraErrorView(
            onReload: () => context
                .read<QagResponsePaginatedBloc>()
                .add(FetchQagsResponsePaginatedEvent(pageNumber: state.currentPageNumber)),
          );
        } else if (state.status == AllPurposeStatus.success || state.qagResponseViewModels.isNotEmpty) {
          return _ReponseList(state);
        } else if ((state.status == AllPurposeStatus.loading || state.status == AllPurposeStatus.notLoaded) &&
            state.qagResponseViewModels.isEmpty) {
          return _LoadingReponseList();
        } else {
          return SizedBox();
        }
      },
    );
  }
}

class _ReponseList extends StatelessWidget {
  final QagResponsePaginatedState state;
  final firstFocusableElementKey = GlobalKey();

  _ReponseList(this.state);

  @override
  Widget build(BuildContext context) {
    final qagResponseViewModels = state.qagResponseViewModels;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        AgoraFocusHelper(
          elementKey: firstFocusableElementKey,
          child: ListView.separated(
            padding: EdgeInsets.symmetric(horizontal: AgoraSpacings.horizontalPadding),
            physics: const NeverScrollableScrollPhysics(),
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            separatorBuilder: (_, __) => SizedBox(height: AgoraSpacings.base),
            itemCount: qagResponseViewModels.length,
            itemBuilder: (context, index) {
              return AgoraQagReponseCard(
                key: index == 0 ? firstFocusableElementKey : null,
                thematique: ThematiqueViewModel(
                  picto: qagResponseViewModels[index].thematique.picto,
                  label: qagResponseViewModels[index].thematique.label,
                ),
                titre: qagResponseViewModels[index].title,
                auteur: qagResponseViewModels[index].author,
                auteurImageUrl: qagResponseViewModels[index].authorPortraitUrl,
                date: qagResponseViewModels[index].responseDate,
                style: AgoraQagResponseStyle.large,
                index: index,
                maxIndex: qagResponseViewModels.length,
                onClick: () {
                  TrackerHelper.trackClick(
                    clickName: "${AnalyticsEventNames.answeredQag} ${qagResponseViewModels[index].qagId}",
                    widgetName: AnalyticsScreenNames.reponsesPage,
                  );
                  Navigator.pushNamed(
                    context,
                    QagDetailsPage.routeName,
                    arguments: QagDetailsArguments(
                      qagId: qagResponseViewModels[index].qagId,
                      reload: QagReload.qagsPaginatedPage,
                      isQuestionGagnante: true,
                    ),
                  );
                },
              );
            },
          ),
        ),
        if (state.status == AllPurposeStatus.loading)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: AgoraSpacings.base),
            child: CircularProgressIndicator(),
          ),
        if (state.currentPageNumber < state.maxPage)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: AgoraSpacings.base),
            child: AgoraButton.withLabel(
              label: GenericStrings.displayMore,
              buttonStyle: AgoraButtonStyle.tertiary,
              onPressed: () => context
                  .read<QagResponsePaginatedBloc>()
                  .add(FetchQagsResponsePaginatedEvent(pageNumber: state.currentPageNumber + 1)),
            ),
          ),
      ],
    );
  }
}

class _LoadingReponseList extends StatelessWidget {
  const _LoadingReponseList();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: AgoraSpacings.base),
      child: ListView.separated(
        padding: EdgeInsets.symmetric(horizontal: AgoraSpacings.horizontalPadding),
        physics: const NeverScrollableScrollPhysics(),
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        separatorBuilder: (_, index) => SizedBox(height: AgoraSpacings.base),
        itemCount: 3,
        itemBuilder: (context, index) {
          return SkeletonBox(
            height: 120,
          );
        },
      ),
    );
  }
}
