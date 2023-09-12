import 'package:agora/bloc/qag/paginated/bloc/qag_paginated_latest_bloc.dart';
import 'package:agora/bloc/qag/paginated/bloc/qag_paginated_popular_bloc.dart';
import 'package:agora/bloc/qag/paginated/bloc/qag_paginated_supporting_bloc.dart';
import 'package:agora/bloc/qag/paginated/qag_paginated_event.dart';
import 'package:agora/bloc/qag/paginated/qag_paginated_state.dart';
import 'package:agora/bloc/qag/support/qag_support_bloc.dart';
import 'package:agora/bloc/qag/support/qag_support_event.dart';
import 'package:agora/bloc/qag/support/qag_support_state.dart';
import 'package:agora/common/analytics/analytics_event_names.dart';
import 'package:agora/common/analytics/analytics_screen_names.dart';
import 'package:agora/common/helper/tracker_helper.dart';
import 'package:agora/common/strings/generic_strings.dart';
import 'package:agora/common/strings/qag_strings.dart';
import 'package:agora/design/custom_view/agora_alert_dialog.dart';
import 'package:agora/design/custom_view/agora_error_view.dart';
import 'package:agora/design/custom_view/agora_qag_card.dart';
import 'package:agora/design/custom_view/button/agora_button.dart';
import 'package:agora/design/custom_view/button/agora_rounded_button.dart';
import 'package:agora/design/style/agora_button_style.dart';
import 'package:agora/design/style/agora_spacings.dart';
import 'package:agora/design/style/agora_text_styles.dart';
import 'package:agora/pages/qag/details/qag_details_page.dart';
import 'package:agora/pages/qag/paginated/qags_paginated_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class QagsPaginatedContentBuilder {
  static List<Widget> buildWidgets({
    required BuildContext context,
    required QagPaginatedTab paginatedTab,
    required QagPaginatedState qagPaginatedState,
    required VoidCallback onDisplayMoreClick,
    required VoidCallback onRetryClick,
  }) {
    final List<Widget> qagsWidgets = [];
    for (final qagPaginatedViewModel in qagPaginatedState.qagViewModels) {
      qagsWidgets.add(
        BlocConsumer<QagSupportBloc, QagSupportState>(
          listenWhen: (previousState, currentState) {
            return (currentState is QagSupportSuccessState && currentState.qagId == qagPaginatedViewModel.id) ||
                (currentState is QagDeleteSupportSuccessState && currentState.qagId == qagPaginatedViewModel.id) ||
                (currentState is QagSupportErrorState && currentState.qagId == qagPaginatedViewModel.id) ||
                (currentState is QagDeleteSupportErrorState && currentState.qagId == qagPaginatedViewModel.id);
          },
          listener: (previousState, currentState) {
            if (currentState is QagSupportSuccessState || currentState is QagDeleteSupportSuccessState) {
              final newSupportCount = _buildCount(qagPaginatedViewModel.supportCount, currentState);
              final newIsSupported = !qagPaginatedViewModel.isSupported;
              _updatePaginatedQags(
                context: context,
                paginatedTab: paginatedTab,
                qagId: qagPaginatedViewModel.id,
                supportCount: newSupportCount,
                isSupported: newIsSupported,
              );
            } else if (currentState is QagSupportErrorState || currentState is QagDeleteSupportErrorState) {
              showAgoraDialog(
                context: context,
                columnChildren: [
                  AgoraErrorView(),
                  SizedBox(height: AgoraSpacings.x0_75),
                  AgoraButton(
                    label: GenericStrings.close,
                    style: AgoraButtonStyle.primaryButtonStyle,
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              );
            }
          },
          buildWhen: (previousState, currentState) {
            return currentState is QagSupportInitialState ||
                currentState is QagSupportLoadingState ||
                currentState is QagDeleteSupportLoadingState ||
                (currentState is QagSupportSuccessState && currentState.qagId == qagPaginatedViewModel.id) ||
                (currentState is QagDeleteSupportSuccessState && currentState.qagId == qagPaginatedViewModel.id);
          },
          builder: (context, state) {
            return AgoraQagCard(
              id: qagPaginatedViewModel.id,
              thematique: qagPaginatedViewModel.thematique,
              title: qagPaginatedViewModel.title,
              username: qagPaginatedViewModel.username,
              date: qagPaginatedViewModel.date,
              supportCount: qagPaginatedViewModel.supportCount,
              isSupported: qagPaginatedViewModel.isSupported,
              onSupportClick: (support) {
                _track(paginatedTab: paginatedTab, isSupport: support);
                if (support) {
                  context.read<QagSupportBloc>().add(SupportQagEvent(qagId: qagPaginatedViewModel.id));
                } else {
                  context.read<QagSupportBloc>().add(DeleteSupportQagEvent(qagId: qagPaginatedViewModel.id));
                }
              },
              onCardClick: () {
                Navigator.pushNamed(
                  context,
                  QagDetailsPage.routeName,
                  arguments: QagDetailsArguments(qagId: qagPaginatedViewModel.id),
                ).then((result) {
                  final qagDetailsBackResult = result as QagDetailsBackResult?;
                  if (qagDetailsBackResult != null) {
                    _updatePaginatedQags(
                      context: context,
                      paginatedTab: paginatedTab,
                      qagId: qagDetailsBackResult.qagId,
                      supportCount: qagDetailsBackResult.supportCount,
                      isSupported: qagDetailsBackResult.isSupported,
                    );
                  }
                });
              },
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
              style: AgoraRoundedButtonStyle.primaryButtonStyle,
              onPressed: () => onRetryClick(),
            ),
          ],
        ),
      );
      qagsWidgets.add(SizedBox(height: AgoraSpacings.base));
    } else {
      if (qagPaginatedState.currentPageNumber == 1 && qagPaginatedState.qagViewModels.isEmpty) {
        qagsWidgets.add(Text(QagStrings.emptyList, style: AgoraTextStyles.medium14));
        qagsWidgets.add(SizedBox(height: AgoraSpacings.base));
      } else if (qagPaginatedState.currentPageNumber < qagPaginatedState.maxPage) {
        qagsWidgets.add(
          AgoraRoundedButton(
            label: QagStrings.displayMore,
            style: AgoraRoundedButtonStyle.primaryButtonStyle,
            onPressed: () => onDisplayMoreClick(),
          ),
        );
        qagsWidgets.add(SizedBox(height: AgoraSpacings.base));
      }
    }
    return qagsWidgets;
  }

  static void _updatePaginatedQags({
    required BuildContext context,
    required QagPaginatedTab paginatedTab,
    required String qagId,
    required int supportCount,
    required bool isSupported,
  }) {
    switch (paginatedTab) {
      case QagPaginatedTab.popular:
        context.read<QagPaginatedPopularBloc>().add(
              UpdateQagsPaginatedEvent(
                qagId: qagId,
                supportCount: supportCount,
                isSupported: isSupported,
              ),
            );
        break;
      case QagPaginatedTab.latest:
        context.read<QagPaginatedLatestBloc>().add(
              UpdateQagsPaginatedEvent(
                qagId: qagId,
                supportCount: supportCount,
                isSupported: isSupported,
              ),
            );
        break;
      case QagPaginatedTab.supporting:
        context.read<QagPaginatedSupportingBloc>().add(
              UpdateQagsPaginatedEvent(
                qagId: qagId,
                supportCount: supportCount,
                isSupported: isSupported,
              ),
            );
        break;
    }
  }

  static void _track({
    required QagPaginatedTab paginatedTab,
    required bool isSupport,
  }) {
    switch (paginatedTab) {
      case QagPaginatedTab.popular:
        TrackerHelper.trackClick(
          clickName: isSupport ? AnalyticsEventNames.likeQag : AnalyticsEventNames.unlikeQag,
          widgetName: AnalyticsScreenNames.qagsPaginatedPopularPage,
        );
        break;
      case QagPaginatedTab.latest:
        TrackerHelper.trackClick(
          clickName: isSupport ? AnalyticsEventNames.likeQag : AnalyticsEventNames.unlikeQag,
          widgetName: AnalyticsScreenNames.qagsPaginatedLatestPage,
        );
        break;
      case QagPaginatedTab.supporting:
        TrackerHelper.trackClick(
          clickName: isSupport ? AnalyticsEventNames.likeQag : AnalyticsEventNames.unlikeQag,
          widgetName: AnalyticsScreenNames.qagsPaginatedSupportingPage,
        );
        break;
    }
  }

  static int _buildCount(int supportCount, QagSupportState supportState) {
    if (supportState is QagSupportSuccessState) {
      return supportCount + 1;
    } else if (supportState is QagDeleteSupportSuccessState) {
      return supportCount - 1;
    }
    return supportCount;
  }
}
