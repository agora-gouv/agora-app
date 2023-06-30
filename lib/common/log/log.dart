import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';

class Log {
  static final _simpleLogger = Logger(filter: CustomLogFilter(), printer: SimplePrinter());
  static final _prettyLogger = Logger(filter: CustomLogFilter(), printer: PrettyPrinter(methodCount: 8));

  /// Log a message at level [Level.debug].
  static void d(String message, [dynamic error, StackTrace? stackTrace]) {
    if (!kIsWeb) {
      _simpleLogger.d(message, error, stackTrace);
    }
  }

  /// Log a message at level [Level.error].
  static void e(String message, [dynamic error, StackTrace? stackTrace]) {
    if (!kIsWeb) {
      _prettyLogger.e(message, error, stackTrace);
    }
  }
}

class CustomLogFilter extends LogFilter {
  @override
  bool shouldLog(LogEvent event) {
    if (kIsWeb) {
      return false;
    } else {
      final flutterTest = Platform.environment.containsKey('FLUTTER_TEST');
      return kDebugMode && !flutterTest;
    }
  }
}
