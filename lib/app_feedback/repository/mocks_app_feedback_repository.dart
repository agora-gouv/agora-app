import 'package:agora/app_feedback/repository/app_feedback_repository.dart';

class MockAppFeedbackRepository extends AppFeedbackDioRepository {
  MockAppFeedbackRepository({required super.httpClient, super.sentryWrapper});
}
