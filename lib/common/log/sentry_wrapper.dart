import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:logger/logger.dart';

class SentryWrapper {
  final _logger = Logger();

  void captureException(dynamic exception, StackTrace stackTrace, {String? message}) {
    _logger.e(message ?? exception.runtimeType.toString(), error: exception, stackTrace: stackTrace);
    Sentry.captureException(
      exception,
      stackTrace: stackTrace,
    );
  }
}
