import 'package:agora/infrastructure/login/login_storage_client.dart';

class FakeLoginStorageClient extends LoginStorageClient {
  String? loginToken;

  @override
  void save(String loginToken) async {
    this.loginToken = loginToken;
  }

  @override
  Future<String?> getLoginToken() async {
    return loginToken;
  }
}
