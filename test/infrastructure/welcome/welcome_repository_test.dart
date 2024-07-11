import 'dart:io';

import 'package:agora/infrastructure/errors/sentry_wrapper.dart';
import 'package:agora/welcome/domain/welcome_a_la_une.dart';
import 'package:agora/welcome/repository/welcome_repository.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../utils/dio_utils.dart';

void main() {
  final dioAdapter = DioUtils.dioAdapter();
  final httpClient = DioUtils.agoraDioHttpClient();
  final sentryWrapper = SentryWrapper();

  test('when success, should return A la une infos', () async {
    // Given
    dioAdapter.onGet(
      '/welcome_page/last_news',
      (server) {
        return server.reply(
          HttpStatus.ok,
          {
            'description': 'description',
            'callToActionText': 'callToActionText',
            'routeName': 'routeName',
            'routeArgument': 'routeArgument',
          },
        );
      },
      headers: {
        "accept": "application/json",
        "Authorization": "Bearer jwtToken",
      },
    );

    // When
    final repository = WelcomeDioRepository(
      httpClient: httpClient,
      sentryWrapper: sentryWrapper,
    );
    final response = await repository.getWelcomeALaUne();

    // Then
    final aLaUne = WelcomeALaUne(
      description: 'description',
      actionText: 'callToActionText',
      routeName: 'routeName',
      routeArgument: 'routeArgument',
    );
    expect(response, aLaUne);
  });

  test('when error, should return null', () async {
    // Given
    dioAdapter.onGet(
      '/welcome_page/last_news',
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
    final repository = WelcomeDioRepository(
      httpClient: httpClient,
      sentryWrapper: sentryWrapper,
    );
    final response = await repository.getWelcomeALaUne();

    // Then
    expect(response, null);
  });

  test('when success but data already fetch, should return A la une infos without network call', () async {
    // Given
    dioAdapter.onGet(
      '/welcome_page/last_news',
      (server) {
        return server.reply(
          HttpStatus.ok,
          {
            'description': 'description',
            'callToActionText': 'callToActionText',
            'routeName': 'routeName',
            'routeArgument': 'routeArgument',
          },
        );
      },
      headers: {
        "accept": "application/json",
        "Authorization": "Bearer jwtToken",
      },
    );

    // When
    final repository = WelcomeDioRepository(
      httpClient: httpClient,
      sentryWrapper: sentryWrapper,
    );
    await repository.getWelcomeALaUne();
    final response = await repository.getWelcomeALaUne();

    // Then
    final aLaUne = WelcomeALaUne(
      description: 'description',
      actionText: 'callToActionText',
      routeName: 'routeName',
      routeArgument: 'routeArgument',
    );
    expect(response, aLaUne);
  });
}
