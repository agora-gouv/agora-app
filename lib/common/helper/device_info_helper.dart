import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';

abstract class DeviceInfoHelper {
  Future<String?> getDeviceId();

  Future<int> getAndroidSdk();
}

class DeviceInfoPluginHelper extends DeviceInfoHelper {
  @override
  Future<String?> getDeviceId() async {
    final deviceInfo = DeviceInfoPlugin();
    if (Platform.isIOS) {
      final iosDeviceInfo = await deviceInfo.iosInfo;
      return iosDeviceInfo.identifierForVendor; // unique ID on iOS
    } else if (Platform.isAndroid) {
      final androidDeviceInfo = await deviceInfo.androidInfo;
      return androidDeviceInfo.id; // unique ID on Android
    } else {
      throw Exception("Platform not support");
    }
  }

  @override
  Future<int> getAndroidSdk() async {
    final deviceInfo = DeviceInfoPlugin();
    if (Platform.isAndroid) {
      final androidDeviceInfo = await deviceInfo.androidInfo;
      return androidDeviceInfo.version.sdkInt;
    } else {
      throw Exception("Platform not support");
    }
  }
}
