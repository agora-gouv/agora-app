import 'package:agora/common/helper/app_version_helper.dart';
import 'package:agora/common/helper/platform_helper.dart';
import 'package:agora/domain/feedback/device_informations.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';

/// see https://pub.dev/packages/device_info_plus
abstract class DeviceInfoHelper {
  Future<int> getAndroidSdk();

  Future<bool> isIpad();

  Future<DeviceInformations> getDeviceInformations();
}

class DeviceInfoPluginHelper extends DeviceInfoHelper {
  final DeviceInfoPlugin deviceInfo;
  final AppVersionHelper appVersionHelper;


  DeviceInfoPluginHelper({required this.deviceInfo, required this.appVersionHelper,});

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
  Future<DeviceInformations> getDeviceInformations() async {
    if (PlatformStaticHelper.isAndroid()) {
      final androidDeviceInfo = await deviceInfo.androidInfo;
      return DeviceInformations(
        appVersion: await appVersionHelper.getAndroidVersion(),
        model: androidDeviceInfo.device,
        osVersion: 'Android ${androidDeviceInfo.version.release}',
      );
    } else {
      final iosInfo = await deviceInfo.iosInfo;
      return DeviceInformations(
        appVersion: await appVersionHelper.getIosVersion(),
        model: iosInfo.model,
        osVersion: 'iOS ${iosInfo.systemVersion}',
      );
    }
  }
}
