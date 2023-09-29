import 'package:permission_handler/permission_handler.dart';

/// see https://pub.dev/packages/permission_handler
abstract class PermissionHelper {
  Future<bool> isDenied();

  Future<bool> isPermanentlyDenied();
}

class PermissionImplHelper extends PermissionHelper {
  final permission = Permission.notification;

  @override
  Future<bool> isDenied() async {
    return await permission.isDenied;
  }

  @override
  Future<bool> isPermanentlyDenied() async {
    return await permission.isPermanentlyDenied;
  }
}

class NotImportantPermissionImplHelper extends PermissionHelper {
  @override
  Future<bool> isDenied() async {
    return false;
  }

  @override
  Future<bool> isPermanentlyDenied() async {
    return false;
  }
}
