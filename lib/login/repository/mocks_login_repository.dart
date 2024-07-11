import 'package:agora/login/repository/login_repository.dart';

class MockLoginRepository extends LoginDioRepository {
  MockLoginRepository({required super.httpClient, required super.sentryWrapper});
}
