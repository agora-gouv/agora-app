import 'package:agora/agora_app.dart';
import 'package:agora/bloc/login/login_bloc.dart';
import 'package:agora/bloc/login/login_event.dart';
import 'package:agora/bloc/login/login_state.dart';
import 'package:agora/bloc/notification/notification_bloc.dart';
import 'package:agora/bloc/notification/notification_event.dart';
import 'package:agora/bloc/notification/notification_state.dart';
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
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
    agoraLogoImage = Image.asset("assets/launcher_icons/ic_agora_logo.png", width: 76);
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
          create: (context) => NotificationBloc(
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
          )..add(CheckLoginEvent()),
        ),
      ],
      child: AgoraScaffold(
        appBarColor: AgoraColors.primaryBlue,
        child: BlocListener<NotificationBloc, NotificationState>(
          listener: (context, notificationState) async {
            if (notificationState is AskNotificationConsentState) {
              _showNotificationDialog(context);
            } else if (notificationState is AutoAskNotificationConsentState) {
              await Permission.notification.request();
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
                            SvgPicture.asset("assets/ic_oops.svg"),
                            SizedBox(height: AgoraSpacings.x1_25),
                            Text(
                              loginState.errorType == LoginErrorType.generic
                                  ? GenericStrings.authenticationErrorMessage
                                  : GenericStrings.timeoutErrorMessage,
                              style: AgoraTextStyles.medium18,
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(height: AgoraSpacings.x1_25),
                            AgoraButton(
                              label: GenericStrings.retry,
                              style: AgoraButtonStyle.blueBorderButtonStyle,
                              onPressed: () => context.read<LoginBloc>().add(CheckLoginEvent()),
                            ),
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
                    agoraLogoImage,
                    SizedBox(height: AgoraSpacings.x3 + 5),
                  ],
                );
              } else {
                return _buildContent(
                  screenHeight: screenHeight,
                  screenWidth: screenWidth,
                  children: [
                    agoraLogoImage,
                    SizedBox(height: AgoraSpacings.x3),
                    LinearPercentIndicator(
                      percent: 1,
                      animation: true,
                      animationDuration: 2000,
                      progressColor: AgoraColors.primaryBlue,
                      restartAnimation: true,
                      barRadius: AgoraCorners.rounded50,
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

  void _pushPageWithCondition(BuildContext context) {
    if (widget.redirection.shouldShowQagDetails) {
      Navigator.pushNamed(context, QagsPage.routeName);
      Navigator.pushNamed(
        context,
        QagDetailsPage.routeName,
        arguments: QagDetailsArguments(qagId: widget.redirection.qagId!),
      );
    } else {
      Navigator.pushNamed(context, ConsultationsPage.routeName);
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
  }

  Widget _buildContent({
    required double screenHeight,
    required double screenWidth,
    required List<Widget> children,
  }) {
    return SizedBox(
      height: screenHeight,
      width: screenWidth,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: AgoraSpacings.x3 * 2),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: children,
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
}
