import 'package:agora/design/agora_colors.dart';
import 'package:agora/pages/loading_page.dart';
import 'package:flutter/material.dart';

class AgoraApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Agora",
      theme: ThemeData(
        colorScheme: ColorScheme.light(
          primary: AgoraColors.primaryGreen,
          secondary: AgoraColors.primaryGreen,
        ),
      ),
      home: LoadingPage(),
    );
  }
}
