import 'package:agora/domain/notification/notification.dart';
import 'package:agora/infrastructure/notification/notification_repository.dart';

class MockNotificationRepository extends NotificationDioRepository {
  MockNotificationRepository({required super.httpClient, required super.crashlyticsHelper});

  @override
  Future<GetNotificationsRepositoryResponse> getNotifications({
    required int pageNumber,
  }) async {
    return GetNotificationsSucceedResponse(
      notificationInformation: NotificationInformation(
        hasMoreNotifications: true,
        notifications: [
          Notification(
            title: "$pageNumber - titre de la notification",
            type: "Consultations",
            date: DateTime(2023, 7, 27),
          ),
        ],
      ),
    );
  }
}
