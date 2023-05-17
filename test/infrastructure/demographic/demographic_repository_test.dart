import 'dart:io';

import 'package:agora/domain/demographic/demographic_information.dart';
import 'package:agora/domain/demographic/demographic_question_type.dart';
import 'package:agora/domain/demographic/demographic_response.dart';
import 'package:agora/infrastructure/demographic/demographic_repository.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../utils/dio_utils.dart';

void main() {
  final dioAdapter = DioUtils.dioAdapter();
  final httpClient = DioUtils.agoraDioHttpClient();

  const deviceId = "deviceId";

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
          },
        ),
        headers: {
          "accept": "application/json",
          "deviceId": deviceId,
        },
      );

      // When
      final repository = DemographicDioRepository(httpClient: httpClient);
      final response = await repository.getDemographicResponses(deviceId: deviceId);

      // Then
      expect(
        response,
        GetDemographicInformationSucceedResponse(
          demographicInformations: [
            DemographicInformation(demographicType: DemographicType.gender, data: "M"),
            DemographicInformation(demographicType: DemographicType.yearOfBirth, data: "1999"),
            DemographicInformation(demographicType: DemographicType.department, data: null),
            DemographicInformation(demographicType: DemographicType.cityType, data: "R"),
            DemographicInformation(demographicType: DemographicType.jobCategory, data: null),
            DemographicInformation(demographicType: DemographicType.voteFrequency, data: null),
            DemographicInformation(demographicType: DemographicType.publicMeetingFrequency, data: null),
            DemographicInformation(demographicType: DemographicType.consultationFrequency, data: "P"),
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
          "deviceId": deviceId,
        },
      );

      // When
      final repository = DemographicDioRepository(httpClient: httpClient);
      final response = await repository.getDemographicResponses(deviceId: deviceId);

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
          DemographicResponse(demographicType: DemographicType.gender, response: "M"),
          DemographicResponse(demographicType: DemographicType.yearOfBirth, response: "1999"),
          DemographicResponse(demographicType: DemographicType.cityType, response: "R"),
          DemographicResponse(demographicType: DemographicType.consultationFrequency, response: "P"),
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
          DemographicResponse(demographicType: DemographicType.gender, response: "M"),
          DemographicResponse(demographicType: DemographicType.yearOfBirth, response: "1999"),
          DemographicResponse(demographicType: DemographicType.cityType, response: "R"),
          DemographicResponse(demographicType: DemographicType.consultationFrequency, response: "P"),
        ],
      );

      // Then
      expect(response, SendDemographicResponsesFailureResponse());
    });
  });
}
