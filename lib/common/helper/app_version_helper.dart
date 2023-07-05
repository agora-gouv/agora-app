import 'package:package_info_plus/package_info_plus.dart';

abstract class AppVersionHelper {
  Future<String> getVersion();
  Future<String> getBuildNumber();
}

class AppVersionHelperImpl extends AppVersionHelper {
  @override
  Future<String> getVersion() async {
    final packageInfo = await PackageInfo.fromPlatform();
    return packageInfo.version;
  }

  @override
  Future<String> getBuildNumber() async {
    final packageInfo = await PackageInfo.fromPlatform();
    return packageInfo.buildNumber;
  }
}
