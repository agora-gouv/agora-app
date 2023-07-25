import 'package:agora/common/client/agora_dio_exception.dart';
import 'package:agora/common/helper/crashlytics_helper.dart';

class FakeCrashlyticsHelper extends CrashlyticsHelper {
  @override
  void recordError(
    dynamic exception,
    StackTrace? stack,
    AgoraDioExceptionType? exceptionType, {
    String? reason,
    Iterable<Object> information = const [],
    bool? printDetails,
    bool fatal = false,
  }) {}
}
