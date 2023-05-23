import 'package:agora/bloc/demographic/send/demographic_responses_send_bloc.dart';
import 'package:agora/bloc/demographic/send/demographic_responses_send_event.dart';
import 'package:agora/bloc/demographic/send/demographic_responses_send_state.dart';
import 'package:agora/domain/demographic/demographic_question_type.dart';
import 'package:agora/domain/demographic/demographic_response.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../fakes/demographic/fakes_demographic_repository.dart';

void main() {
  group("SendDemographicResponsesEvent", () {
    blocTest(
      "when repository succeed - should emit success state",
      build: () => SendDemographicResponsesBloc(
        demographicRepository: FakeDemographicSuccessRepository(),
      ),
      act: (bloc) => bloc.add(
        SendDemographicResponsesEvent(
          demographicResponses: [
            DemographicResponse(demographicType: DemographicType.gender, response: "M"),
            DemographicResponse(demographicType: DemographicType.yearOfBirth, response: "1999"),
            DemographicResponse(demographicType: DemographicType.cityType, response: "R"),
            DemographicResponse(demographicType: DemographicType.consultationFrequency, response: "P"),
          ],
        ),
      ),
      expect: () => [
        SendDemographicResponsesSuccessState(),
      ],
      wait: const Duration(milliseconds: 5),
    );

    blocTest(
      "when repository failed - should emit failure state",
      build: () => SendDemographicResponsesBloc(
        demographicRepository: FakeDemographicFailureRepository(),
      ),
      act: (bloc) => bloc.add(
        SendDemographicResponsesEvent(
          demographicResponses: [
            DemographicResponse(demographicType: DemographicType.gender, response: "M"),
            DemographicResponse(demographicType: DemographicType.yearOfBirth, response: "1999"),
            DemographicResponse(demographicType: DemographicType.cityType, response: "R"),
            DemographicResponse(demographicType: DemographicType.consultationFrequency, response: "P"),
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
