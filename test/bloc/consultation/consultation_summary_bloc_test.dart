import 'package:agora/bloc/consultation/summary/consultation_summary_bloc.dart';
import 'package:agora/bloc/consultation/summary/consultation_summary_event.dart';
import 'package:agora/bloc/consultation/summary/consultation_summary_state.dart';
import 'package:agora/bloc/consultation/summary/consultation_summary_view_model.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../fakes/consultation/fakes_consultation_repository.dart';
import '../../fakes/qag/fake_device_id_helper.dart';

void main() {
  const consultationId = "consultationId";

  group("fetchConsultationSummaryEvent", () {
    blocTest(
      "when repository succeed - should emit success state",
      build: () => ConsultationSummaryBloc(
        consultationRepository: FakeConsultationSuccessRepository(),
        deviceInfoHelper: FakeDeviceInfoHelper(),
      ),
      act: (bloc) => bloc.add(FetchConsultationSummaryEvent(consultationId: consultationId)),
      expect: () => [
        ConsultationSummaryFetchedState(
          ConsultationSummaryViewModel(
            title: "Développer le covoiturage au quotidien",
            participantCount: "15035 participants",
            results: [
              ConsultationSummaryMultipleChoicesResultsViewModel(
                questionTitle: "Pour quelle raison principale ?",
                order: 1,
                responses: [
                  ConsultationSummaryResponseViewModel(label: "Autres", ratio: 58),
                  ConsultationSummaryResponseViewModel(label: "Je veux être tranquille dans ma voiture", ratio: 42),
                ],
              ),
              ConsultationSummaryUniqueChoiceResultsViewModel(
                questionTitle: "Les déplacements professionnels en covoiturage",
                order: 2,
                responses: [
                  ConsultationSummaryResponseViewModel(label: "En voiture seul", ratio: 65),
                  ConsultationSummaryResponseViewModel(label: "Autres", ratio: 18),
                  ConsultationSummaryResponseViewModel(label: "En transports en commun, vélo, à pied", ratio: 17),
                ],
              ),
            ],
            etEnsuite: ConsultationSummaryEtEnsuiteViewModel(
              step: "Étape 1/3",
              image: "assets/ic_summary_consultation_step1.svg",
              title: "Consultation en cours",
              description: "<body>textRiche</body>",
            ),
          ),
        ),
      ],
      wait: const Duration(milliseconds: 5),
    );

    blocTest(
      "when device id is null - should emit failure state",
      build: () => ConsultationSummaryBloc(
        consultationRepository: FakeConsultationSuccessRepository(),
        deviceInfoHelper: FakeDeviceIdNullHelper(),
      ),
      act: (bloc) => bloc.add(FetchConsultationSummaryEvent(consultationId: consultationId)),
      expect: () => [
        ConsultationSummaryErrorState(),
      ],
      wait: const Duration(milliseconds: 5),
    );

    blocTest(
      "when repository failed - should emit failure state",
      build: () => ConsultationSummaryBloc(
        consultationRepository: FakeConsultationFailureRepository(),
        deviceInfoHelper: FakeDeviceInfoHelper(),
      ),
      act: (bloc) => bloc.add(FetchConsultationSummaryEvent(consultationId: consultationId)),
      expect: () => [
        ConsultationSummaryErrorState(),
      ],
      wait: const Duration(milliseconds: 5),
    );
  });
}
