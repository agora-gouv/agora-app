import 'package:agora/common/storage/secure_storage_client.dart';

abstract class LoginStorageClient {
  final SecureStorageClient secureStorageClient;

  LoginStorageClient({required this.secureStorageClient});

  void save(String loginToken);

  Future<String?> getLoginToken();
}

class LoginSharedPreferencesClient extends LoginStorageClient {
  final loginTokenKey = "loginTokenKey";

  LoginSharedPreferencesClient({required super.secureStorageClient});

  @override
  void save(String loginToken) async {
    await secureStorageClient.write(key: loginTokenKey, value: loginToken);
  }

  @override
  Future<String?> getLoginToken() async {
    return await secureStorageClient.read(key: loginTokenKey);
  }
}
