import 'package:agora/common/helper/device_info_helper.dart';

class FakeDeviceInfoHelper extends DeviceInfoHelper {
  @override
  Future<int> getAndroidSdk() async {
    return 33;
  }

  @override
  Future<bool> isIpad() async {
    return false;
  }
}

class FakeAndroidSdkBelow33Helper extends FakeDeviceInfoHelper {
  @override
  Future<int> getAndroidSdk() async {
    return 32;
  }
}
