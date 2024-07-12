import 'dart:io';

import 'package:agora/profil/app_feedback/repository/app_feedback_repository.dart';
import 'package:agora/profil/app_feedback/domain/device_informations.dart';
import 'package:agora/profil/app_feedback/domain/app_feedback.dart';
import 'package:agora/common/log/sentry_wrapper.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../utils/dio_utils.dart';

void main() {
  final dioAdapter = DioUtils.dioAdapter();
  final httpClient = DioUtils.agoraDioHttpClient();
  final sentryWrapper = SentryWrapper();
  final bug = AppFeedback(
    type: AppFeedbackType.bug,
    description: 'description',
  );
  final comment = AppFeedback(
    type: AppFeedbackType.comment,
    description: 'description',
  );
  final deviceInfo = DeviceInformation(appVersion: 'appVersion', model: 'model', osVersion: 'osVersion');

  test('when success, should return true', () async {
    // Given
    dioAdapter.onPost(
      '/feedback',
      data: {
        'description': 'description',
        'deviceInfo': {
          'model': 'model',
          'osVersion': 'osVersion',
          'appVersion': 'appVersion',
        },
        'type': 'bug',
      },
      (server) {
        return server.reply(
          HttpStatus.ok,
          {},
        );
      },
      headers: {
        "accept": "application/json",
        "Authorization": "Bearer jwtToken",
      },
    );

    // When
    final repository = AppFeedbackDioRepository(
      httpClient: httpClient,
      minimalSendingTime: Duration(milliseconds: 5),
      sentryWrapper: sentryWrapper,
    );
    final response = await repository.sendFeedback(bug, deviceInfo);

    // Then
    expect(response, true);
  });

  test('when comment, should not send device info', () async {
    // Given
    dioAdapter.onPost(
      '/feedback',
      data: {
        'description': 'description',
        'type': 'comment',
      },
      (server) {
        return server.reply(
          HttpStatus.ok,
          {},
        );
      },
      headers: {
        "accept": "application/json",
        "Authorization": "Bearer jwtToken",
      },
    );

    // When
    final repository = AppFeedbackDioRepository(
      httpClient: httpClient,
      minimalSendingTime: Duration(milliseconds: 5),
      sentryWrapper: sentryWrapper,
    );
    final response = await repository.sendFeedback(comment, deviceInfo);

    // Then
    expect(response, true);
  });

  test('when error, should return false', () async {
    // Given
    dioAdapter.onPost(
      '/feedback',
      data: {
        'description': 'description',
        'deviceInfo': {
          'model': 'model',
          'osVersion': 'osVersion',
          'appVersion': 'appVersion',
        },
        'type': 'bug',
      },
      (server) {
        return server.reply(
          HttpStatus.badRequest,
          {},
        );
      },
      headers: {
        "accept": "application/json",
        "Authorization": "Bearer jwtToken",
      },
    );

    // When
    final repository = AppFeedbackDioRepository(
      httpClient: httpClient,
      minimalSendingTime: Duration(milliseconds: 5),
      sentryWrapper: sentryWrapper,
    );
    final response = await repository.sendFeedback(bug, deviceInfo);

    // Then
    expect(response, false);
  });
}
