import 'package:agora/common/helper/app_version_helper.dart';
import 'package:agora/common/helper/platform_helper.dart';
import 'package:agora/domain/feedback/device_informations.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';

/// see https://pub.dev/packages/device_info_plus
abstract class DeviceInfoHelper {
  Future<int> getAndroidSdk();

  Future<bool> isIpad();

  Future<DeviceInformation> getDeviceInformations();

  Future<String> getDeviceSystemData();
}

class DeviceInfoPluginHelper extends DeviceInfoHelper {
  final DeviceInfoPlugin deviceInfo;
  final AppVersionHelper appVersionHelper;

  DeviceInfoPluginHelper({
    required this.deviceInfo,
    required this.appVersionHelper,
  });

  @override
  Future<int> getAndroidSdk() async {
    if (PlatformStaticHelper.isAndroid()) {
      final androidDeviceInfo = await deviceInfo.androidInfo;
      return androidDeviceInfo.version.sdkInt;
    } else {
      throw Exception("Platform not support");
    }
  }

  @override
  Future<bool> isIpad() async {
    if (!kIsWeb && PlatformStaticHelper.isIOS()) {
      final iosInfo = await deviceInfo.iosInfo;
      return iosInfo.model.toLowerCase().contains('ipad');
    }
    return false;
  }

  @override
  Future<DeviceInformation> getDeviceInformations() async {
    if (PlatformStaticHelper.isAndroid()) {
      final androidDeviceInfo = await deviceInfo.androidInfo;
      return DeviceInformation(
        appVersion: await appVersionHelper.getVersion(),
        model: androidDeviceInfo.device,
        osVersion: 'Android ${androidDeviceInfo.version.release}',
      );
    } else {
      final iosInfo = await deviceInfo.iosInfo;
      return DeviceInformation(
        appVersion: await appVersionHelper.getVersion(),
        model: iosInfo.model,
        osVersion: 'iOS ${iosInfo.systemVersion}',
      );
    }
  }

  @override
  Future<String> getDeviceSystemData() async {
    if (kIsWeb) {
      final webInfo = await deviceInfo.webBrowserInfo;
      return "${webInfo.browserName.name} - ${webInfo.appVersion} (${webInfo.platform})";
    } else if (PlatformStaticHelper.isAndroid()) {
      final androidInfo = await deviceInfo.androidInfo;
      return "${androidInfo.brand} ${androidInfo.model} - Android ${androidInfo.version.sdkInt} (${androidInfo.version.incremental})";
    } else {
      final iosInfo = await deviceInfo.iosInfo;
      return "${iosInfo.utsname.machine} - ${iosInfo.systemName} ${iosInfo.systemVersion}";
    }
  }
}
