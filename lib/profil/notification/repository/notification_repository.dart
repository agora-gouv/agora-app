import 'package:agora/common/client/agora_http_client.dart';
import 'package:agora/common/extension/date_extension.dart';
import 'package:agora/profil/notification/domain/notification.dart';
import 'package:agora/common/log/sentry_wrapper.dart';
import 'package:agora/profil/notification/domain/notification_information.dart';
import 'package:equatable/equatable.dart';

abstract class NotificationRepository {
  Future<GetNotificationsRepositoryResponse> getNotifications({
    required int pageNumber,
  });
}

class NotificationDioRepository extends NotificationRepository {
  final AgoraDioHttpClient httpClient;
  final SentryWrapper sentryWrapper;

  NotificationDioRepository({required this.httpClient, required this.sentryWrapper});

  @override
  Future<GetNotificationsRepositoryResponse> getNotifications({
    required int pageNumber,
  }) async {
    final uri = "/notifications/paginated/$pageNumber";
    try {
      final response = await httpClient.get(uri);
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
    } catch (exception, stacktrace) {
      sentryWrapper.captureException(exception, stacktrace, message: "Erreur lors de l'appel : $uri");
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
