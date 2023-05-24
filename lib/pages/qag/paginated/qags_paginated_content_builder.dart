import 'package:agora/bloc/qag/paginated/qag_paginated_state.dart';
import 'package:agora/common/strings/qag_strings.dart';
import 'package:agora/design/custom_view/agora_error_view.dart';
import 'package:agora/design/custom_view/agora_qag_card.dart';
import 'package:agora/design/custom_view/button/agora_rounded_button.dart';
import 'package:agora/design/style/agora_spacings.dart';
import 'package:agora/pages/qag/details/qag_details_page.dart';
import 'package:flutter/material.dart';

class QagsPaginatedContentBuilder {
  static List<Widget> buildWidgets({
    required BuildContext context,
    required QagPaginatedState qagPaginatedState,
    required VoidCallback onDisplayMoreClick,
    required VoidCallback onRetryClick,
  }) {
    final List<Widget> qagsWidgets = [];
    for (final qagPaginatedViewModel in qagPaginatedState.qagViewModels) {
      qagsWidgets.add(
        AgoraQagCard(
          id: qagPaginatedViewModel.id,
          thematique: qagPaginatedViewModel.thematique,
          title: qagPaginatedViewModel.title,
          username: qagPaginatedViewModel.username,
          date: qagPaginatedViewModel.date,
          supportCount: qagPaginatedViewModel.supportCount,
          isSupported: qagPaginatedViewModel.isSupported,
          onClick: () {
            Navigator.pushNamed(
              context,
              QagDetailsPage.routeName,
              arguments: QagDetailsArguments(qagId: qagPaginatedViewModel.id),
            );
          },
        ),
      );
      qagsWidgets.add(SizedBox(height: AgoraSpacings.base));
    }

    if (qagPaginatedState is QagPaginatedLoadingState) {
      qagsWidgets.add(Center(child: CircularProgressIndicator()));
      qagsWidgets.add(SizedBox(height: AgoraSpacings.base));
    } else if (qagPaginatedState is QagPaginatedErrorState) {
      qagsWidgets.add(AgoraErrorView());
      qagsWidgets.add(SizedBox(height: AgoraSpacings.base));
      qagsWidgets.add(
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AgoraRoundedButton(
              label: QagStrings.retry,
              style: AgoraRoundedButtonStyle.primaryButton,
              onPressed: () => onRetryClick(),
            ),
          ],
        ),
      );
      qagsWidgets.add(SizedBox(height: AgoraSpacings.base));
    } else {
      if (qagPaginatedState.currentPageNumber < qagPaginatedState.maxPage) {
        qagsWidgets.add(
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AgoraRoundedButton(
                label: QagStrings.displayMore,
                style: AgoraRoundedButtonStyle.primaryButton,
                onPressed: () => onDisplayMoreClick(),
              ),
            ],
          ),
        );
        qagsWidgets.add(SizedBox(height: AgoraSpacings.base));
      }
    }
    return qagsWidgets;
  }
}
