import 'package:agora/agora_app.dart';
import 'package:agora/bloc/login/login_bloc.dart';
import 'package:agora/bloc/login/login_event.dart';
import 'package:agora/bloc/login/login_state.dart';
import 'package:agora/bloc/notification/permission/notification_permission_bloc.dart';
import 'package:agora/bloc/notification/permission/notification_permission_event.dart';
import 'package:agora/bloc/notification/permission/notification_permission_state.dart';
import 'package:agora/common/helper/launch_url_helper.dart';
import 'package:agora/common/helper/platform_helper.dart';
import 'package:agora/common/helper/tracker_helper.dart';
import 'package:agora/common/log/log.dart';
import 'package:agora/common/manager/helper_manager.dart';
import 'package:agora/common/manager/repository_manager.dart';
import 'package:agora/common/manager/service_manager.dart';
import 'package:agora/common/manager/storage_manager.dart';
import 'package:agora/common/strings/generic_strings.dart';
import 'package:agora/design/custom_view/agora_alert_dialog.dart';
import 'package:agora/design/custom_view/agora_scaffold.dart';
import 'package:agora/design/custom_view/agora_top_diagonal.dart';
import 'package:agora/design/custom_view/button/agora_button.dart';
import 'package:agora/design/style/agora_button_style.dart';
import 'package:agora/design/style/agora_colors.dart';
import 'package:agora/design/style/agora_corners.dart';
import 'package:agora/design/style/agora_spacings.dart';
import 'package:agora/design/style/agora_text_styles.dart';
import 'package:agora/domain/login/login_error_type.dart';
import 'package:agora/pages/consultation/consultations_page.dart';
import 'package:agora/pages/consultation/details/consultation_details_page.dart';
import 'package:agora/pages/onboarding/onboarding_page.dart';
import 'package:agora/pages/qag/details/qag_details_page.dart';
import 'package:agora/pages/qag/qags_page.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class LoadingPage extends StatefulWidget {
  static const routeName = "/";

  final SharedPreferences sharedPref;
  final Redirection redirection;

  const LoadingPage({super.key, required this.sharedPref, required this.redirection});

  @override
  State<LoadingPage> createState() => _LoadingPageState();
}

class _LoadingPageState extends State<LoadingPage> {
  late Image agoraLogoImage;

  @override
  void initState() {
    super.initState();
    agoraLogoImage = Image.asset("assets/launcher_icons/ic_agora_logo.png", semanticLabel: "Agora");
  }

