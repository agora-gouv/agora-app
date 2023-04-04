import 'dart:io';

import 'package:agora/domain/consultation/details/consultation_details.dart';
import 'package:agora/infrastructure/consultation/consultation_repository.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../utils/dio_utils.dart';

void main() {
  final dioAdapter = DioUtils.dioAdapter();
  final httpClient = DioUtils.agoraDioHttpClient();

  group("Fetch consultation details", () {
    const consultationId = "consultationId";

    test("when success should return consultation details", () async {
      // Given
      dioAdapter.onGet(
        "/consultations/$consultationId",
        (server) => server.reply(
          HttpStatus.ok,
          {
            "id": 0,
            "title": "Développer le covoiturage",
            "cover": "<imageByteEncodéeBase64>",
            "thematique_id": 2,
            "end_date": "2023-03-21",
            "question_count": "5 à 10 questions",
            "estimated_time": "5 minutes",
            "participant_count": 15035,
            "participant_count_goal": 30000,
            "description":
                "La description avec textes <b>en gras</b> et potentiellement des <a href=\"http://google.fr\">liens</a>",
            "tips_description": "Qui peut aussi être du texte <i>riche</i>",
          },
        ),
        headers: {"accept": "application/json"},
      );

      // When
      final repository = ConsultationDioRepository(httpClient: httpClient);
      final response = await repository.fetchConsultationDetails(consultationId);

      // Then
      expect(
        response,
        GetConsultationDetailsSucceedResponse(
          consultationDetails: ConsultationDetails(
            id: 1,
            title: "Développer le covoiturage",
            cover: "<imageByteEncodéeBase64>",
            thematiqueId: 2,
            endDate: DateTime(2023, 3, 21),
            questionCount: "5 à 10 questions",
            estimatedTime: "5 minutes",
            participantCount: 15035,
            participantCountGoal: 30000,
            description:
                "La description avec textes <b>en gras</b> et potentiellement des <a href=\"http://google.fr\">liens</a>",
            tipsDescription: "Qui peut aussi être du texte <i>riche</i>",
          ),
        ),
      );
    });

    test("when failure should return failed", () async {
      // Given
      dioAdapter.onGet(
        "/consultations/$consultationId",
        (server) => server.reply(HttpStatus.notFound, {}),
        headers: {"accept": "application/json"},
      );

      // When
      final repository = ConsultationDioRepository(httpClient: httpClient);
      final response = await repository.fetchConsultationDetails(consultationId);

      // Then
      expect(response, GetConsultationDetailsFailedResponse());
    });
  });
}
