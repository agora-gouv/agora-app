import 'package:agora/common/helper/app_version_helper.dart';

class FakeAppVersionHelper extends AppVersionHelper {
  @override
  Future<String> getBuildNumber() async {
    return "1.0.0";
  }

  @override
  Future<String> getVersion() async {
    return "10";
  }

  @override
  Future<String> getAndroidVersion() async {
    return "12";
  }

  @override
  Future<String> getIosVersion() async {
    return "12";
  }
}
