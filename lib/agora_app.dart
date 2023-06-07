import 'package:agora/agora_app_router.dart';
import 'package:agora/common/helper/deeplink_helper.dart';
import 'package:agora/common/navigator/navigator_key.dart';
import 'package:agora/common/observer/matomo_route_observer.dart';
import 'package:agora/common/observer/navigation_observer.dart';
import 'package:agora/design/style/agora_colors.dart';
import 'package:agora/pages/consultation/details/consultation_details_page.dart';
import 'package:agora/pages/loading_page.dart';
import 'package:agora/pages/qag/details/qag_details_page.dart';
import 'package:flutter/material.dart';
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

class _AgoraAppState extends State<AgoraApp> {
  final deeplinkHelper = DeeplinkHelper();
  final redirection = Redirection();

  @override
  void initState() {
    super.initState();
    if (widget.shouldShowOnboarding) {
      redirection.showOnboarding();
    }
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

  @override
  void dispose() {
    deeplinkHelper.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Agora",
      initialRoute: LoadingPage.routeName,
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
