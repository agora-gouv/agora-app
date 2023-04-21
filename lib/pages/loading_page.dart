import 'package:agora/bloc/notification/notification_bloc.dart';
import 'package:agora/bloc/notification/notification_event.dart';
import 'package:agora/bloc/notification/notification_state.dart';
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

class LoadingPage extends StatefulWidget {
  static const routeName = "/";

  @override
  State<LoadingPage> createState() => _LoadingPageState();
}

class _LoadingPageState extends State<LoadingPage> with WidgetsBindingObserver {
  bool hasOpenSetting = false;

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    if (state == AppLifecycleState.resumed) {
      final notificationStorage = StorageManager.getNotificationStorageClient();
      if (hasOpenSetting) {
        hasOpenSetting = false;
        if (await Permission.notification.isGranted) {
          notificationStorage.save(true);
        } else {
          notificationStorage.delete();
        }
      }
    }
  }

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
      ],
      child: AgoraScaffold(
        child: BlocListener<NotificationBloc, NotificationState>(
          listener: (context, state) async {
            if (state is AskNotificationConsentState) {
              _showNotificationDialog(context);
            } else if (state is AutoAskNotificationConsentState) {
              await Permission.notification.request();
            }
          },
          child: BlocBuilder<ThematiqueBloc, ThematiqueState>(
            builder: (context, state) {
              if (state is ThematiqueInitialLoadingState) {
                return Center(child: CircularProgressIndicator());
              } else if (state is ThematiqueErrorState) {
                return Center(child: AgoraErrorView());
              } else if (state is ThematiqueSuccessState) {
                return SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: AgoraSpacings.horizontalPadding),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: _buildThematiques(state.thematiqueViewModels) +
                          [
                            SizedBox(height: AgoraSpacings.x2),
                            AgoraButton(
                              label: "Détails d'une consultation",
                              style: AgoraButtonStyle.primaryButtonStyle,
                              onPressed: () {
                                Navigator.pushNamed(
                                  context,
                                  ConsultationDetailsPage.routeName,
                                  arguments: BlocProvider.of<ThematiqueBloc>(context),
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
                                  arguments: state.thematiqueViewModels,
                                );
                              },
                            ),
                            SizedBox(height: AgoraSpacings.x3),
                          ],
                    ),
                  ),
                );
              } else {
                return Container();
              }
            },
          ),
        ),
      ),
    );
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
