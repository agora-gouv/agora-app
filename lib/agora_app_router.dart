import 'package:agora/pages/consultation/consultations_page.dart';
import 'package:agora/pages/consultation/details/consultation_details_page.dart';
import 'package:agora/pages/consultation/question/consultation_question_confirmation_page.dart';
import 'package:agora/pages/consultation/question/consultation_question_page.dart';
import 'package:agora/pages/consultation/summary/consultation_summary_page.dart';
import 'package:agora/pages/demographic/demographic_confirmation_page.dart';
import 'package:agora/pages/demographic/demographic_information_page.dart';
import 'package:agora/pages/demographic/demographic_profile_page.dart';
import 'package:agora/pages/demographic/demographic_question_page.dart';
import 'package:agora/pages/loading_page.dart';
import 'package:agora/pages/main_bottom_navigation_page.dart';
import 'package:agora/pages/profile/legal_notice_page.dart';
import 'package:agora/pages/profile/moderation_charter_page.dart';
import 'package:agora/pages/profile/privacy_policy_page.dart';
import 'package:agora/pages/profile/profile_page.dart';
import 'package:agora/pages/profile/terms_of_condition_page.dart';
import 'package:agora/pages/qag/ask_question/qag_ask_question_confirmation_page.dart';
import 'package:agora/pages/qag/ask_question/qag_ask_question_page.dart';
import 'package:agora/pages/qag/details/qag_details_page.dart';
import 'package:agora/pages/qag/paginated/qags_paginated_page.dart';
import 'package:agora/pages/qag/qags_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AgoraAppRouter {
  static Map<String, WidgetBuilder> handleAgoraRoutes() {
    return {
      // Consultation
      ConsultationsPage.routeName: (context) =>
          MainBottomNavigationPage(startPage: MainBottomNavigationPages.consultation),
      ConsultationDetailsPage.routeName: (context) => ConsultationDetailsPage(),
      ConsultationQuestionPage.routeName: (context) => ConsultationQuestionPage(),
      ConsultationSummaryPage.routeName: (context) => ConsultationSummaryPage(),
      // Question au gouvernement
      QagsPage.routeName: (context) => MainBottomNavigationPage(startPage: MainBottomNavigationPages.qag),
      QagDetailsPage.routeName: (context) => QagDetailsPage(),
      QagAskQuestionPage.routeName: (context) => QagAskQuestionPage(),
      QagAskQuestionConfirmationPage.routeName: (context) => QagAskQuestionConfirmationPage(),
      // Profile
      ProfilePage.routeName: (context) => ProfilePage(),
      ModerationCharterPage.routeName: (context) => ModerationCharterPage(),
      PrivacyPolicyPage.routeName: (context) => PrivacyPolicyPage(),
      TermsOfConditionPage.routeName: (context) => TermsOfConditionPage(),
      LegalNoticePage.routeName: (context) => LegalNoticePage(),
      // Demographique
      DemographicInformationPage.routeName: (context) => DemographicInformationPage(),
      DemographicQuestionPage.routeName: (context) => DemographicQuestionPage(),
      DemographicProfilePage.routeName: (context) => DemographicProfilePage(),
    };
  }

  static MaterialPageRoute<dynamic> handleAgoraGenerateRoute(RouteSettings settings, SharedPreferences sharedPref) {
    Widget currentRoute;
    switch (settings.name) {
      case LoadingPage.routeName:
        currentRoute = LoadingPage(sharedPref: sharedPref);
        break;
      case ConsultationQuestionConfirmationPage.routeName:
        final arguments = settings.arguments as ConsultationQuestionConfirmationArguments;
        currentRoute = BlocProvider.value(
          value: arguments.consultationQuestionsResponsesBloc,
          child: ConsultationQuestionConfirmationPage(consultationId: arguments.consultationId),
        );
        break;
      case DemographicConfirmationPage.routeName:
        final arguments = settings.arguments as DemographicConfirmationArguments;
        currentRoute = BlocProvider.value(
          value: arguments.demographicResponsesStockBloc,
          child: DemographicConfirmationPage(consultationId: arguments.consultationId),
        );
        break;
      case QagsPaginatedPage.routeName:
        final arguments = settings.arguments as QagsPaginatedArguments;
        currentRoute = QagsPaginatedPage(thematiqueId: arguments.thematiqueId, initialTab: arguments.initialTab);
        break;
      default:
        throw Exception("Route doesn't exist: ${settings.name}");
    }
    return MaterialPageRoute(builder: (_) => currentRoute);
  }
}
