import 'package:agora/bloc/thematique/thematique_bloc.dart';
import 'package:agora/pages/consultation/consultation_details_page.dart';
import 'package:agora/pages/loading_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AgoraAppRouter {
  static MaterialPageRoute<dynamic> handleAgoraRoute(RouteSettings settings) {
    switch (settings.name) {
      case LoadingPage.routeName:
        return MaterialPageRoute(builder: (_) => LoadingPage());
      case ConsultationDetailsPage.routeName:
        return MaterialPageRoute(
          builder: (_) => BlocProvider.value(
            value: settings.arguments as ThematiqueBloc,
            child: ConsultationDetailsPage(),
          ),
        );
      default:
        throw Exception("Route doesn't exist: ${settings.name}");
    }
  }
}
