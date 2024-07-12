import 'package:agora/profil/notification/repository/notification_repository.dart';

class MockNotificationRepository extends NotificationDioRepository {
  MockNotificationRepository({required super.httpClient, required super.sentryWrapper});
}
