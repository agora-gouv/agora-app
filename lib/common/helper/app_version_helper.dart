import 'package:device_info_plus/device_info_plus.dart';
import 'package:package_info_plus/package_info_plus.dart';

/// see https://pub.dev/packages/package_info_plus
abstract class AppVersionHelper {
  Future<String> getVersion();
  Future<String> getBuildNumber();
  Future<String> getAndroidVersion();
  Future<String> getIosVersion();
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

  @override
  Future<String> getAndroidVersion() async {
    final deviceInfo = await DeviceInfoPlugin().androidInfo;
    return deviceInfo.version.release;
  }

  @override
  Future<String> getIosVersion() async {
    final deviceInfo = await DeviceInfoPlugin().iosInfo;
    return deviceInfo.systemVersion == null ? "" : deviceInfo.systemVersion!;
  }
}