  @override
  void didChangeDependencies() {
    precacheImage(agoraLogoImage.image, context);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => NotificationPermissionBloc(
            notificationFirstRequestPermissionStorageClient: StorageManager.getFirstConnectionStorageClient(),
            permissionHelper: HelperManager.getPermissionHelper(),
            platformHelper: HelperManager.getPlatformHelper(),
            deviceInfoHelper: HelperManager.getDeviceInfoHelper(),
          )..add(RequestNotificationPermissionEvent()),
        ),
        BlocProvider(
          create: (context) => LoginBloc(
            repository: RepositoryManager.getLoginRepository(),
            loginStorageClient: StorageManager.getLoginStorageClient(sharedPref: widget.sharedPref),
            deviceInfoHelper: HelperManager.getDeviceInfoHelper(),
            pushNotificationService: ServiceManager.getPushNotificationService(),
            jwtHelper: HelperManager.getJwtHelper(),
            roleHelper: HelperManager.getRoleHelper(),
            appVersionHelper: HelperManager.getAppVersionHelper(),
            platformHelper: HelperManager.getPlatformHelper(),
          )..add(CheckLoginEvent()),
        ),
      ],
      child: AgoraScaffold(
        appBarColor: AgoraColors.primaryBlue,
        child: BlocListener<NotificationPermissionBloc, NotificationPermissionState>(
          listener: (context, notificationState) async {
            if (!kIsWeb) {
              if (notificationState is AskNotificationConsentState) {
                _showNotificationDialog(context);
              } else if (notificationState is AutoAskNotificationConsentState) {
                await Permission.notification.request();
                TrackerHelper.trackDimension();
              }
            }
          },
          child: BlocConsumer<LoginBloc, LoginState>(
            listener: (context, loginState) async {
              if (loginState is LoginSuccessState) {
                _pushPageWithCondition(context);
              }
            },
            builder: (context, loginState) {
              final screenSize = MediaQuery.of(context).size;
              final screenHeight = screenSize.height;
              final screenWidth = screenSize.width;
              if (loginState is LoginErrorState) {
                return Column(
                  children: [
                    AgoraTopDiagonal(),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: AgoraSpacings.horizontalPadding),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            loginState.errorType == LoginErrorType.updateVersion
                                ? Image.asset('assets/force_update.png')
                                : SvgPicture.asset("assets/ic_oops.svg", excludeFromSemantics: true),
                            SizedBox(height: AgoraSpacings.x1_25),
                            Semantics(
                              focused: true,
                              child: Text(
                                _buildErrorText(loginState.errorType),
                                style: AgoraTextStyles.medium18,
                                textAlign: TextAlign.center,
                              ),
                            ),
                            if (loginState.errorType != LoginErrorType.updateVersion) ...[
                              SizedBox(height: AgoraSpacings.x1_25),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  Flexible(
                                    child: AgoraButton(
                                      label: GenericStrings.contactSupport,
                                      style: AgoraButtonStyle.blueBorderButtonStyle,
                                      onPressed: () {
                                        final Uri emailUri = Uri(
                                          scheme: 'mailto',
                                          path: GenericStrings.mailSupport,
                                        );

                                        launchUrl(emailUri);
                                      },
                                    ),
                                  ),
                                  SizedBox(width: AgoraSpacings.base),
                                  AgoraButton(
                                    label: GenericStrings.retry,
                                    style: AgoraButtonStyle.primaryButtonStyle,
                                    onPressed: () => context.read<LoginBloc>().add(CheckLoginEvent()),
                                  ),
                                ],
                              ),
                            ],
                            if (loginState.errorType == LoginErrorType.updateVersion &&
                                (PlatformStaticHelper.isAndroid() || PlatformStaticHelper.isIOS())) ...[
                              SizedBox(height: AgoraSpacings.x1_25),
                              AgoraButton(
                                label: GenericStrings.updateApp,
                                style: AgoraButtonStyle.primaryButtonStyle,
                                expanded: true,
                                onPressed: () => LaunchUrlHelper.launchStore(),
                              ),
                            ],
                            SizedBox(height: screenHeight * 0.1),
                          ],
                        ),
                      ),
                    ),
                  ],
                );
              } else if (loginState is LoginSuccessState) {
                return _buildContent(
                  screenHeight: screenHeight,
                  screenWidth: screenWidth,
                  children: [
                    SizedBox(width: 76, height: 76, child: agoraLogoImage),
                    SizedBox(height: AgoraSpacings.x3 + 5),
                    Container(width: double.infinity),
                  ],
                );
              } else {
                return _buildContent(
                  screenHeight: screenHeight,
                  screenWidth: screenWidth,
                  children: [
                    SizedBox(width: 76, height: 76, child: agoraLogoImage),
                    SizedBox(height: AgoraSpacings.x3),
                    Semantics(
                      focused: true,
                      label: "En cours de chargement",
                      child: LinearPercentIndicator(
                        percent: 1,
                        animation: true,
                        animationDuration: 2000,
                        progressColor: AgoraColors.primaryBlue,
                        restartAnimation: true,
                        barRadius: AgoraCorners.rounded50,
                      ),
                    ),
                  ],
                );
              }
            },
          ),
        ),
      ),
    );
  }

  String _buildErrorText(LoginErrorType errorType) {
    switch (errorType) {
      case LoginErrorType.generic:
        return GenericStrings.authenticationErrorMessage;
      case LoginErrorType.timeout:
        return GenericStrings.timeoutErrorMessage;
      case LoginErrorType.updateVersion:
        return GenericStrings.updateAppVersionErrorMessage;
    }
  }

  void _pushPageWithCondition(BuildContext context) {
    if (widget.redirection.shouldShowQagDetails) {
      Navigator.pushReplacementNamed(context, QagsPage.routeName);
      Navigator.pushNamed(
        context,
        QagDetailsPage.routeName,
        arguments: QagDetailsArguments(qagId: widget.redirection.qagId!, reload: QagReload.qagsPage),
      );
    } else {
      Navigator.pushReplacementNamed(context, ConsultationsPage.routeName);
      if (widget.redirection.shouldShowConsultationDetails) {
        Navigator.pushNamed(
          context,
          ConsultationDetailsPage.routeName,
          arguments: ConsultationDetailsArguments(consultationId: widget.redirection.consultationId!),
        );
      }
      if (widget.redirection.shouldShowOnboarding) {
        Navigator.pushNamed(context, OnboardingPage.routeName).then((value) {
          StorageManager.getOnboardingStorageClient().save(false);
        });
      }
    }
    if (!kIsWeb) {
      Log.d("notification : start app");
      ServiceManager.getPushNotificationService().redirectionFromSavedNotificationMessage();
    }
  }

  Widget _buildContent({
    required double screenHeight,
    required double screenWidth,
    required List<Widget> children,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.2),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: children,
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
}
