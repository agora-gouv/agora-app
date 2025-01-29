import 'package:agora/common/manager/repository_manager.dart';
import 'package:agora/common/strings/generic_strings.dart';
import 'package:agora/common/strings/profile_strings.dart';
import 'package:agora/design/custom_view/agora_scaffold.dart';
import 'package:agora/design/custom_view/button/agora_button.dart';
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
              child: _Content(state),
            ),
          );
        },
      ),
    );
  }
}

class _Content extends StatelessWidget {
  final NotificationState state;

  const _Content(this.state);

  @override
  Widget build(BuildContext context) {
    return switch (state) {
      NotificationInitialState _ || NotificationLoadingState _ => _Loading(),
      NotificationFetchedState _ => _Success(state: state),
      NotificationErrorState _ => _Error(),
    };
  }
}

class _Success extends StatelessWidget {
  const _Success({
    required this.state,
  });

  final NotificationState state;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AgoraSpacings.horizontalPadding),
      child: Column(
        children: [
          ...state.notificationViewModels.map(
            (vm) => Padding(
              padding: const EdgeInsets.only(bottom: AgoraSpacings.base),
              child: AgoraNotificationCard(
                titre: vm.title,
                description: vm.description,
                type: vm.type,
                date: vm.date,
              ),
            ),
          ),
          if (state.hasMoreNotifications) ...[
            AgoraButton.withLabel(
              label: ProfileStrings.displayMore,
              buttonStyle: AgoraButtonStyle.tertiary,
              onPressed: () =>
                  context.read<NotificationBloc>().add(GetNotificationEvent(pageNumber: state.currentPageNumber + 1)),
            ),
            SizedBox(height: AgoraSpacings.base),
          ],
          if (state.notificationViewModels.isEmpty) ...[
            Text(
              GenericStrings.notificationEmpty,
              style: AgoraTextStyles.medium14,
              textAlign: TextAlign.center,
            ),
            SizedBox(height: AgoraSpacings.base),
          ],
        ],
      ),
    );
  }
}

class _Error extends StatelessWidget {
  const _Error();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AgoraSpacings.horizontalPadding),
      child: Column(
        children: [
          AgoraErrorText(),
          SizedBox(height: AgoraSpacings.base),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AgoraButton.withLabel(
                label: ProfileStrings.retry,
                buttonStyle: AgoraButtonStyle.tertiary,
                onPressed: () => context.read<NotificationBloc>().add(GetNotificationEvent(pageNumber: 1)),
              ),
            ],
          ),
          SizedBox(height: AgoraSpacings.base),
        ],
      ),
    );
  }
}

class _Loading extends StatelessWidget {
  const _Loading();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AgoraSpacings.horizontalPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(height: AgoraSpacings.base),
          SkeletonBox(height: 80),
          SizedBox(height: AgoraSpacings.base),
          SkeletonBox(height: 80),
          SizedBox(height: AgoraSpacings.base),
        ],
      ),
    );
  }
}
