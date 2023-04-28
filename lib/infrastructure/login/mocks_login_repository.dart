import 'package:agora/infrastructure/login/login_repository.dart';

// TODO suppress when debouncing is done
class MockLoginSuccessRepository extends LoginDioRepository {
  MockLoginSuccessRepository({required super.httpClient});
}
