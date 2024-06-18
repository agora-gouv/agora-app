import 'package:agora/bloc/qag/response/qag_response_bloc.dart';
import 'package:agora/bloc/qag/response/qag_response_event.dart';
import 'package:agora/bloc/qag/response_paginated/qag_response_paginated_bloc.dart';
import 'package:agora/bloc/qag/response_paginated/qag_response_paginated_event.dart';
import 'package:agora/bloc/qag/response_paginated/qag_response_paginated_state.dart';
import 'package:agora/bloc/thematique/thematique_view_model.dart';
import 'package:agora/common/analytics/analytics_event_names.dart';
import 'package:agora/common/analytics/analytics_screen_names.dart';
import 'package:agora/common/helper/tracker_helper.dart';
import 'package:agora/common/manager/repository_manager.dart';
import 'package:agora/common/strings/generic_strings.dart';
import 'package:agora/common/strings/reponse_strings.dart';
import 'package:agora/design/custom_view/agora_error_view.dart';
import 'package:agora/design/custom_view/agora_main_toolbar.dart';
import 'package:agora/design/custom_view/agora_qag_response_card.dart';
import 'package:agora/design/custom_view/agora_rich_text.dart';
import 'package:agora/design/custom_view/agora_tracker.dart';
import 'package:agora/design/custom_view/button/agora_rounded_button.dart';
import 'package:agora/design/style/agora_spacings.dart';
import 'package:agora/pages/profile/profile_page.dart';
import 'package:agora/pages/qag/details/qag_details_page.dart';
import 'package:agora/pages/qag/qag_reponse_a_venir_section.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ReponsesPage extends StatelessWidget {
  static const routeName = '/reponsesPage';

  const ReponsesPage();

  @override
  Widget build(BuildContext context) {
    return AgoraTracker(
      widgetName: AnalyticsScreenNames.reponsesPage,
      child: SingleChildScrollView(
        physics: ClampingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            AgoraMainToolbar(
              title: AgoraRichText(
                policeStyle: AgoraRichTextPoliceStyle.toolbar,
                semantic: AgoraRichTextSemantic(focused: true),
                items: [
                  AgoraRichTextItem(text: "${ReponseStrings.reponsesTitrePart1}\n", style: AgoraRichTextItemStyle.bold),
                  AgoraRichTextItem(text: ReponseStrings.reponsesTitrePart2, style: AgoraRichTextItemStyle.regular),
                ],
              ),
              onProfileClick: () {
                Navigator.pushNamed(context, ProfilePage.routeName);
              },
            ),
            SizedBox(height: AgoraSpacings.base),
            _ReponsesSection(),
            SizedBox(height: AgoraSpacings.x2),
            BlocProvider(
              create: (BuildContext context) => QagResponseBloc(
                qagRepository: RepositoryManager.getQagRepository(),
              )..add(FetchQagsResponseEvent()),
              child: QagReponsesAVenirSection(),
            ),
          ],
        ),
      ),
    );
  }
}

class _ReponsesSection extends StatelessWidget {
  const _ReponsesSection();

  final initialPage = 1;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => QagResponsePaginatedBloc(
        qagRepository: RepositoryManager.getQagRepository(),
      )..add(FetchQagsResponsePaginatedEvent(pageNumber: initialPage)),
      child: BlocBuilder<QagResponsePaginatedBloc, QagResponsePaginatedState>(
        builder: (context, state) {
          return _ReponseList(state);
        },
      ),
    );
  }
}

class _ReponseList extends StatelessWidget {
  final QagResponsePaginatedState state;

  const _ReponseList(this.state);

  @override
  Widget build(BuildContext context) {
    final qagResponseViewModels = state.qagResponseViewModels;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        ListView.separated(
          padding: EdgeInsets.symmetric(horizontal: AgoraSpacings.horizontalPadding),
          physics: const NeverScrollableScrollPhysics(),
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          separatorBuilder: (_, index) => SizedBox(height: AgoraSpacings.base),
          itemCount: qagResponseViewModels.length,
          itemBuilder: (context, index) {
            return AgoraQagResponseCard(
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
                  arguments: QagDetailsArguments(qagId: qagResponseViewModels[index].qagId, reload: null),
                );
              },
            );
          },
        ),
        if (state is QagResponsePaginatedInitialState || state is QagResponsePaginatedLoadingState)
          _LoadingReponseList()
        else if (state is QagResponsePaginatedErrorState)
          AgoraErrorView(
            onReload: () => context
                .read<QagResponsePaginatedBloc>()
                .add(FetchQagsResponsePaginatedEvent(pageNumber: state.currentPageNumber)),
          )
        else if (state.currentPageNumber < state.maxPage)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: AgoraSpacings.base),
            child: AgoraRoundedButton(
              label: GenericStrings.displayMore,
              style: AgoraRoundedButtonStyle.primaryButtonStyle,
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
      padding: const EdgeInsets.symmetric(vertical: AgoraSpacings.base),
      child: Center(child: CircularProgressIndicator()),
    );
  }
}
