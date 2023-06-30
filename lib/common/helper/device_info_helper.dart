import 'package:agora/common/helper/platform_helper.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';

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
    if (!kIsWeb) {
      final iosInfo = await deviceInfo.iosInfo;
      if (iosInfo.model != null) {
        return iosInfo.model!.toLowerCase().contains('ipad');
      }
    }
    return false;
  }
}
