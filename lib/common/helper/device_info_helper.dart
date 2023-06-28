import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';

abstract class DeviceInfoHelper {
  Future<String?> getDeviceId();

  Future<int> getAndroidSdk();

  Future<bool> isIpad();
}

class DeviceInfoPluginHelper extends DeviceInfoHelper {
  final deviceInfo = DeviceInfoPlugin();

  @override
  Future<String?> getDeviceId() async {
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
    if (Platform.isAndroid) {
      final androidDeviceInfo = await deviceInfo.androidInfo;
      return androidDeviceInfo.version.sdkInt;
    } else {
      throw Exception("Platform not support");
    }
  }

  @override
  Future<bool> isIpad() async {
    final iosInfo = await deviceInfo.iosInfo;
    if (iosInfo.model != null) {
      return iosInfo.model!.toLowerCase().contains('ipad');
    } else {
      return false;
    }
  }
}
