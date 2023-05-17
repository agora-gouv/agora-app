import 'dart:io';

import 'package:agora/domain/demographic/demographic_question_type.dart';
import 'package:agora/domain/demographic/demographic_response.dart';
import 'package:agora/infrastructure/demographic/demographic_repository.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../utils/dio_utils.dart';

void main() {
  final dioAdapter = DioUtils.dioAdapter();
  final httpClient = DioUtils.agoraDioHttpClient();

  const deviceId = "deviceId";

  group("Send demographic responses", () {
    test("when success should return nothing", () async {
      // Given
      dioAdapter.onPost(
        "/profile",
        (server) => server.reply(HttpStatus.ok, {}),
        headers: {
          "accept": "application/json",
          "deviceId": deviceId,
        },
        data: {
          "gender": "M",
          "yearOfBirth": "1999",
          "department": null,
          "cityType": "R",
          "jobCategory": null,
          "voteFrequency": null,
          "publicMeetingFrequency": null,
          "consultationFrequency": "P",
        },
      );

      // When
      final repository = DemographicDioRepository(httpClient: httpClient);
      final response = await repository.sendDemographicResponses(
        deviceId: deviceId,
        demographicResponses: [
          DemographicResponse(questionType: DemographicQuestionType.gender, response: "M"),
          DemographicResponse(questionType: DemographicQuestionType.yearOfBirth, response: "1999"),
          DemographicResponse(questionType: DemographicQuestionType.cityType, response: "R"),
          DemographicResponse(questionType: DemographicQuestionType.consultationFrequency, response: "P"),
        ],
      );

      // Then
      expect(response, SendDemographicResponsesSucceedResponse());
    });

    test("when failure should return failed", () async {
      // Given
      dioAdapter.onPost(
        "/profile",
        (server) => server.reply(HttpStatus.notFound, {}),
        headers: {
          "accept": "application/json",
          "deviceId": deviceId,
        },
        data: {
          "gender": "M",
          "yearOfBirth": "1999",
          "department": null,
          "cityType": "R",
          "jobCategory": null,
          "voteFrequency": null,
          "publicMeetingFrequency": null,
          "consultationFrequency": "P",
        },
      );

      // When
      final repository = DemographicDioRepository(httpClient: httpClient);
      final response = await repository.sendDemographicResponses(
        deviceId: deviceId,
        demographicResponses: [
          DemographicResponse(questionType: DemographicQuestionType.gender, response: "M"),
          DemographicResponse(questionType: DemographicQuestionType.yearOfBirth, response: "1999"),
          DemographicResponse(questionType: DemographicQuestionType.cityType, response: "R"),
          DemographicResponse(questionType: DemographicQuestionType.consultationFrequency, response: "P"),
        ],
      );

      // Then
      expect(response, SendDemographicResponsesFailureResponse());
    });
  });
}
