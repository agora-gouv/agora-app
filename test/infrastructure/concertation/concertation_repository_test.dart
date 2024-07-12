import 'dart:io';

import 'package:agora/concertation/repository/concertation_repository.dart';
import 'package:agora/consultation/domain/consultation.dart';
import 'package:agora/thematique/domain/thematique.dart';
import 'package:agora/common/log/sentry_wrapper.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../utils/dio_utils.dart';

void main() {
  final dioAdapter = DioUtils.dioAdapter();
  final httpClient = DioUtils.agoraDioHttpClient();
  final sentryWrapper = SentryWrapper();

  group("Fetch concertations", () {
    test("when success should return concertations", () async {
      // Given
      dioAdapter.onGet(
        "/concertations",
        (server) => server.reply(
          HttpStatus.ok,
          [
            {
              "id": "consultationId1",
              "title": "Développer le covoiturage",
              "imageUrl": "coverUrl1",
              "externalLink": "externalLink1",
              "thematique": {"label": "Transports", "picto": "🚊"},
              "updateDate": "2023-03-21",
              "updateLabel": "Plus que 3 jours",
            }
          ],
        ),
        headers: {
          "accept": "application/json",
          "Authorization": "Bearer jwtToken",
        },
      );

      // When
      final repository = ConcertationDioRepository(
        httpClient: httpClient,
        sentryWrapper: sentryWrapper,
      );
      final response = await repository.getConcertations();

      // Then
      expect(
        response,
        [
          Concertation(
            id: "consultationId1",
            title: "Développer le covoiturage",
            coverUrl: "coverUrl1",
            externalLink: "externalLink1",
            thematique: Thematique(label: "Transports", picto: "🚊"),
            updateDate: DateTime(2023, 3, 21),
            label: "Plus que 3 jours",
          ),
        ],
      );
    });

    test("when failure should return empty list", () async {
      // Given
      dioAdapter.onGet(
        "/concertations",
        (server) {
          server.throws(
            404,
            DioException.connectionTimeout(
              timeout: Duration(seconds: 60),
              requestOptions: RequestOptions(),
            ),
          );
        },
      );

      // When
      final repository = ConcertationDioRepository(
        httpClient: httpClient,
        sentryWrapper: sentryWrapper,
      );
      final response = await repository.getConcertations();

      // Then
      expect(response, []);
    });
  });
}
