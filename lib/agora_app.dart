import 'package:agora/agora_app_router.dart';
import 'package:agora/common/helper/deeplink_helper.dart';
import 'package:agora/common/helper/responsive_helper.dart';
import 'package:agora/common/log/log.dart';
import 'package:agora/common/manager/service_manager.dart';
import 'package:agora/common/manager/storage_manager.dart';
import 'package:agora/common/navigator/navigator_key.dart';
import 'package:agora/common/observer/matomo_route_observer.dart';
import 'package:agora/common/observer/navigation_observer.dart';
import 'package:agora/common/strings/consultation_strings.dart';
import 'package:agora/consultation/dynamic/pages/dynamic_consultation_page.dart';
import 'package:agora/design/style/agora_colors.dart';
import 'package:agora/profil/onboarding/pages/onboarding_page.dart';
import 'package:agora/qag/details/pages/qag_details_page.dart';
import 'package:agora/splash_page.dart';
import 'package:agora/welcome/pages/welcome_page.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
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
        Navigator.pushReplacementNamed(context, WelcomePage.routeName);
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
            arguments: DynamicConsultationPageArguments(
              consultationIdOrSlug: id,
              consultationTitle: '${ConsultationStrings.toolbarPart1} ${ConsultationStrings.toolbarPart2}',
            ),
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
        Log.debug("notification : resume");
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
      initialRoute: SplashPage.routeName,
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
      locale: const Locale("fr", "FR"),
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('fr', 'FR'),
        Locale('en', 'US'),
      ],
      navigatorObservers: [
        AgoraApp.matomoRouteObserver,
        AgoraApp.navigationObserver,
      ],
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
        hoverColor: AgoraColors.neutral200,
        highlightColor: AgoraColors.neutral200,
        focusColor: AgoraColors.neutral200,
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}
