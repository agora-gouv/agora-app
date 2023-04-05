import 'package:agora/bloc/thematique/thematique_bloc.dart';
import 'package:agora/pages/consultation/consultation_details_page.dart';
import 'package:agora/pages/loading_page.dart';
import 'package:agora/pages/question/question_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AgoraAppRouter {
  static Map<String, WidgetBuilder> handleAgoraRoute() {
    return {
      LoadingPage.routeName: (context) => LoadingPage(),
      QuestionPage.routeName: (context) => QuestionPage(),
    };
  }

  static MaterialPageRoute<dynamic> handleAgoraGenerateRoute(RouteSettings settings) {
    Widget currentRoute;
    switch (settings.name) {
      case ConsultationDetailsPage.routeName:
        currentRoute = BlocProvider.value(
          value: settings.arguments as ThematiqueBloc,
          child: ConsultationDetailsPage(),
        );
        break;
      default:
        throw Exception("Route doesn't exist: ${settings.name}");
    }
    return MaterialPageRoute(builder: (_) => currentRoute);
  }
}
