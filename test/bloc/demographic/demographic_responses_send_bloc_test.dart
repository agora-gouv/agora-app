import 'package:agora/bloc/demographic/send/demographic_responses_send_bloc.dart';
import 'package:agora/bloc/demographic/send/demographic_responses_send_event.dart';
import 'package:agora/bloc/demographic/send/demographic_responses_send_state.dart';
import 'package:agora/domain/demographic/demographic_question_type.dart';
import 'package:agora/domain/demographic/demographic_response.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../fakes/demographic/fakes_demographic_repository.dart';
import '../../fakes/qag/fake_device_id_helper.dart';

void main() {
  group("SendDemographicResponsesEvent", () {
    blocTest(
      "when repository succeed - should emit success state",
      build: () => SendDemographicResponsesBloc(
        demographicRepository: FakeDemographicSuccessRepository(),
        deviceInfoHelper: FakeDeviceInfoHelper(),
      ),
      act: (bloc) => bloc.add(
        SendDemographicResponsesEvent(
          demographicResponses: [
            DemographicResponse(questionType: DemographicQuestionType.gender, response: "M"),
            DemographicResponse(questionType: DemographicQuestionType.yearOfBirth, response: "1999"),
            DemographicResponse(questionType: DemographicQuestionType.cityType, response: "R"),
            DemographicResponse(questionType: DemographicQuestionType.consultationFrequency, response: "P"),
          ],
        ),
      ),
      expect: () => [
        SendDemographicResponsesSuccessState(),
      ],
      wait: const Duration(milliseconds: 5),
    );

    blocTest(
      "when device id is null - should emit failure state",
      build: () => SendDemographicResponsesBloc(
        demographicRepository: FakeDemographicSuccessRepository(),
        deviceInfoHelper: FakeDeviceIdNullHelper(),
      ),
      act: (bloc) => bloc.add(
        SendDemographicResponsesEvent(
          demographicResponses: [
            DemographicResponse(questionType: DemographicQuestionType.gender, response: "M"),
            DemographicResponse(questionType: DemographicQuestionType.yearOfBirth, response: "1999"),
            DemographicResponse(questionType: DemographicQuestionType.cityType, response: "R"),
            DemographicResponse(questionType: DemographicQuestionType.consultationFrequency, response: "P"),
          ],
        ),
      ),
      expect: () => [
        SendDemographicResponsesFailureState(),
      ],
      wait: const Duration(milliseconds: 5),
    );

    blocTest(
      "when repository failed - should emit failure state",
      build: () => SendDemographicResponsesBloc(
        demographicRepository: FakeDemographicFailureRepository(),
        deviceInfoHelper: FakeDeviceInfoHelper(),
      ),
      act: (bloc) => bloc.add(
        SendDemographicResponsesEvent(
          demographicResponses: [
            DemographicResponse(questionType: DemographicQuestionType.gender, response: "M"),
            DemographicResponse(questionType: DemographicQuestionType.yearOfBirth, response: "1999"),
            DemographicResponse(questionType: DemographicQuestionType.cityType, response: "R"),
            DemographicResponse(questionType: DemographicQuestionType.consultationFrequency, response: "P"),
          ],
        ),
      ),
      expect: () => [
        SendDemographicResponsesFailureState(),
      ],
      wait: const Duration(milliseconds: 5),
    );
  });
}
