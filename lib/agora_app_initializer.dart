import 'package:agora/agora_app.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';

class AgoraInitializer {
  static void initializeApp() async {
    Intl.defaultLocale = "fr_FR";
    initializeDateFormatting('fr_FR', null);
    runApp(AgoraApp());
  }
}
