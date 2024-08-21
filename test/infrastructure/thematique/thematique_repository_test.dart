import 'dart:io';

import 'package:agora/thematique/domain/thematique_with_id.dart';
import 'package:agora/common/log/sentry_wrapper.dart';
import 'package:agora/thematique/repository/thematique_repository.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../utils/dio_utils.dart';

void main() {
  final dioAdapter = DioUtils.dioAdapter();
  final httpClient = DioUtils.agoraDioHttpClient();
  final sentryWrapper = SentryWrapper();

  group('Fetch thematiques', () {
    test("when success should return thematiques", () async {
      // Given
      dioAdapter.onGet(
        "/thematiques",
        (server) => server.reply(
          HttpStatus.ok,
          {
            "thematiques": [
              {
                "id": "1",
                "label": "Travail & emploi",
                "picto": "\uD83D\uDCBC",
                "color": "#FFCFDEFC",
              },
              {
                "id": "2",
                "label": "Transition écologique",
                "picto": "\uD83D\uDCBC",
                "color": "#FFCFFCD9",
              },
            ],
          },
        ),
        headers: {"accept": "application/json"},
      );

      // When
      final repository = ThematiqueDioRepository(
        httpClient: httpClient,
        sentryWrapper: sentryWrapper,
      );
      final response = await repository.fetchThematiques();

      // Then
      expect(
        response,
        GetThematiqueSucceedResponse(
          thematiques: [
            ThematiqueWithId(id: "1", picto: "\uD83D\uDCBC", label: "Travail & emploi"),
            ThematiqueWithId(id: "2", picto: "\uD83D\uDCBC", label: "Transition écologique"),
          ],
        ),
      );
    });

    test("when failure should return failed", () async {
      // Given
      dioAdapter.onGet(
        "/thematiques",
        (server) => server.reply(HttpStatus.notFound, {}),
        headers: {"accept": "application/json"},
      );

      // When
      final repository = ThematiqueDioRepository(
        httpClient: httpClient,
        sentryWrapper: sentryWrapper,
      );
      final response = await repository.fetchThematiques();

      // Then
      expect(response, GetThematiqueFailedResponse());
    });
  });
}
