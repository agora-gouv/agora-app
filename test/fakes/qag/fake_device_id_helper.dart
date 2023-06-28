import 'package:agora/common/helper/device_info_helper.dart';

class FakeDeviceInfoHelper extends DeviceInfoHelper {
  @override
  Future<String?> getDeviceId() async {
    return "deviceId";
  }

  @override
  Future<int> getAndroidSdk() async {
    return 33;
  }

  @override
  Future<bool> isIpad() async {
    return false;
  }
}

class FakeDeviceIdNullHelper extends FakeDeviceInfoHelper {
  @override
  Future<String?> getDeviceId() async {
    return null;
  }
}

class FakeAndroidSdkBelow33Helper extends FakeDeviceInfoHelper {
  @override
  Future<int> getAndroidSdk() async {
    return 32;
  }
}
