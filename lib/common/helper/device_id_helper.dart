import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';

abstract class DeviceIdHelper {
  Future<String?> get();
}

class UniqueDeviceIdHelper extends DeviceIdHelper {
  @override
  Future<String?> get() async {
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
}
