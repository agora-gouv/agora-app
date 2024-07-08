import 'package:agora/agora_app_router.dart';
import 'package:agora/common/helper/deeplink_helper.dart';
import 'package:agora/common/helper/responsive_helper.dart';
import 'package:agora/common/log/log.dart';
import 'package:agora/common/manager/service_manager.dart';
import 'package:agora/common/manager/storage_manager.dart';
import 'package:agora/common/navigator/navigator_key.dart';
import 'package:agora/common/observer/matomo_route_observer.dart';
import 'package:agora/common/observer/navigation_observer.dart';
import 'package:agora/design/style/agora_colors.dart';
import 'package:agora/pages/consultation/dynamic/dynamic_consultation_page.dart';
import 'package:agora/pages/loading_page.dart';
import 'package:agora/pages/onboarding/onboarding_page.dart';
import 'package:agora/pages/qag/details/qag_details_page.dart';
import 'package:agora/pages/qag/qags_page.dart';
import 'package:agora/welcome/pages/welcome_page.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AgoraApp extends StatefulWidget {
  final SharedPreferences sharedPref;
  final bool shouldShowOnboarding;
  final String agoraAppIcon;

  static final matomoRouteObserver = MatomoRouteObserver();
  static final navigationObserver = NavigationObserver();

  const AgoraApp({
    super.key,
    required this.sharedPref,
    required this.shouldShowOnboarding,
    required this.agoraAppIcon,
  });

  @override
  State<AgoraApp> createState() => _AgoraAppState();
}

class _AgoraAppState extends State<AgoraApp> with WidgetsBindingObserver {
  final deeplinkHelper = DeeplinkHelper();
  void Function(BuildContext) onRedirect = (context) {
    Navigator.pushReplacementNamed(context, WelcomePage.routeName);
  };

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this); // for didChangeAppLifecycleState

    if (widget.shouldShowOnboarding) {
      onRedirect = (context) {
        Navigator.pushReplacementNamed(context, QagsPage.routeName);
        Navigator.pushNamed(context, OnboardingPage.routeName).then((value) {
          StorageManager.getOnboardingStorageClient().save(false);
        });
      };
    }
    if (!kIsWeb) {
      deeplinkHelper.onGetUriLinkStream(
        onConsultationSuccessCallback: (id) {
          navigatorKey.currentState?.pushNamed(
            DynamicConsultationPage.routeName,
            arguments: DynamicConsultationPageArguments(consultationId: id),
          );
        },
        onQagSuccessCallback: (id) {
          navigatorKey.currentState?.pushNamed(
            QagDetailsPage.routeName,
            arguments: QagDetailsArguments(qagId: id, reload: QagReload.qagsPage),
          );
        },
      );
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    if (!kIsWeb) {
      if (state == AppLifecycleState.resumed) {
        // work only when app is already open
        Log.d("notification : resume");
        await Future.delayed(Duration(milliseconds: 200));
        ServiceManager.getPushNotificationService().redirectionFromSavedNotificationMessage();
      }
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    deeplinkHelper.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Agora",
      initialRoute: LoadingPage.routeName,
      builder: (context, child) => ResponsiveBreakpoints.builder(
        child: child!,
        breakpoints: [
          const Breakpoint(
            start: 0,
            end: ResponsiveHelper.mobileBreakPoint,
            name: MOBILE,
          ),
          const Breakpoint(
            start: ResponsiveHelper.mobileBreakPoint + 1,
            end: ResponsiveHelper.tabletBreakPoint,
            name: TABLET,
          ),
          const Breakpoint(
            start: ResponsiveHelper.tabletBreakPoint + 1,
            end: ResponsiveHelper.desktopBreakPoint,
            name: DESKTOP,
          ),
          const Breakpoint(
            start: ResponsiveHelper.desktopBreakPoint + 1,
            end: double.infinity,
            name: '4K',
          ),
        ],
      ),
      navigatorKey: navigatorKey,
      navigatorObservers: [
        AgoraApp.matomoRouteObserver,
        AgoraApp.navigationObserver,
      ],
      routes: AgoraAppRouter.handleAgoraRoutes(),
      onGenerateRoute: (RouteSettings settings) => AgoraAppRouter.handleAgoraGenerateRoute(
        settings: settings,
        sharedPref: widget.sharedPref,
        deepLinkHelper: deeplinkHelper,
        onRedirect: onRedirect,
        agoraAppIcon: widget.agoraAppIcon,
      ),
      theme: ThemeData(
        colorScheme: ColorScheme.light(
          primary: AgoraColors.primaryBlue,
          secondary: AgoraColors.primaryBlue,
        ),
        hoverColor: AgoraColors.neutral400,
        highlightColor: AgoraColors.neutral400,
        focusColor: AgoraColors.neutral200,
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}
