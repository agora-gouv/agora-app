import 'package:agora/bloc/deeplink/deeplink_event.dart';
import 'package:agora/bloc/deeplink/deeplink_state.dart';
import 'package:agora/bloc/notification/notification_bloc.dart';
import 'package:agora/bloc/notification/notification_event.dart';
import 'package:agora/bloc/notification/notification_state.dart';
import 'package:agora/bloc/qag/details/deeplink_bloc.dart';
import 'package:agora/bloc/thematique/thematique_bloc.dart';
import 'package:agora/bloc/thematique/thematique_event.dart';
import 'package:agora/bloc/thematique/thematique_state.dart';
import 'package:agora/bloc/thematique/thematique_view_model.dart';
import 'package:agora/common/client/helper_manager.dart';
import 'package:agora/common/client/repository_manager.dart';
import 'package:agora/common/client/storage_manager.dart';
import 'package:agora/common/strings/generic_strings.dart';
import 'package:agora/design/agora_button.dart';
import 'package:agora/design/agora_button_style.dart';
import 'package:agora/design/agora_spacings.dart';
import 'package:agora/design/agora_text_styles.dart';
import 'package:agora/design/custom_view/agora_alert_dialog.dart';
import 'package:agora/design/custom_view/agora_error_view.dart';
import 'package:agora/design/custom_view/agora_scaffold.dart';
import 'package:agora/design/custom_view/agora_thematique_card.dart';
import 'package:agora/pages/consultation/consultation_details_page.dart';
import 'package:agora/pages/qag/qag_ask_question_page.dart';
import 'package:agora/pages/qag/qag_details_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:permission_handler/permission_handler.dart';

