import 'package:agora/domain/notification/notification.dart';
import 'package:agora/infrastructure/notification/notification_repository.dart';

class FakeNotificationSuccessRepository extends NotificationRepository {
  @override
  Future<GetNotificationsRepositoryResponse> getNotifications({
    required int pageNumber,
  }) async {
    return GetNotificationsSucceedResponse(
      notificationInformation: NotificationInformation(
        hasMoreNotifications: true,
        notifications: [
          Notification(
            title: "titre de la notification",
            type: "Consultations",
            date: DateTime(2023, 7, 27),
          ),
        ],
      ),
    );
  }
}

class FakeNotificationFailureRepository extends NotificationRepository {
  @override
  Future<GetNotificationsRepositoryResponse> getNotifications({
    required int pageNumber,
  }) async {
    return GetNotificationsFailureResponse();
  }
}
