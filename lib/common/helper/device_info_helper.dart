import 'package:agora/common/helper/platform_helper.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';

/// see https://pub.dev/packages/device_info_plus
abstract class DeviceInfoHelper {
  Future<int> getAndroidSdk();

  Future<bool> isIpad();
}

class DeviceInfoPluginHelper extends DeviceInfoHelper {
  final deviceInfo = DeviceInfoPlugin();

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
}
