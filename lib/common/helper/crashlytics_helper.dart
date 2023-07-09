import 'package:agora/common/client/agora_dio_exception.dart';
import 'package:dio/dio.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';

abstract class CrashlyticsHelper {
  void recordError(
    dynamic exception,
    StackTrace? stack,
    AgoraDioExceptionType exceptionType, {
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
    StackTrace? stack,
    AgoraDioExceptionType exceptionType, {
    Iterable<Object> information = const [],
    bool? printDetails,
    bool fatal = false,
  }) {
    crashlytics.recordError(
      exception is DioException ? exception.toAgoraDioException(exceptionType) : exception,
      stack,
      reason: "$exceptionType failed",
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
    StackTrace? stack,
    AgoraDioExceptionType exceptionType, {
    Iterable<Object> information = const [],
    bool? printDetails,
    bool fatal = false,
  }) {
    // do nothing
  }
}
