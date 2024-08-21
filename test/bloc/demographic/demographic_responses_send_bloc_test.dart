import 'package:agora/profil/demographic/bloc/send/demographic_responses_send_bloc.dart';
import 'package:agora/profil/demographic/bloc/send/demographic_responses_send_event.dart';
import 'package:agora/profil/demographic/bloc/send/demographic_responses_send_state.dart';
import 'package:agora/profil/demographic/domain/demographic_question_type.dart';
import 'package:agora/profil/demographic/domain/demographic_response.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../fakes/demographic/fake_profile_demographic_storage_client.dart';
import '../../fakes/demographic/fakes_demographic_repository.dart';

void main() {
  group("SendDemographicResponsesEvent", () {
    final fakeStorageClient1 = FakeProfileDemographicStorageClient();
    blocTest(
      "when repository succeed - should emit success state",
      build: () => SendDemographicResponsesBloc(
        demographicRepository: FakeDemographicSuccessRepository(),
        profileDemographicStorageClient: fakeStorageClient1,
      ),
      act: (bloc) => bloc.add(
        SendDemographicResponsesEvent(
          demographicResponses: [
            DemographicResponse(demographicType: DemographicQuestionType.gender, response: "M"),
            DemographicResponse(demographicType: DemographicQuestionType.yearOfBirth, response: "1999"),
            DemographicResponse(demographicType: DemographicQuestionType.cityType, response: "R"),
            DemographicResponse(demographicType: DemographicQuestionType.consultationFrequency, response: "P"),
          ],
        ),
      ),
      expect: () => [
        SendDemographicResponsesSuccessState(),
      ],
      wait: const Duration(milliseconds: 5),
      tearDown: () async {
        expect(await fakeStorageClient1.isFirstDisplay(), false);
      },
    );

    final fakeStorageClient2 = FakeProfileDemographicStorageClient();
    blocTest(
      "when repository failed - should emit failure state",
      build: () => SendDemographicResponsesBloc(
        demographicRepository: FakeDemographicFailureRepository(),
        profileDemographicStorageClient: fakeStorageClient2,
      ),
      act: (bloc) => bloc.add(
        SendDemographicResponsesEvent(
          demographicResponses: [
            DemographicResponse(demographicType: DemographicQuestionType.gender, response: "M"),
            DemographicResponse(demographicType: DemographicQuestionType.yearOfBirth, response: "1999"),
            DemographicResponse(demographicType: DemographicQuestionType.cityType, response: "R"),
            DemographicResponse(demographicType: DemographicQuestionType.consultationFrequency, response: "P"),
          ],
        ),
      ),
      expect: () => [
        SendDemographicResponsesFailureState(),
      ],
      wait: const Duration(milliseconds: 5),
      tearDown: () async {
        expect(await fakeStorageClient2.isFirstDisplay(), true);
      },
    );
  });
}
