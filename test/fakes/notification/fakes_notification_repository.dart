import 'package:agora/profil/notification/domain/notification.dart';
import 'package:agora/profil/notification/domain/notification_information.dart';
import 'package:agora/profil/notification/repository/notification_repository.dart';

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
            description: "description de la notification",
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
