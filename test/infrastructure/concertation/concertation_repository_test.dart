import 'dart:io';

import 'package:agora/common/log/sentry_wrapper.dart';
import 'package:agora/concertation/repository/concertation_repository.dart';
import 'package:agora/consultation/domain/consultation.dart';
import 'package:agora/consultation/repository/consultation_mapper.dart';
import 'package:agora/thematique/domain/thematique.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../utils/dio_utils.dart';

class MockConsultationMapper extends Mock implements ConsultationMapper {}

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
              "slug": "consultationId1",
              "title": "Développer le covoiturage",
              "imageUrl": "coverUrl1",
              "externalLink": "externalLink1",
              "thematique": {"label": "Transports", "picto": "🚊"},
              "updateDate": "2023-03-21",
              "updateLabel": "Plus que 3 jours",
              "territory": "Paris",
            }
          ],
        ),
        headers: {
          "accept": "application/json",
          "Authorization": "Bearer jwtToken",
        },
      );

      final consultationMapper = MockConsultationMapper();

      // When
      final repository = ConcertationDioRepository(
        httpClient: httpClient,
        sentryWrapper: sentryWrapper,
        mapper: consultationMapper,
      );
      final response = await repository.fetchConcertations();

      // Then
      expect(
        response,
        [
          Concertation(
            id: "consultationId1",
            slug: "consultationId1",
            title: "Développer le covoiturage",
            coverUrl: "coverUrl1",
            externalLink: "externalLink1",
            thematique: Thematique(label: "Transports", picto: "🚊"),
            updateDate: DateTime(2023, 3, 21),
            label: "Plus que 3 jours",
            territoire: "Paris",
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
        mapper: ConsultationMapper(),
      );
      final response = await repository.fetchConcertations();

      // Then
      expect(response, []);
    });
  });
}
