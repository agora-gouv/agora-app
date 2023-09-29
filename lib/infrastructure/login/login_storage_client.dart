import 'package:agora/common/storage/secure_storage_client.dart';

abstract class LoginStorageClient {
  final SecureStorageClient secureStorageClient;

  LoginStorageClient({required this.secureStorageClient});

  void save({required String userId, required String loginToken});

  Future<String?> getUserId();

  Future<String?> getLoginToken();
}

class LoginSharedPreferencesClient extends LoginStorageClient {
  final userIdKey = "userIdKey";
  final loginTokenKey = "loginTokenKey";

  LoginSharedPreferencesClient({required super.secureStorageClient});

  @override
  void save({required String userId, required String loginToken}) async {
    await secureStorageClient.write(key: userIdKey, value: userId);
    await secureStorageClient.write(key: loginTokenKey, value: loginToken);
  }

  @override
  Future<String?> getUserId() async {
    return await secureStorageClient.read(key: userIdKey);
  }

  @override
  Future<String?> getLoginToken() async {
    return await secureStorageClient.read(key: loginTokenKey);
  }
}
