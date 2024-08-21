import 'package:agora/profil/app_feedback/repository/app_feedback_repository.dart';

class MockAppFeedbackRepository extends AppFeedbackDioRepository {
  MockAppFeedbackRepository({required super.httpClient, required super.sentryWrapper});
}
