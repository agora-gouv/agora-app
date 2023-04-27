import 'package:agora/infrastructure/login/login_storage_client.dart';

class FakeLoginStorageClient extends LoginStorageClient {
  String? userId;

  @override
  void save(String userId) async {
    this.userId = userId;
  }

  @override
  Future<String?> getUserId() async {
    return userId;
  }
}
