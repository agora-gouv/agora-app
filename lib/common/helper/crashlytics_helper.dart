import 'package:firebase_crashlytics/firebase_crashlytics.dart';

abstract class CrashlyticsHelper {
  void recordError(
    dynamic exception,
    StackTrace? stack, {
    String reason,
    Iterable<Object> information,
    bool? printDetails,
    bool fatal,
  });
}

class CrashlyticsHelperImpl extends CrashlyticsHelper {
  final FirebaseCrashlytics crashlytics;

  CrashlyticsHelperImpl(this.crashlytics);

  @override
  void recordError(
    dynamic exception,
    StackTrace? stack, {
    String reason = "",
    Iterable<Object> information = const [],
    bool? printDetails,
    bool fatal = false,
  }) {
    crashlytics.recordError(
      exception,
      stack,
      reason: reason,
      information: information,
      printDetails: printDetails,
      fatal: fatal,
    );
  }
}

class NotImportantCrashlyticsHelperImpl extends CrashlyticsHelper {
  @override
  void recordError(
    dynamic exception,
    StackTrace? stack, {
    String reason = "",
    Iterable<Object> information = const [],
    bool? printDetails,
    bool fatal = false,
  }) {
    // do nothing
  }
}