class LoadingPage extends StatelessWidget {
  static const routeName = "/";

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => ThematiqueBloc(
            repository: RepositoryManager.getThematiqueRepository(),
          )..add(FetchThematiqueEvent()),
        ),
        BlocProvider(
          create: (context) => NotificationBloc(
            firstConnectionStorageClient: StorageManager.getFirstConnectionStorageClient(),
            permissionHelper: HelperManager.getPermissionHelper(),
            platformHelper: HelperManager.getPlatformHelper(),
            deviceInfoHelper: HelperManager.getDeviceInfoHelper(),
          )..add(RequestNotificationPermissionEvent()),
        ),
        BlocProvider(create: (context) => DeeplinkBloc(deeplinkHelper: HelperManager.getDeepLinkHelper())),
      ],
      child: AgoraScaffold(
        child: BlocListener<NotificationBloc, NotificationState>(
          listener: (context, notificationState) async {
            if (notificationState is AskNotificationConsentState) {
              _showNotificationDialog(context);
            } else if (notificationState is AutoAskNotificationConsentState) {
              await Permission.notification.request();
            }
          },
          child: BlocConsumer<ThematiqueBloc, ThematiqueState>(
            listener: (context, thematiqueState) {
              final deeplinkState = context.read<DeeplinkBloc>().state;
              if (deeplinkState is DeeplinkInitialState) {
                context.read<DeeplinkBloc>().add(InitDeeplinkListenerEvent());
              }
            },
            builder: (context, thematiqueState) {
              return BlocListener<DeeplinkBloc, DeeplinkState>(
                listener: (context, deeplinkState) {
                  if (deeplinkState is ConsultationDeeplinkState) {
                    Navigator.pushNamed(
                      context,
                      ConsultationDetailsPage.routeName,
                      arguments: ConsultationDetailsArguments(
                        thematiqueBloc: BlocProvider.of<ThematiqueBloc>(context),
                        consultationId: deeplinkState.consultationId,
                      ),
                    );
                  }
                },
                child: buildView(context, thematiqueState),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget buildView(BuildContext context, ThematiqueState thematiqueState) {
    if (thematiqueState is ThematiqueInitialLoadingState) {
      return Center(child: CircularProgressIndicator());
    } else if (thematiqueState is ThematiqueErrorState) {
      return Center(child: AgoraErrorView());
    } else if (thematiqueState is ThematiqueSuccessState) {
      return SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AgoraSpacings.horizontalPadding,
            vertical: AgoraSpacings.x2,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: _buildThematiques(thematiqueState.thematiqueViewModels) +
                [
                  SizedBox(height: AgoraSpacings.x2),
                  AgoraButton(
                    label: "Détails d'une consultation",
                    style: AgoraButtonStyle.primaryButtonStyle,
                    onPressed: () {
                      Navigator.pushNamed(
                        context,
                        ConsultationDetailsPage.routeName,
                        arguments: ConsultationDetailsArguments(
                          thematiqueBloc: BlocProvider.of<ThematiqueBloc>(context),
                          consultationId: "c29255f2-10ca-4be5-aab1-801ea173337c",
                        ),
                      );
                    },
                  ),
                  SizedBox(height: AgoraSpacings.x0_5),
                  AgoraButton(
                    label: "Détails d'une question au gouvernement sans réponse",
                    style: AgoraButtonStyle.primaryButtonStyle,
                    onPressed: () {
                      Navigator.pushNamed(
                        context,
                        QagDetailsPage.routeName,
                        arguments: QagDetailsArguments(
                          thematiqueBloc: BlocProvider.of<ThematiqueBloc>(context),
                          qagId: "f29c5d6f-9838-4c57-a7ec-0612145bb0c8",
                        ),
                      );
                    },
                  ),
                  SizedBox(height: AgoraSpacings.x0_5),
                  AgoraButton(
                    label: "Détails d'une question au gouvernement avec réponse",
                    style: AgoraButtonStyle.primaryButtonStyle,
                    onPressed: () {
                      Navigator.pushNamed(
                        context,
                        QagDetailsPage.routeName,
                        arguments: QagDetailsArguments(
                          thematiqueBloc: BlocProvider.of<ThematiqueBloc>(context),
                          qagId: "889b41ad-321b-4338-8596-df745c546919",
                        ),
                      );
                    },
                  ),
                  SizedBox(height: AgoraSpacings.x0_5),
                  AgoraButton(
                    label: "Poser une question au gouvernement",
                    style: AgoraButtonStyle.primaryButtonStyle,
                    onPressed: () {
                      Navigator.pushNamed(
                        context,
                        QagAskQuestionPage.routeName,
                        arguments: thematiqueState.thematiqueViewModels,
                      );
                    },
                  ),
                ],
          ),
        ),
      );
    } else {
      return Container();
    }
  }

  void _showNotificationDialog(BuildContext context) {
    showAgoraDialog(
      context: context,
      columnChildren: [
        Text(GenericStrings.askNotificationPermissionMessage, style: AgoraTextStyles.medium16),
        SizedBox(height: AgoraSpacings.base),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            AgoraButton(
              label: GenericStrings.rejectNotificationPermissionButton,
              style: AgoraButtonStyle.lightGreyButtonStyle,
              onPressed: () => Navigator.pop(context),
            ),
            SizedBox(height: AgoraSpacings.base),
            AgoraButton(
              label: GenericStrings.acceptNotificationPermissionButton,
              style: AgoraButtonStyle.primaryButtonStyle,
              onPressed: () {
                openAppSettings();
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ],
    );
  }

  List<Widget> _buildThematiques(List<ThematiqueViewModel> thematiqueViewModels) {
    final List<Widget> widgets = [];
    for (var thematiqueViewModel in thematiqueViewModels) {
      widgets.add(
        AgoraThematiqueCard(
          picto: thematiqueViewModel.picto,
          label: thematiqueViewModel.label,
          color: thematiqueViewModel.color,
        ),
      );
      widgets.add(SizedBox(height: AgoraSpacings.base));
    }
    return widgets;
  }
}
