import 'package:agora/infrastructure/notification/permission/notification_first_request_permission_storage_client.dart';

class FakeNotificationFirstRequestPermissionStorageClient extends NotificationFirstRequestPermissionStorageClient {
  late bool isFirstConnectionStorage;

  @override
  void save(bool isFirstConnection) async {
    isFirstConnectionStorage = isFirstConnection;
  }

  @override
  Future<bool> isFirstRequest() async {
    return isFirstConnectionStorage;
  }
}
