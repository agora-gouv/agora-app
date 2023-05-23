import 'package:agora/common/storage/secure_storage_client.dart';

class FakeSecureStorageClient extends SecureStorageClient {
  final Map<String, String> fakeStorage = {};

  @override
  Future<void> write({required String key, required String value}) async {
    fakeStorage[key] = value;
  }

  @override
  Future<String?> read({required String key}) async {
    return fakeStorage[key];
  }

  @override
  Future<void> delete({required String key}) async {
    fakeStorage.remove(key);
  }
}
