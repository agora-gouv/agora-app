import 'package:agora/bloc/qag/response_paginated/qag_response_paginated_bloc.dart';
import 'package:agora/bloc/qag/response_paginated/qag_response_paginated_event.dart';
import 'package:agora/bloc/qag/response_paginated/qag_response_paginated_state.dart';
import 'package:agora/common/analytics/analytics_event_names.dart';
import 'package:agora/common/analytics/analytics_screen_names.dart';
import 'package:agora/common/helper/tracker_helper.dart';
import 'package:agora/common/manager/repository_manager.dart';
import 'package:agora/common/strings/generic_strings.dart';
import 'package:agora/common/strings/qag_strings.dart';
import 'package:agora/design/custom_view/agora_error_view.dart';
import 'package:agora/design/custom_view/agora_qag_response_card.dart';
import 'package:agora/design/custom_view/agora_rich_text.dart';
import 'package:agora/design/custom_view/agora_scaffold.dart';
import 'package:agora/design/custom_view/agora_secondary_style_view.dart';
import 'package:agora/design/custom_view/button/agora_rounded_button.dart';
import 'package:agora/design/style/agora_spacings.dart';
import 'package:agora/pages/qag/details/qag_details_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class QagResponsePaginatedPage extends StatelessWidget {
  static const routeName = "/qagResponsePaginatedPage";

  final initialPage = 1;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (BuildContext context) => QagResponsePaginatedBloc(
            qagRepository: RepositoryManager.getQagRepository(),
          )..add(FetchQagsResponsePaginatedEvent(pageNumber: initialPage)),
        ),
      ],
      child: AgoraScaffold(
        child: AgoraSecondaryStyleView(
          pageLabel: QagStrings.qagResponsePart1 + QagStrings.qagResponsePart2,
          scrollType: AgoraSecondaryScrollType.custom,
          title: AgoraRichText(
            policeStyle: AgoraRichTextPoliceStyle.toolbar,
            items: [
              AgoraRichTextItem(
                text: QagStrings.qagResponsePart1,
                style: AgoraRichTextItemStyle.bold,
              ),
              AgoraRichTextItem(
                text: QagStrings.qagResponsePart2,
                style: AgoraRichTextItemStyle.regular,
              ),
            ],
          ),
          child: BlocBuilder<QagResponsePaginatedBloc, QagResponsePaginatedState>(
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

  List<Widget> _buildContent(BuildContext context, QagResponsePaginatedState state) {
    final List<Widget> widgets = [];
    for (final qagResponse in state.qagResponseViewModels) {
      widgets.add(
        AgoraQagResponseCard(
          titre: qagResponse.title,
          thematique: qagResponse.thematique,
          auteurImageUrl: qagResponse.authorPortraitUrl,
          auteur: qagResponse.author,
          date: qagResponse.responseDate,
          style: AgoraQagResponseStyle.large,
          maxIndex: state.qagResponseViewModels.length,
          index: state.qagResponseViewModels.indexOf(qagResponse),
          onClick: () {
            TrackerHelper.trackClick(
              clickName: "${AnalyticsEventNames.answeredQag} ${qagResponse.qagId}",
              widgetName: AnalyticsScreenNames.qagsResponsePaginatedPage,
            );
            Navigator.pushNamed(
              context,
              QagDetailsPage.routeName,
              arguments: QagDetailsArguments(qagId: qagResponse.qagId, reload: null),
            );
          },
        ),
      );
      widgets.add(SizedBox(height: AgoraSpacings.base));
    }

    if (state is QagResponsePaginatedInitialState || state is QagResponsePaginatedLoadingState) {
      widgets.add(Center(child: CircularProgressIndicator()));
      widgets.add(SizedBox(height: AgoraSpacings.base));
    } else if (state is QagResponsePaginatedErrorState) {
      widgets.add(AgoraErrorView());
      widgets.add(SizedBox(height: AgoraSpacings.base));
      widgets.add(
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AgoraRoundedButton(
              label: GenericStrings.retry,
              style: AgoraRoundedButtonStyle.primaryButtonStyle,
              onPressed: () => context
                  .read<QagResponsePaginatedBloc>()
                  .add(FetchQagsResponsePaginatedEvent(pageNumber: state.currentPageNumber)),
            ),
          ],
        ),
      );
      widgets.add(SizedBox(height: AgoraSpacings.base));
    } else {
      if (state.currentPageNumber < state.maxPage) {
        widgets.add(
          AgoraRoundedButton(
            label: GenericStrings.displayMore,
            style: AgoraRoundedButtonStyle.primaryButtonStyle,
            onPressed: () => context
                .read<QagResponsePaginatedBloc>()
                .add(FetchQagsResponsePaginatedEvent(pageNumber: state.currentPageNumber + 1)),
          ),
        );
        widgets.add(SizedBox(height: AgoraSpacings.base));
      }
    }
    widgets.add(SizedBox(height: AgoraSpacings.x0_5));
    return widgets;
  }
}
