import 'package:agora/common/helper/deeplink_helper.dart';
import 'package:agora/common/helper/launch_url_helper.dart';
import 'package:agora/common/helper/platform_helper.dart';
import 'package:agora/common/helper/tracker_helper.dart';
import 'package:agora/common/log/log.dart';
import 'package:agora/common/manager/helper_manager.dart';
import 'package:agora/common/manager/repository_manager.dart';
import 'package:agora/common/manager/service_manager.dart';
import 'package:agora/common/manager/storage_manager.dart';
import 'package:agora/common/strings/consultation_strings.dart';
import 'package:agora/common/strings/generic_strings.dart';
import 'package:agora/consultation/dynamic/pages/dynamic_consultation_page.dart';
import 'package:agora/consultation/pages/consultations_page.dart';
import 'package:agora/design/custom_view/agora_alert_dialog.dart';
import 'package:agora/design/custom_view/agora_scaffold.dart';
import 'package:agora/design/custom_view/button/agora_button.dart';
import 'package:agora/design/style/agora_colors.dart';
import 'package:agora/design/style/agora_corners.dart';
import 'package:agora/design/style/agora_spacings.dart';
import 'package:agora/design/style/agora_text_styles.dart';
import 'package:agora/login/bloc/login_bloc.dart';
import 'package:agora/login/bloc/login_event.dart';
import 'package:agora/login/bloc/login_state.dart';
import 'package:agora/login/domain/login_error_type.dart';
import 'package:agora/profil/notification/bloc/permission/notification_permission_bloc.dart';
import 'package:agora/profil/notification/bloc/permission/notification_permission_event.dart';
import 'package:agora/profil/notification/bloc/permission/notification_permission_state.dart';
import 'package:agora/qag/details/pages/qag_details_page.dart';
import 'package:agora/qag/pages/qags_page.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class SplashPage extends StatefulWidget {
  static const routeName = "/";

  final SharedPreferences sharedPref;
  final void Function(BuildContext) onRedirect;
  final DeeplinkHelper deepLinkHelper;
  final String agoraAppIcon;

  const SplashPage({
    super.key,
    required this.sharedPref,
    required this.onRedirect,
    required this.deepLinkHelper,
    required this.agoraAppIcon,
  });

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  late Image agoraLogoImage;

  @override
  void initState() {
    super.initState();
    agoraLogoImage = Image.asset(widget.agoraAppIcon, semanticLabel: "Agora");
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
            loginRepository: RepositoryManager.getLoginRepository(),
            loginStorageClient: StorageManager.getLoginStorageClient(sharedPref: widget.sharedPref),
            deviceInfoHelper: HelperManager.getDeviceInfoHelper(),
            pushNotificationService: ServiceManager.getPushNotificationService(),
            jwtHelper: HelperManager.getJwtHelper(),
            roleHelper: HelperManager.getRoleHelper(),
            appVersionHelper: HelperManager.getAppVersionHelper(),
            platformHelper: HelperManager.getPlatformHelper(),
            welcomeRepository: RepositoryManager.getWelcomeRepository(sharedPref: widget.sharedPref),
          )..add(CheckLoginEvent()),
        ),
      ],
      child: AgoraScaffold(
        appBarType: AppBarColorType.primaryColor,
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
                await _pushPageWithCondition(context);
              }
            },
            builder: (context, loginState) {
              final screenSize = MediaQuery.of(context).size;
              final screenHeight = screenSize.height;
              final screenWidth = screenSize.width;
              if (loginState is LoginErrorState) {
                return Column(
                  children: [
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
                                    child: AgoraButton.withLabel(
                                      label: GenericStrings.contactSupport,
                                      buttonStyle: AgoraButtonStyle.secondary,
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
                                  AgoraButton.withLabel(
                                    label: GenericStrings.retry,
                                    buttonStyle: AgoraButtonStyle.primary,
                                    onPressed: () => context.read<LoginBloc>().add(CheckLoginEvent()),
                                  ),
                                ],
                              ),
                            ],
                            if (loginState.errorType == LoginErrorType.updateVersion &&
                                (PlatformStaticHelper.isAndroid() || PlatformStaticHelper.isIOS())) ...[
                              SizedBox(height: AgoraSpacings.x1_25),
                              AgoraButton.withLabel(
                                label: GenericStrings.updateApp,
                                buttonStyle: AgoraButtonStyle.primary,
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

  Future<void> _pushPageWithCondition(BuildContext context) async {
    widget.onRedirect(context);
    await widget.deepLinkHelper.onInitial(
      onConsultationSuccessCallback: (slug) {
        Navigator.pushReplacementNamed(context, ConsultationsPage.routeName);
        Navigator.pushNamed(
          context,
          DynamicConsultationPage.routeName,
          arguments: DynamicConsultationPageArguments(
            consultationIdOrSlug: slug,
            consultationTitle: '${ConsultationStrings.toolbarPart1} ${ConsultationStrings.toolbarPart2}',
          ),
        );
      },
      onQagSuccessCallback: (id) {
        Navigator.pushReplacementNamed(context, QagsPage.routeName);
        Navigator.pushNamed(
          context,
          QagDetailsPage.routeName,
          arguments: QagDetailsArguments(qagId: id, reload: QagReload.qagsPage),
        );
      },
    );
    if (!kIsWeb) {
      Log.debug("notification : start app");
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
            AgoraButton.withLabel(
              label: GenericStrings.rejectNotificationPermissionButton,
              buttonStyle: AgoraButtonStyle.secondary,
              onPressed: () => Navigator.pop(context),
            ),
            SizedBox(height: AgoraSpacings.base),
            AgoraButton.withLabel(
              label: GenericStrings.acceptNotificationPermissionButton,
              buttonStyle: AgoraButtonStyle.primary,
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
