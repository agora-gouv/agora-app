import 'package:agora/common/storage/first_connection_storage_client.dart';

class FakeFirstConnectionStorageClient extends FirstConnectionStorageClient {
  late bool isFirstConnectionStorage;

  @override
  void save(bool isFirstConnection) async {
    isFirstConnectionStorage = isFirstConnection;
  }

  @override
  Future<bool> isFirstConnection() async {
    return isFirstConnectionStorage;
  }
}
