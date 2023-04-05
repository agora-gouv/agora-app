import 'package:agora/agora_app_router.dart';
import 'package:agora/design/agora_colors.dart';
import 'package:agora/pages/loading_page.dart';
import 'package:flutter/material.dart';

class AgoraApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Agora",
      initialRoute: LoadingPage.routeName,
      onGenerateRoute: (RouteSettings settings) => AgoraAppRouter.handleAgoraRoute(settings),
      theme: ThemeData(
        colorScheme: ColorScheme.light(
          primary: AgoraColors.primaryGreen,
          secondary: AgoraColors.primaryGreen,
        ),
      ),
    );
  }
}
