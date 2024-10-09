import 'dart:io';

import 'package:agora/common/log/sentry_wrapper.dart';
import 'package:agora/profil/demographic/domain/demographic_information.dart';
import 'package:agora/profil/demographic/domain/demographic_question_type.dart';
import 'package:agora/profil/demographic/domain/demographic_response.dart';
import 'package:agora/profil/demographic/repository/demographic_repository.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../utils/dio_utils.dart';

void main() {
  final dioAdapter = DioUtils.dioAdapter();
  final httpClient = DioUtils.agoraDioHttpClient();
  final sentryWrapper = SentryWrapper();

  group("Get demographic information", () {
    test("when success should return information", () async {
      // Given
      dioAdapter.onGet(
        "/profile",
        (server) => server.reply(
          HttpStatus.ok,
          {
            "gender": "M",
            "yearOfBirth": "1999",
            "department": null,
            "cityType": "R",
            "jobCategory": null,
            "voteFrequency": null,
            "publicMeetingFrequency": null,
            "consultationFrequency": "P",
            "primaryDepartment": "Paris",
            "secondaryDepartment": null,
          },
        ),
        headers: {
          "accept": "application/json",
          "Authorization": "Bearer jwtToken",
        },
      );

      // When
      final repository = DemographicDioRepository(
        httpClient: httpClient,
        sentryWrapper: sentryWrapper,
      );
      final response = await repository.getDemographicResponses();

      // Then
      expect(
        response,
        GetDemographicInformationSucceedResponse(
          demographicInformations: [
            DemographicInformation(demographicType: DemographicQuestionType.gender, data: "M"),
            DemographicInformation(demographicType: DemographicQuestionType.yearOfBirth, data: "1999"),
            DemographicInformation(demographicType: DemographicQuestionType.department, data: null),
            DemographicInformation(demographicType: DemographicQuestionType.cityType, data: "R"),
            DemographicInformation(demographicType: DemographicQuestionType.jobCategory, data: null),
            DemographicInformation(demographicType: DemographicQuestionType.voteFrequency, data: null),
            DemographicInformation(demographicType: DemographicQuestionType.publicMeetingFrequency, data: null),
            DemographicInformation(demographicType: DemographicQuestionType.consultationFrequency, data: "P"),
            DemographicInformation(demographicType: DemographicQuestionType.primaryDepartment, data: "Paris"),
            DemographicInformation(demographicType: DemographicQuestionType.secondaryDepartment, data: null),
          ],
        ),
      );
    });

    test("when failure should return failed", () async {
      // Given
      dioAdapter.onGet(
        "/profile",
        (server) => server.reply(HttpStatus.notFound, {}),
        headers: {
          "accept": "application/json",
          "Authorization": "Bearer jwtToken",
        },
      );

      // When
      final repository = DemographicDioRepository(
        httpClient: httpClient,
        sentryWrapper: sentryWrapper,
      );
      final response = await repository.getDemographicResponses();

      // Then
      expect(response, GetDemographicInformationFailureResponse());
    });
  });

  group("Send demographic responses", () {
    test("when success should return nothing", () async {
      // Given
      dioAdapter.onPost(
        "/profile",
        (server) => server.reply(HttpStatus.ok, {}),
        headers: {
          "accept": "application/json",
          "Authorization": "Bearer jwtToken",
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
      final repository = DemographicDioRepository(
        httpClient: httpClient,
        sentryWrapper: sentryWrapper,
      );
      final response = await repository.sendDemographicResponses(
        demographicResponses: [
          DemographicResponse(demographicType: DemographicQuestionType.gender, response: "M"),
          DemographicResponse(demographicType: DemographicQuestionType.yearOfBirth, response: "1999"),
          DemographicResponse(demographicType: DemographicQuestionType.cityType, response: "R"),
          DemographicResponse(demographicType: DemographicQuestionType.consultationFrequency, response: "P"),
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
          "Authorization": "Bearer jwtToken",
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
      final repository = DemographicDioRepository(
        httpClient: httpClient,
        sentryWrapper: sentryWrapper,
      );
      final response = await repository.sendDemographicResponses(
        demographicResponses: [
          DemographicResponse(demographicType: DemographicQuestionType.gender, response: "M"),
          DemographicResponse(demographicType: DemographicQuestionType.yearOfBirth, response: "1999"),
          DemographicResponse(demographicType: DemographicQuestionType.cityType, response: "R"),
          DemographicResponse(demographicType: DemographicQuestionType.consultationFrequency, response: "P"),
        ],
      );

      // Then
      expect(response, SendDemographicResponsesFailureResponse());
    });
  });
}
