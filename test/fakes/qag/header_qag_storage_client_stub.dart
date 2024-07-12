import 'package:agora/qag/repository/header_qag_repository.dart';

class HeaderQagStorageClientNoClosedStub extends HeaderQagStorageClient {
  @override
  Future<bool> isHeaderClosed({required String headerId}) async {
    return false;
  }

  @override
  Future<void> closeHeader({required String headerId}) async {
    return;
  }
}

class HeaderQagStorageClientAllClosedStub extends HeaderQagStorageClient {
  @override
  Future<bool> isHeaderClosed({required String headerId}) async {
    return true;
  }

  @override
  Future<void> closeHeader({required String headerId}) async {
    return;
  }
}
