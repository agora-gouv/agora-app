import 'package:agora/agora_app.dart';
import 'package:agora/common/analytics/analytics_screen_names.dart';
import 'package:agora/design/custom_view/agora_tracker.dart';
import 'package:agora/pages/consultation/consultations_page.dart';
import 'package:agora/pages/consultation/details/consultation_details_page.dart';
import 'package:agora/pages/consultation/finished_paginated/consultation_finished_paginated_page.dart';
import 'package:agora/pages/consultation/question/consultation_question_confirmation_page.dart';
import 'package:agora/pages/consultation/question/consultation_question_page.dart';
import 'package:agora/pages/consultation/summary/consultation_summary_page.dart';
import 'package:agora/pages/demographic/demographic_confirmation_page.dart';
import 'package:agora/pages/demographic/demographic_information_page.dart';
import 'package:agora/pages/demographic/demographic_profile_page.dart';
import 'package:agora/pages/demographic/demographic_question_page.dart';
import 'package:agora/pages/loading_page.dart';
import 'package:agora/pages/main_bottom_navigation_page.dart';
import 'package:agora/pages/onboarding/onboarding_page.dart';
import 'package:agora/pages/profile/delete_account_page.dart';
import 'package:agora/pages/profile/legal_notice_page.dart';
import 'package:agora/pages/profile/notification_page.dart';
import 'package:agora/pages/profile/participation_charter_page.dart';
import 'package:agora/pages/profile/privacy_policy_page.dart';
import 'package:agora/pages/profile/profile_demographic_information_page.dart';
import 'package:agora/pages/profile/profile_page.dart';
import 'package:agora/pages/profile/terms_of_condition_page.dart';
import 'package:agora/pages/qag/ask_question/qag_ask_question_page.dart';
import 'package:agora/pages/qag/details/qag_details_page.dart';
import 'package:agora/pages/qag/moderation/moderation_page.dart';
import 'package:agora/pages/qag/paginated/qags_paginated_page.dart';
import 'package:agora/pages/qag/qags_page.dart';
import 'package:agora/pages/qag/response_paginated/qags_response_paginated_page.dart';
import 'package:agora/pages/qag/similar/qag_similar_page.dart';
import 'package:agora/pages/webview/webview_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AgoraAppRouter {
  static Map<String, WidgetBuilder> handleAgoraRoutes() {
    return {
      // Onboarding
      OnboardingPage.routeName: (context) => AgoraTracker(
            widgetName: AnalyticsScreenNames.onboardingPage,
            child: OnboardingPage(),
          ),
      // Consultation
      ConsultationsPage.routeName: (context) =>
          MainBottomNavigationPage(startPage: MainBottomNavigationPages.consultation),
      ConsultationFinishedPaginatedPage.routeName: (context) => AgoraTracker(
            widgetName: AnalyticsScreenNames.consultationsFinishedPaginatedPage,
            child: ConsultationFinishedPaginatedPage(),
          ),
      // Question au gouvernement
      QagsPage.routeName: (context) => MainBottomNavigationPage(startPage: MainBottomNavigationPages.qag),
      QagAskQuestionPage.routeName: (context) => AgoraTracker(
            widgetName: AnalyticsScreenNames.qagAskQuestionPage,
            child: QagAskQuestionPage(),
          ),
      QagSimilarPage.routeName: (context) => AgoraTracker(
            widgetName: AnalyticsScreenNames.qagSimilarPage,
            child: QagSimilarPage(),
          ),
      QagResponsePaginatedPage.routeName: (context) => AgoraTracker(
            widgetName: AnalyticsScreenNames.qagsResponsePaginatedPage,
            child: QagResponsePaginatedPage(),
          ),
      // Profile
      ProfilePage.routeName: (context) => AgoraTracker(
            widgetName: AnalyticsScreenNames.profilePage,
            child: ProfilePage(),
          ),
      ModerationPage.routeName: (context) => AgoraTracker(
            widgetName: AnalyticsScreenNames.moderationPage,
            child: ModerationPage(),
          ),
      NotificationPage.routeName: (context) => AgoraTracker(
            widgetName: AnalyticsScreenNames.notificationPage,
            child: NotificationPage(),
          ),
      DeleteAccountPage.routeName: (context) => AgoraTracker(
            widgetName: AnalyticsScreenNames.deleteAccountPage,
            child: DeleteAccountPage(),
          ),
      ParticipationCharterPage.routeName: (context) => AgoraTracker(
            widgetName: AnalyticsScreenNames.participationCharterPage,
            child: ParticipationCharterPage(),
          ),
      PrivacyPolicyPage.routeName: (context) => AgoraTracker(
            widgetName: AnalyticsScreenNames.privacyPolicyPage,
            child: PrivacyPolicyPage(),
          ),
      TermsOfConditionPage.routeName: (context) => AgoraTracker(
            widgetName: AnalyticsScreenNames.termsOfConditionPage,
            child: TermsOfConditionPage(),
          ),
      LegalNoticePage.routeName: (context) => AgoraTracker(
            widgetName: AnalyticsScreenNames.legalNoticePage,
            child: LegalNoticePage(),
          ),
      ProfileDemographicInformationPage.routeName: (context) => AgoraTracker(
            widgetName: AnalyticsScreenNames.profileDemographicInformationPage,
            child: ProfileDemographicInformationPage(),
          ),
      // Demographique
      DemographicInformationPage.routeName: (context) => AgoraTracker(
            widgetName: AnalyticsScreenNames.demographicInformationPage,
            child: DemographicInformationPage(),
          ),
      DemographicQuestionPage.routeName: (context) => AgoraTracker(
            widgetName: AnalyticsScreenNames.demographicQuestionPage,
            child: DemographicQuestionPage(),
          ),
      DemographicProfilePage.routeName: (context) => AgoraTracker(
            widgetName: AnalyticsScreenNames.demographicProfilePage,
            child: DemographicProfilePage(),
          ),
      // Webview
      WebviewPage.routeName: (context) => AgoraTracker(
            widgetName: AnalyticsScreenNames.webviewPage,
            child: WebviewPage(),
          ),
    };
  }

  static MaterialPageRoute<dynamic> handleAgoraGenerateRoute({
    required RouteSettings settings,
    required SharedPreferences sharedPref,
    required Redirection redirection,
  }) {
    Widget currentRoute;
    switch (settings.name) {
      case LoadingPage.routeName:
        currentRoute = LoadingPage(sharedPref: sharedPref, redirection: redirection);
        break;
      // Consultation
      case ConsultationDetailsPage.routeName:
        final arguments = settings.arguments as ConsultationDetailsArguments;
        currentRoute = AgoraTracker(
          widgetName: "${AnalyticsScreenNames.consultationDetailsPage} ${arguments.consultationId}",
          child: ConsultationDetailsPage(
            consultationId: arguments.consultationId,
            notificationTitle: arguments.notificationTitle,
            notificationDescription: arguments.notificationDescription,
          ),
        );
        break;
      case ConsultationQuestionPage.routeName:
        final consultationId = settings.arguments as String;
        currentRoute = AgoraTracker(
          widgetName: "${AnalyticsScreenNames.consultationQuestionPage} $consultationId",
          child: ConsultationQuestionPage(consultationId: consultationId),
        );
        break;
      case ConsultationQuestionConfirmationPage.routeName:
        final arguments = settings.arguments as ConsultationQuestionConfirmationArguments;
        currentRoute = BlocProvider.value(
          value: arguments.consultationQuestionsResponsesBloc,
          child: AgoraTracker(
            widgetName: AnalyticsScreenNames.consultationQuestionConfirmationPage,
            child: ConsultationQuestionConfirmationPage(consultationId: arguments.consultationId),
          ),
        );
        break;
      case ConsultationSummaryPage.routeName:
        final arguments = settings.arguments as ConsultationSummaryArguments;
        currentRoute = ConsultationSummaryPage(
          consultationId: arguments.consultationId,
          shouldReloadConsultationsWhenPop: arguments.shouldReloadConsultationsWhenPop,
          notificationTitle: arguments.notificationTitle,
          notificationDescription: arguments.notificationDescription,
        );
        break;

      // Qag
      case QagDetailsPage.routeName:
        final arguments = settings.arguments as QagDetailsArguments;
        currentRoute = AgoraTracker(
          widgetName: AnalyticsScreenNames.qagDetailsPage,
          child: QagDetailsPage(
            qagId: arguments.qagId,
            notificationTitle: arguments.notificationTitle,
            notificationDescription: arguments.notificationDescription,
          ),
        );
        break;
      case QagsPaginatedPage.routeName:
        final arguments = settings.arguments as QagsPaginatedArguments;
        currentRoute = QagsPaginatedPage(thematiqueId: arguments.thematiqueId, initialTab: arguments.initialTab);
        break;
      case DemographicConfirmationPage.routeName:
        final arguments = settings.arguments as DemographicConfirmationArguments;
        currentRoute = BlocProvider.value(
          value: arguments.demographicResponsesStockBloc,
          child: AgoraTracker(
            widgetName: AnalyticsScreenNames.demographicConfirmationPage,
            child: DemographicConfirmationPage(consultationId: arguments.consultationId),
          ),
        );
        break;
      default:
        throw Exception("Route doesn't exist: ${settings.name}");
    }
    return MaterialPageRoute(
      settings: RouteSettings(name: settings.name),
      builder: (_) => currentRoute,
    );
  }
}
