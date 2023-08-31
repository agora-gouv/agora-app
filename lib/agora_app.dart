import 'package:agora/agora_app_router.dart';
import 'package:agora/common/helper/deeplink_helper.dart';
import 'package:agora/common/helper/responsive_helper.dart';
import 'package:agora/common/log/log.dart';
import 'package:agora/common/manager/service_manager.dart';
import 'package:agora/common/navigator/navigator_key.dart';
import 'package:agora/common/observer/matomo_route_observer.dart';
import 'package:agora/common/observer/navigation_observer.dart';
import 'package:agora/design/style/agora_colors.dart';
import 'package:agora/pages/consultation/details/consultation_details_page.dart';
import 'package:agora/pages/loading_page.dart';
import 'package:agora/pages/qag/details/qag_details_page.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AgoraApp extends StatefulWidget {
  final SharedPreferences sharedPref;
  final bool shouldShowOnboarding;

  static final matomoRouteObserver = MatomoRouteObserver();
  static final navigationObserver = NavigationObserver();

  const AgoraApp({super.key, required this.sharedPref, required this.shouldShowOnboarding});

  @override
  State<AgoraApp> createState() => _AgoraAppState();
}

class _AgoraAppState extends State<AgoraApp> with WidgetsBindingObserver {
  final deeplinkHelper = DeeplinkHelper();
  final redirection = Redirection();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this); // for didChangeAppLifecycleState

    if (widget.shouldShowOnboarding) {
      redirection.showOnboarding();
    }
    if (!kIsWeb) {
      deeplinkHelper.onInitial(
        onConsultationSuccessCallback: (id) {
          redirection.showConsultationDetails(id);
        },
        onQagSuccessCallback: (id) {
          redirection.showQagDetails(id);
        },
      );
      deeplinkHelper.onGetUriLinkStream(
        onConsultationSuccessCallback: (id) {
          navigatorKey.currentState?.pushNamed(
            ConsultationDetailsPage.routeName,
            arguments: ConsultationDetailsArguments(consultationId: id),
          );
        },
        onQagSuccessCallback: (id) {
          navigatorKey.currentState?.pushNamed(
            QagDetailsPage.routeName,
            arguments: QagDetailsArguments(qagId: id),
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
        redirection: redirection,
      ),
      theme: ThemeData(
        colorScheme: ColorScheme.light(
          primary: AgoraColors.primaryBlue,
          secondary: AgoraColors.primaryBlue,
        ),
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}

class Redirection {
  bool shouldShowOnboarding = false;

  bool shouldShowQagDetails = false;
  String? qagId;

  bool shouldShowConsultationDetails = false;
  String? consultationId;

  void showOnboarding() {
    shouldShowOnboarding = true;
  }

  void showQagDetails(String id) {
    shouldShowQagDetails = true;
    qagId = id;
  }

  void showConsultationDetails(String id) {
    shouldShowConsultationDetails = true;
    consultationId = id;
  }
}
