import 'package:agora/common/helper/device_info_helper.dart';
import 'package:agora/domain/feedback/device_informations.dart';

class FakeDeviceInfoHelper extends DeviceInfoHelper {
  @override
  Future<int> getAndroidSdk() async {
    return 33;
  }

  @override
  Future<bool> isIpad() async {
    return false;
  }

  @override
  Future<DeviceInformations> getDeviceInformations() async {
    return DeviceInformations(appVersion: 'appVersion', model: 'model', osVersion: 'osVersion');
  }
}

class FakeAndroidSdkBelow33Helper extends FakeDeviceInfoHelper {
  @override
  Future<int> getAndroidSdk() async {
    return 32;
  }
}
