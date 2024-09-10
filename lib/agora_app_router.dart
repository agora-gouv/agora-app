import 'package:agora/common/analytics/analytics_screen_names.dart';
import 'package:agora/common/helper/deeplink_helper.dart';
import 'package:agora/consultation/dynamic/pages/dynamic_consultation_page.dart';
import 'package:agora/consultation/dynamic/pages/results/dynamic_consultation_results_page.dart';
import 'package:agora/consultation/dynamic/pages/updates/dynamic_consultation_update_page.dart';
import 'package:agora/consultation/finished_paginated/pages/consultation_finished_paginated_page.dart';
import 'package:agora/consultation/pages/consultations_page.dart';
import 'package:agora/consultation/question/pages/consultation_question_confirmation_page.dart';
import 'package:agora/consultation/question/pages/consultation_question_page.dart';
import 'package:agora/design/custom_view/agora_tracker.dart';
import 'package:agora/design/custom_view/bottom_navigation_bar/main_bottom_navigation_bar.dart';
import 'package:agora/profil/app_feedback/pages/app_feedback_page.dart';
import 'package:agora/profil/demographic/pages/demographic_confirmation_page.dart';
import 'package:agora/profil/demographic/pages/demographic_information_page.dart';
import 'package:agora/profil/demographic/pages/demographic_profil_page.dart';
import 'package:agora/profil/demographic/pages/demographic_question_page.dart';
import 'package:agora/profil/notification/pages/notification_page.dart';
import 'package:agora/profil/onboarding/pages/onboarding_page.dart';
import 'package:agora/profil/pages/delete_account_page.dart';
import 'package:agora/profil/pages/profil_information_page.dart';
import 'package:agora/profil/pages/profil_page.dart';
import 'package:agora/profil/participation_charter/pages/participation_charter_page.dart';
import 'package:agora/qag/ask/pages/ask_question_qag_search.dart';
import 'package:agora/qag/ask/pages/qag_ask_question_page.dart';
import 'package:agora/qag/details/pages/qag_details_delete_confirmation_page.dart';
import 'package:agora/qag/details/pages/qag_details_page.dart';
import 'package:agora/qag/moderation/pages/moderation_page.dart';
import 'package:agora/qag/pages/qags_page.dart';
import 'package:agora/reponse/pages/reponses_page.dart';
import 'package:agora/splash_page.dart';
import 'package:agora/webview/webview_page.dart';
import 'package:agora/welcome/pages/welcome_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AgoraAppRouter {
  static MaterialPageRoute<dynamic> handleAgoraGenerateRoute({
    required RouteSettings settings,
    required SharedPreferences sharedPref,
    required void Function(BuildContext) onRedirect,
    required DeeplinkHelper deepLinkHelper,
    required String agoraAppIcon,
  }) {
    Widget currentPage;
    switch (settings.name) {
      case SplashPage.routeName:
        currentPage = SplashPage(
          sharedPref: sharedPref,
          deepLinkHelper: deepLinkHelper,
          onRedirect: onRedirect,
          agoraAppIcon: agoraAppIcon,
        );
        break;
      case OnboardingPage.routeName:
        currentPage = AgoraTracker(widgetName: AnalyticsScreenNames.onboardingPage, child: OnboardingPage());
        break;
      // Consultation
      case ConsultationsPage.routeName:
        currentPage = MainBottomNavigationBar(startPage: NavigationPage.consultation);
        break;
      case DynamicConsultationPage.routeName:
        final arguments = settings.arguments as DynamicConsultationPageArguments;
        currentPage = AgoraTracker(
          widgetName: "${AnalyticsScreenNames.consultationDetailsPage} ${arguments.consultationIdOrSlug}",
          child: DynamicConsultationPage(arguments),
        );
        break;
      case DynamicConsultationResultsPage.routeName:
        final id = settings.arguments as String;
        currentPage = AgoraTracker(
          widgetName: "${AnalyticsScreenNames.consultationDetailsPage} $id",
          child: DynamicConsultationResultsPage(id),
        );
        break;
      case QagsPage.routeName:
        currentPage = MainBottomNavigationBar(startPage: NavigationPage.qag);
        break;
      case DynamicConsultationUpdatePage.routeName:
        final argument = settings.arguments as DynamicConsultationUpdateArguments;
        currentPage = AgoraTracker(
          widgetName: "${AnalyticsScreenNames.consultationDetailsPage} ${argument.updateId}",
          child: DynamicConsultationUpdatePage(argument),
        );
        break;
      case ConsultationQuestionPage.routeName:
        final arguments = settings.arguments as ConsultationQuestionArguments;
        currentPage = AgoraTracker(
          widgetName: "${AnalyticsScreenNames.consultationQuestionPage} ${arguments.consultationId}",
          child: ConsultationQuestionPage(arguments: arguments),
        );
        break;
      case AppFeedbackPage.routeName:
        currentPage = AgoraTracker(
          widgetName: AnalyticsScreenNames.appFeedbackPage,
          child: AppFeedbackPage(),
        );
        break;
      case ConsultationFinishedPaginatedPage.routeName:
        final arguments = settings.arguments as ConsultationPaginatedPageType;
        currentPage = AgoraTracker(
          widgetName: AnalyticsScreenNames.consultationsFinishedPaginatedPage,
          child: ConsultationFinishedPaginatedPage(arguments),
        );
        break;
      case ConsultationQuestionConfirmationPage.routeName:
        final arguments = settings.arguments as ConsultationQuestionConfirmationArguments;
        currentPage = BlocProvider.value(
          value: arguments.consultationQuestionsResponsesBloc,
          child: AgoraTracker(
            widgetName: AnalyticsScreenNames.consultationQuestionConfirmationPage,
            child: ConsultationQuestionConfirmationPage(
              consultationId: arguments.consultationId,
              consultationTitle: arguments.consultationTitle,
            ),
          ),
        );
        break;
      // Qag
      case QagDetailsPage.routeName:
        currentPage = AgoraTracker(
          widgetName: AnalyticsScreenNames.qagDetailsPage,
          child: QagDetailsPage(arguments: settings.arguments as QagDetailsArguments),
        );
        break;
      case QagDetailsDeleteConfirmationPage.routeName:
        final arguments = settings.arguments as QagDetailsDeleteConfirmationArguments;
        currentPage = AgoraTracker(
          widgetName: AnalyticsScreenNames.qagDetailsDeletePage,
          child: QagDetailsDeleteConfirmationPage(arguments: arguments),
        );
        break;
      case QagAskQuestionPage.routeName:
        currentPage = AgoraTracker(
          widgetName: AnalyticsScreenNames.qagAskQuestionPage,
          child: QagAskQuestionPage(),
        );
      case SearchPageFromAskQuestionPage.routeName:
        currentPage = AgoraTracker(
          widgetName: AnalyticsScreenNames.qagsSearchFromAskPage,
          child: SearchPageFromAskQuestionPage(),
        );
        break;
      case DemographicConfirmationPage.routeName:
        final arguments = settings.arguments as DemographicConfirmationArguments;
        currentPage = BlocProvider.value(
          value: arguments.demographicResponsesStockBloc,
          child: AgoraTracker(
            widgetName: AnalyticsScreenNames.demographicConfirmationPage,
            child: DemographicConfirmationPage(
              consultationId: arguments.consultationId,
              consultationTitle: arguments.consultationTitle,
            ),
          ),
        );
        break;
      case ReponsesPage.routeName:
        currentPage = MainBottomNavigationBar(startPage: NavigationPage.reponse);
        break;
      case ProfilPage.routeName:
        currentPage = MainBottomNavigationBar(startPage: NavigationPage.profil);
        break;
      case ModerationPage.routeName:
        currentPage = AgoraTracker(
          widgetName: AnalyticsScreenNames.moderationPage,
          child: ModerationPage(),
        );
        break;
      case NotificationPage.routeName:
        currentPage = AgoraTracker(
          widgetName: AnalyticsScreenNames.notificationPage,
          child: NotificationPage(),
        );
        break;
      case DeleteAccountPage.routeName:
        currentPage = AgoraTracker(
          widgetName: AnalyticsScreenNames.deleteAccountPage,
          child: DeleteAccountPage(),
        );
        break;
      case ParticipationCharterPage.routeName:
        currentPage = AgoraTracker(
          widgetName: AnalyticsScreenNames.participationCharterPage,
          child: ParticipationCharterPage(),
        );
        break;
      case ProfilInformationsPage.routeName:
        currentPage = AgoraTracker(
          widgetName: AnalyticsScreenNames.profileDemographicInformationPage,
          child: ProfilInformationsPage(),
        );
        break;
      case DemographicInformationPage.routeName:
        currentPage = AgoraTracker(
          widgetName: AnalyticsScreenNames.demographicInformationPage,
          child: DemographicInformationPage(),
        );
        break;
      case DemographicQuestionPage.routeName:
        currentPage = AgoraTracker(
          widgetName: AnalyticsScreenNames.demographicQuestionPage,
          child: DemographicQuestionPage(),
        );
        break;
      case DemographicProfilPage.routeName:
        currentPage = AgoraTracker(
          widgetName: AnalyticsScreenNames.demographicProfilePage,
          child: DemographicProfilPage(),
        );
        break;
      case WebviewPage.routeName:
        currentPage = AgoraTracker(
          widgetName: AnalyticsScreenNames.webviewPage,
          child: WebviewPage(),
        );
        break;
      case WelcomePage.routeName:
        currentPage = AgoraTracker(
          widgetName: AnalyticsScreenNames.welcomePage,
          child: WelcomePage(),
        );
        break;
      default:
        throw Exception("Route doesn't exist: ${settings.name}");
    }
    return MaterialPageRoute(
      settings: RouteSettings(name: settings.name),
      builder: (_) => currentPage,
    );
  }
}
