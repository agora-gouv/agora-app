import 'package:agora/infrastructure/login/login_repository.dart';

class MockLoginRepository extends LoginDioRepository {
  MockLoginRepository({required super.httpClient, required super.crashlyticsHelper});
}
