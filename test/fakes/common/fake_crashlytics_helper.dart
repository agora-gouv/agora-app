import 'package:agora/common/helper/crashlytics_helper.dart';

class FakeCrashlyticsHelper extends CrashlyticsHelper {
  @override
  void recordError(
    dynamic exception,
    StackTrace? stack, {
    dynamic reason,
    Iterable<Object> information = const [],
    bool? printDetails,
    bool fatal = false,
  }) {}
}
