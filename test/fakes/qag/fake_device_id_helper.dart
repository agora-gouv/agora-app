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
  Future<DeviceInformation> getDeviceInformations() async {
    return DeviceInformation(appVersion: 'appVersion', model: 'model', osVersion: 'osVersion');
  }

  @override
  Future<bool> isPhysicalDevice() async {
    return true;
  }

  @override
  Future<String> getDeviceSystemData() async {
    return "deviceData";
  }
}

class FakeAndroidSdkBelow33Helper extends FakeDeviceInfoHelper {
  @override
  Future<int> getAndroidSdk() async {
    return 32;
  }
}
