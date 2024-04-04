import 'package:agora/bloc/consultation/dynamic/dynamic_consultation_events.dart';
import 'package:agora/bloc/consultation/dynamic/responses/dynamic_consultation_results_state.dart';
import 'package:agora/bloc/consultation/dynamic/responses/dynamic_consultations_results_bloc.dart';
import 'package:agora/domain/consultation/summary/consultation_summary_results.dart';
import 'package:bloc_test/bloc_test.dart';

import '../../../fakes/consultation/fakes_consultation_repository.dart';

void main() {
  const consultationId = "consultationId";

  blocTest(
    'when repository succeed - should emit success state',
    build: () => DynamicConsultationResultsBloc(
      FakeConsultationSuccessRepository(),
    ),
    act: (bloc) => bloc.add(FetchDynamicConsultationResultsEvent(consultationId)),
    expect: () => [
      DynamicConsultationResultsLoadingState(),
      DynamicConsultationResultsSuccessState(
        title: "Développer le covoiturage au quotidien",
        coverUrl: "coverUrl",
        participantCount: 1200,
        results: [
          ConsultationSummaryUniqueChoiceResults(
            questionTitle: "Les déplacements professionnels en covoiturage",
            order: 1,
            responses: [
              ConsultationSummaryResponse(label: "En voiture seul", ratio: 65, isUserResponse: true),
              ConsultationSummaryResponse(label: "Autre", ratio: 35),
            ],
          ),
        ],
      ),
    ],
  );

  blocTest(
    'when repository fails - should emit error state',
    build: () => DynamicConsultationResultsBloc(
      FakeConsultationFailureRepository(),
    ),
    act: (bloc) => bloc.add(FetchDynamicConsultationResultsEvent(consultationId)),
    expect: () => [
      DynamicConsultationResultsLoadingState(),
      DynamicConsultationResultsErrorState(),
    ],
  );
}
