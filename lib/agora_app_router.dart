import 'package:agora/pages/consultation/consultations_page.dart';
import 'package:agora/pages/consultation/details/consultation_details_page.dart';
import 'package:agora/pages/consultation/question/consultation_question_confirmation_page.dart';
import 'package:agora/pages/consultation/question/consultation_question_page.dart';
import 'package:agora/pages/consultation/summary/consultation_summary_page.dart';
import 'package:agora/pages/loading_page.dart';
import 'package:agora/pages/main_bottom_navigation_page.dart';
import 'package:agora/pages/qag/ask_question/qag_ask_question_page.dart';
import 'package:agora/pages/qag/details/qag_details_page.dart';
import 'package:agora/pages/qag/qags_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AgoraAppRouter {
  static Map<String, WidgetBuilder> handleAgoraRoutes() {
    return {
      LoadingPage.routeName: (context) => LoadingPage(),
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
    };
  }

  static MaterialPageRoute<dynamic> handleAgoraGenerateRoute(RouteSettings settings) {
    Widget currentRoute;
    switch (settings.name) {
      case ConsultationQuestionConfirmationPage.routeName:
        final arguments = settings.arguments as ConsultationQuestionConfirmationArguments;
        currentRoute = BlocProvider.value(
          value: arguments.consultationQuestionsResponsesBloc,
          child: ConsultationQuestionConfirmationPage(consultationId: arguments.consultationId),
        );
        break;
      default:
        throw Exception("Route doesn't exist: ${settings.name}");
    }
    return MaterialPageRoute(builder: (_) => currentRoute);
  }
}
