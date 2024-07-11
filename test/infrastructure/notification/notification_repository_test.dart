import 'dart:io';

import 'package:agora/domain/notification/notification.dart';
import 'package:agora/infrastructure/errors/sentry_wrapper.dart';
import 'package:agora/infrastructure/notification/notification_repository.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../utils/dio_utils.dart';

void main() {
  final dioAdapter = DioUtils.dioAdapter();
  final httpClient = DioUtils.agoraDioHttpClient();
  final sentryWrapper = SentryWrapper();

  group("Get notifications", () {
    const pageNumber = 1;

    test("when success should return notifications", () async {
      // Given
      dioAdapter.onGet(
        "/notifications/paginated/$pageNumber",
        (server) => server.reply(
          HttpStatus.ok,
          {
            "hasMoreNotifications": true,
            "notifications": [
              {
                "title": "Titre de la notification",
                "type": "Consultations",
                "date": "2023-07-27",
              }
            ],
          },
        ),
        headers: {
          "accept": "application/json",
          "Authorization": "Bearer jwtToken",
        },
      );

      // When
      final repository = NotificationDioRepository(
        httpClient: httpClient,
        sentryWrapper: sentryWrapper,
      );
      final response = await repository.getNotifications(pageNumber: pageNumber);

      // Then
      expect(
        response,
        GetNotificationsSucceedResponse(
          notificationInformation: NotificationInformation(
            hasMoreNotifications: true,
            notifications: [
              Notification(
                title: "Titre de la notification",
                type: "Consultations",
                date: DateTime(2023, 7, 27),
              ),
            ],
          ),
        ),
      );
    });

    test("when failure should return failed", () async {
      // Given
      dioAdapter.onGet(
        "/notifications/paginated/$pageNumber",
        (server) => server.reply(HttpStatus.notFound, {}),
        headers: {
          "accept": "application/json",
          "Authorization": "Bearer jwtToken",
        },
      );

      // When
      final repository = NotificationDioRepository(
        httpClient: httpClient,
        sentryWrapper: sentryWrapper,
      );
      final response = await repository.getNotifications(pageNumber: pageNumber);

      // Then
      expect(response, GetNotificationsFailureResponse());
    });
  });
}
