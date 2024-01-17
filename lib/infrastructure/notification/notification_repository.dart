import 'package:agora/common/client/agora_http_client.dart';
import 'package:agora/common/extension/date_extension.dart';
import 'package:agora/domain/notification/notification.dart';
import 'package:agora/infrastructure/errors/sentry_wrapper.dart';
import 'package:equatable/equatable.dart';

abstract class NotificationRepository {
  Future<GetNotificationsRepositoryResponse> getNotifications({
    required int pageNumber,
  });
}

class NotificationDioRepository extends NotificationRepository {
  final AgoraDioHttpClient httpClient;
  final SentryWrapper? sentryWrapper;

  NotificationDioRepository({required this.httpClient, this.sentryWrapper});

  @override
  Future<GetNotificationsRepositoryResponse> getNotifications({
    required int pageNumber,
  }) async {
    try {
      final response = await httpClient.get("/notifications/paginated/$pageNumber");
      return GetNotificationsSucceedResponse(
        notificationInformation: NotificationInformation(
          hasMoreNotifications: response.data["hasMoreNotifications"] as bool,
          notifications: (response.data["notifications"] as List).map((notification) {
            return Notification(
              title: notification["title"] as String,
              type: notification["type"] as String,
              date: (notification["date"] as String).parseToDateTime(),
            );
          }).toList(),
        ),
      );
    } catch (e, s) {
      sentryWrapper?.captureException(e, s);
      return GetNotificationsFailureResponse();
    }
  }
}

abstract class GetNotificationsRepositoryResponse extends Equatable {
  @override
  List<Object> get props => [];
}

class GetNotificationsSucceedResponse extends GetNotificationsRepositoryResponse {
  final NotificationInformation notificationInformation;

  GetNotificationsSucceedResponse({required this.notificationInformation});

  @override
  List<Object> get props => [notificationInformation];
}

class GetNotificationsFailureResponse extends GetNotificationsRepositoryResponse {}
