import 'package:agora/infrastructure/login/login_storage_client.dart';

import '../storage/fake_secure_storage_client.dart';

class FakeLoginStorageClient extends LoginStorageClient {
  String? userId;
  String? loginToken;

  FakeLoginStorageClient() : super(secureStorageClient: FakeSecureStorageClient());

  @override
  void save({required String userId, required String loginToken}) async {
    this.userId = userId;
    this.loginToken = loginToken;
  }

  @override
  Future<String?> getUserId() async {
    return userId;
  }

  @override
  Future<String?> getLoginToken() async {
    return loginToken;
  }
}
