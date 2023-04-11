import 'package:agora/bloc/consultation/summary/consultation_summary_bloc.dart';
import 'package:agora/bloc/consultation/summary/consultation_summary_event.dart';
import 'package:agora/bloc/consultation/summary/consultation_summary_state.dart';
import 'package:agora/bloc/consultation/summary/consultation_summary_view_model.dart';
import 'package:bloc_test/bloc_test.dart';

import '../../fakes/consultation/fakes_consultation_repository.dart';

void main() {
  const consultationId = "consultationId";
  blocTest(
    "fetchConsultationSummaryEvent - when repository succeed - should emit success state",
    build: () => ConsultationSummaryBloc(consultationRepository: FakeConsultationSuccessRepository()),
    act: (bloc) => bloc.add(FetchConsultationSummaryEvent(consultationId: consultationId)),
    expect: () => [
      ConsultationSummaryFetchedState(
        ConsultationSummaryViewModel(
          title: "Développer le covoiturage au quotidien",
          participantCount: "15035 participants",
          results: [
            ConsultationSummaryResultsViewModel(
              questionTitle: "Les déplacements professionnels en covoiturage",
              responses: [
                ConsultationSummaryResponseViewModel(label: "En voiture seul", ratio: 65),
                ConsultationSummaryResponseViewModel(label: "En transports en commun, vélo, à pied", ratio: 17),
                ConsultationSummaryResponseViewModel(label: "Autres", ratio: 18),
              ],
            ),
            ConsultationSummaryResultsViewModel(
              questionTitle: "Pour quelle raison principale ?",
              responses: [
                ConsultationSummaryResponseViewModel(label: "Je veux être tranquille dans ma voiture", ratio: 42),
                ConsultationSummaryResponseViewModel(label: "Autres", ratio: 58),
              ],
            ),
          ],
          etEnsuite: ConsultationSummaryEtEnsuiteViewModel(step: 1, description: "textRiche"),
        ),
      ),
    ],
    wait: const Duration(milliseconds: 5),
  );

  blocTest(
    "fetchConsultationSummaryEvent - when repository failed - should emit failure state",
    build: () => ConsultationSummaryBloc(consultationRepository: FakeConsultationFailureRepository()),
    act: (bloc) => bloc.add(FetchConsultationSummaryEvent(consultationId: consultationId)),
    expect: () => [
      ConsultationSummaryErrorState(),
    ],
    wait: const Duration(milliseconds: 5),
  );
}
