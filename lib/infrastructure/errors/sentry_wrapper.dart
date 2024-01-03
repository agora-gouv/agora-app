import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:logger/logger.dart';

class SentryWrapper {
  
  final _logger = Logger();
  
  void captureException(dynamic e, StackTrace stackTrace, {String? message}) {
    _logger.e(message ?? e.runtimeType.toString(), error: e, stackTrace: stackTrace);
    Sentry.captureException(
      e,
      stackTrace: stackTrace,
    );
  }
}
