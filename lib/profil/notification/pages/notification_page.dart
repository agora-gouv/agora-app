import 'package:agora/common/manager/repository_manager.dart';
import 'package:agora/common/strings/generic_strings.dart';
import 'package:agora/common/strings/profile_strings.dart';
import 'package:agora/design/custom_view/agora_scaffold.dart';
import 'package:agora/design/custom_view/button/agora_rounded_button.dart';
import 'package:agora/design/custom_view/button/agora_secondary_style_view_button.dart';
import 'package:agora/design/custom_view/card/agora_notification_card.dart';
import 'package:agora/design/custom_view/error/agora_error_text.dart';
import 'package:agora/design/custom_view/skeletons.dart';
import 'package:agora/design/custom_view/text/agora_rich_text.dart';
import 'package:agora/design/style/agora_spacings.dart';
import 'package:agora/design/style/agora_text_styles.dart';
import 'package:agora/profil/notification/bloc/get/notification_bloc.dart';
import 'package:agora/profil/notification/bloc/get/notification_event.dart';
import 'package:agora/profil/notification/bloc/get/notification_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class NotificationPage extends StatefulWidget {
  static const routeName = "/notificationPage";

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  static const initialPage = 1;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<NotificationBloc>(
          create: (BuildContext context) => NotificationBloc(
            notificationRepository: RepositoryManager.getNotificationRepository(),
          )..add(GetNotificationEvent(pageNumber: initialPage)),
        ),
      ],
      child: BlocBuilder<NotificationBloc, NotificationState>(
        builder: (context, state) {
          return AgoraScaffold(
            child: AgoraSecondaryStyleView(
              semanticPageLabel: ProfileStrings.notification,
              title: AgoraRichText(
                policeStyle: AgoraRichTextPoliceStyle.toolbar,
                items: [
                  AgoraRichTextItem(
                    text: ProfileStrings.notification,
                    style: AgoraRichTextItemStyle.bold,
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: AgoraSpacings.horizontalPadding),
                child: Column(children: _buildContent(context, state)),
              ),
            ),
          );
        },
      ),
    );
  }

  List<Widget> _buildContent(BuildContext context, NotificationState state) {
    final List<Widget> widgets = [];

    final notificationViewModels = state.notificationViewModels;
    for (final notificationViewModel in notificationViewModels) {
      widgets.add(
        AgoraNotificationCard(
          title: notificationViewModel.title,
          type: notificationViewModel.type,
          date: notificationViewModel.date,
        ),
      );
      widgets.add(SizedBox(height: AgoraSpacings.base));
    }

    if (state is NotificationInitialState || state is NotificationLoadingState) {
      widgets.add(
        Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(height: AgoraSpacings.base),
            SkeletonBox(height: 80),
            SizedBox(height: AgoraSpacings.base),
            SkeletonBox(height: 80),
          ],
        ),
      );
      widgets.add(SizedBox(height: AgoraSpacings.base));
    } else if (state is NotificationErrorState) {
      widgets.add(AgoraErrorText());
      widgets.add(SizedBox(height: AgoraSpacings.base));
      widgets.add(
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AgoraRoundedButton(
              label: ProfileStrings.retry,
              style: AgoraRoundedButtonStyle.primaryButtonStyle,
              onPressed: () =>
                  context.read<NotificationBloc>().add(GetNotificationEvent(pageNumber: state.currentPageNumber)),
            ),
          ],
        ),
      );
      widgets.add(SizedBox(height: AgoraSpacings.base));
    } else {
      if (state.hasMoreNotifications) {
        widgets.add(
          AgoraRoundedButton(
            label: ProfileStrings.displayMore,
            style: AgoraRoundedButtonStyle.primaryButtonStyle,
            onPressed: () =>
                context.read<NotificationBloc>().add(GetNotificationEvent(pageNumber: state.currentPageNumber + 1)),
          ),
        );
        widgets.add(SizedBox(height: AgoraSpacings.base));
      }
      if (notificationViewModels.isEmpty) {
        widgets.add(SizedBox(height: AgoraSpacings.x0_5));
        widgets.add(
          Text(
            GenericStrings.notificationEmpty,
            style: AgoraTextStyles.medium14,
            textAlign: TextAlign.center,
          ),
        );
      }
    }
    widgets.add(SizedBox(height: AgoraSpacings.x0_5));
    return widgets;
  }
}
