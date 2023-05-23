import 'package:agora/common/helper/permission_helper.dart';

class FakeNotificationIsDeniedHelper extends PermissionHelper {
  @override
  Future<bool> isDenied() async {
    return true;
  }

  @override
  Future<bool> isPermanentlyDenied() async {
    return false;
  }
}

class FakeNotificationIsPermanentlyDeniedHelper extends PermissionHelper {
  @override
  Future<bool> isDenied() async {
    return false;
  }

  @override
  Future<bool> isPermanentlyDenied() async {
    return true;
  }
}
