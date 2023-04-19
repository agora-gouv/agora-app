import 'package:agora/common/helper/device_id_helper.dart';

class FakeDeviceIdHelper extends DeviceIdHelper {
  @override
  Future<String?> get() async {
    return "deviceId";
  }
}

class FakeDeviceIdNullHelper extends DeviceIdHelper {
  @override
  Future<String?> get() async {
    return null;
  }
}
