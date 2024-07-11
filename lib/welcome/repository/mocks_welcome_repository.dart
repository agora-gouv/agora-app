import 'package:agora/welcome/repository/welcome_repository.dart';

class MocksWelcomeRepository extends WelcomeDioRepository {
  MocksWelcomeRepository({required super.httpClient, required super.sentryWrapper});
}
