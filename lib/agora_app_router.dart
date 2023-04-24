import 'package:agora/pages/consultation/consultation_details_page.dart';
import 'package:agora/pages/consultation/consultation_question_confirmation_page.dart';
import 'package:agora/pages/consultation/consultation_summary_page.dart';
import 'package:agora/pages/consultation/question/consultation_question_page.dart';
import 'package:agora/pages/loading_page.dart';
import 'package:agora/pages/qag/qag_ask_question_page.dart';
import 'package:agora/pages/qag/qag_details_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AgoraAppRouter {
  static Map<String, WidgetBuilder> handleAgoraRoutes() {
    return {
      LoadingPage.routeName: (context) => LoadingPage(),
      ConsultationQuestionPage.routeName: (context) => ConsultationQuestionPage(),
      ConsultationSummaryPage.routeName: (context) => ConsultationSummaryPage(),
      QagAskQuestionPage.routeName: (context) => QagAskQuestionPage(),
    };
  }

  static MaterialPageRoute<dynamic> handleAgoraGenerateRoute(RouteSettings settings) {
    Widget currentRoute;
    switch (settings.name) {
      case ConsultationDetailsPage.routeName:
        final arguments = settings.arguments as ConsultationDetailsArguments;
        currentRoute = BlocProvider.value(
          value: arguments.thematiqueBloc,
          child: ConsultationDetailsPage(consultationId: arguments.consultationId),
        );
        break;
      case ConsultationQuestionConfirmationPage.routeName:
        final arguments = settings.arguments as ConsultationQuestionConfirmationArguments;
        currentRoute = BlocProvider.value(
          value: arguments.consultationQuestionsResponsesBloc,
          child: ConsultationQuestionConfirmationPage(consultationId: arguments.consultationId),
        );
        break;
      case QagDetailsPage.routeName:
        final arguments = settings.arguments as QagDetailsArguments;
        currentRoute = BlocProvider.value(
          value: arguments.thematiqueBloc,
          child: QagDetailsPage(qagId: arguments.qagId),
        );
        break;
      default:
        throw Exception("Route doesn't exist: ${settings.name}");
    }
    return MaterialPageRoute(builder: (_) => currentRoute);
  }
}
