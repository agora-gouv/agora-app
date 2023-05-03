import 'package:agora/bloc/deeplink/deeplink_bloc.dart';
import 'package:agora/bloc/deeplink/deeplink_event.dart';
import 'package:agora/bloc/deeplink/deeplink_state.dart';
import 'package:agora/bloc/login/login_bloc.dart';
import 'package:agora/bloc/login/login_event.dart';
import 'package:agora/bloc/login/login_state.dart';
import 'package:agora/bloc/notification/notification_bloc.dart';
import 'package:agora/bloc/notification/notification_event.dart';
import 'package:agora/bloc/notification/notification_state.dart';
import 'package:agora/bloc/thematique/thematique_bloc.dart';
import 'package:agora/bloc/thematique/thematique_event.dart';
import 'package:agora/bloc/thematique/thematique_state.dart';
import 'package:agora/bloc/thematique/thematique_with_id_view_model.dart';
import 'package:agora/common/manager/helper_manager.dart';
import 'package:agora/common/manager/repository_manager.dart';
import 'package:agora/common/manager/service_manager.dart';
import 'package:agora/common/manager/storage_manager.dart';
import 'package:agora/common/strings/generic_strings.dart';
import 'package:agora/design/agora_button_style.dart';
import 'package:agora/design/agora_spacings.dart';
import 'package:agora/design/agora_text_styles.dart';
import 'package:agora/design/custom_view/agora_alert_dialog.dart';
import 'package:agora/design/custom_view/agora_error_view.dart';
import 'package:agora/design/custom_view/agora_scaffold.dart';
import 'package:agora/design/custom_view/agora_thematique_card.dart';
import 'package:agora/design/custom_view/button/agora_button.dart';
import 'package:agora/pages/consultation/consultation_details_page.dart';
import 'package:agora/pages/consultation/consultations_page.dart';
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
          create: (context) => NotificationBloc(
            firstConnectionStorageClient: StorageManager.getFirstConnectionStorageClient(),
            permissionHelper: HelperManager.getPermissionHelper(),
            platformHelper: HelperManager.getPlatformHelper(),
            deviceInfoHelper: HelperManager.getDeviceInfoHelper(),
          )..add(RequestNotificationPermissionEvent()),
        ),
        BlocProvider(
          create: (context) => DeeplinkBloc(
            deeplinkHelper: HelperManager.getDeepLinkHelper(),
          )..add(InitDeeplinkListenerEvent()),
        ),
        BlocProvider(
          create: (context) => LoginBloc(
            repository: RepositoryManager.getLoginRepository(),
            loginStorageClient: StorageManager.getLoginStorageClient(),
            deviceInfoHelper: HelperManager.getDeviceInfoHelper(),
            pushNotificationService: ServiceManager.getPushNotificationService(),
          )..add(CheckLoginEvent()),
        ),
        BlocProvider(
          create: (context) => ThematiqueBloc(
            repository: RepositoryManager.getThematiqueRepository(),
          )..add(FetchThematiqueEvent()),
        ),
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
          child: BlocListener<DeeplinkBloc, DeeplinkState>(
            listener: (context, deeplinkState) {
              if (deeplinkState is ConsultationDeeplinkState) {
                Navigator.pushNamed(
                  context,
                  ConsultationDetailsPage.routeName,
                  arguments: ConsultationDetailsArguments(consultationId: deeplinkState.consultationId),
                );
              } else if (deeplinkState is QagDeeplinkState) {
                Navigator.pushNamed(
                  context,
                  QagDetailsPage.routeName,
                  arguments: QagDetailsArguments(qagId: deeplinkState.qagId),
                );
              }
            },
            child: BlocBuilder<LoginBloc, LoginState>(
              builder: (context, loginState) {
                return BlocBuilder<ThematiqueBloc, ThematiqueState>(
                  builder: (context, thematiqueState) {
                    return buildView(context, thematiqueState, loginState);
                  },
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget buildView(BuildContext context, ThematiqueState thematiqueState, LoginState loginState) {
    if (thematiqueState is ThematiqueInitialLoadingState || loginState is LoginInitialLoadingState) {
      return Center(child: CircularProgressIndicator());
    } else if (thematiqueState is ThematiqueErrorState || loginState is LoginErrorState) {
      return Center(child: AgoraErrorView());
    } else if (thematiqueState is ThematiqueSuccessState && loginState is LoginSuccessState) {
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
                        arguments: ConsultationDetailsArguments(consultationId: "c29255f2-10ca-4be5-aab1-801ea173337c"),
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
                        arguments: QagDetailsArguments(qagId: "f29c5d6f-9838-4c57-a7ec-0612145bb0c8"),
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
                        arguments: QagDetailsArguments(qagId: "889b41ad-321b-4338-8596-df745c546919"),
                      );
                    },
                  ),
                  SizedBox(height: AgoraSpacings.x0_5),
                  AgoraButton(
                    label: "Poser une question au gouvernement",
                    style: AgoraButtonStyle.primaryButtonStyle,
                    onPressed: () {
                      Navigator.pushNamed(context, QagAskQuestionPage.routeName);
                    },
                  ),
                  SizedBox(height: AgoraSpacings.x0_5),
                  AgoraButton(
                    label: "Consultation List",
                    style: AgoraButtonStyle.primaryButtonStyle,
                    onPressed: () {
                      Navigator.pushNamed(context, ConsultationsPage.routeName);
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

  List<Widget> _buildThematiques(List<ThematiqueWithIdViewModel> thematiqueViewModels) {
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
