import 'package:agora/bloc/consultation/summary/consultation_summary_bloc.dart';
import 'package:agora/bloc/consultation/summary/consultation_summary_event.dart';
import 'package:agora/bloc/consultation/summary/consultation_summary_state.dart';
import 'package:agora/bloc/consultation/summary/consultation_summary_view_model.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../fakes/consultation/fakes_consultation_repository.dart';

void main() {
  const consultationId = "consultationId";

  group("fetchConsultationSummaryEvent", () {
    blocTest(
      "when repository succeed - should emit success state",
      build: () => ConsultationSummaryBloc(
        consultationRepository: FakeConsultationSuccessRepository(),
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
              explanationsTitle: "explanations title",
              explanations: [
                ConsultationSummaryEtEnsuiteExplanationViewModel(
                  isTogglable: false,
                  title: "toogle text title",
                  intro: "<body>image introduction</body>",
                  imageUrl: "<imageURL>",
                  description: "<body>image description</body>",
                ),
              ],
              video: ConsultationSummaryEtEnsuiteVideoViewModel(
                title: "video title",
                intro: "<body>video intro</body>",
                videoUrl: "<videoUrl>",
                videoWidth: 1080,
                videoHeight: 1920,
                transcription: "transcription video",
              ),
              conclusion: ConsultationSummaryEtEnsuiteConclusionViewModel(
                title: "conclusion title",
                description: "<body>conclusion description</body>",
              ),
            ),
          ),
        ),
      ],
      wait: const Duration(milliseconds: 5),
    );

    blocTest(
      "when repository succeed with explanations title null and video null - should emit success state",
      build: () => ConsultationSummaryBloc(
        consultationRepository: FakeConsultationEtEnsuiteWithNullElementsRepository(),
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
              explanationsTitle: null,
              explanations: [
                ConsultationSummaryEtEnsuiteExplanationViewModel(
                  isTogglable: false,
                  title: "toogle text title",
                  intro: "<body>image introduction</body>",
                  imageUrl: "<imageURL>",
                  description: "<body>image description</body>",
                ),
              ],
              video: null,
              conclusion: null,
            ),
          ),
        ),
      ],
      wait: const Duration(milliseconds: 5),
    );

    blocTest(
      "when repository failed - should emit failure state",
      build: () => ConsultationSummaryBloc(
        consultationRepository: FakeConsultationFailureRepository(),
      ),
      act: (bloc) => bloc.add(FetchConsultationSummaryEvent(consultationId: consultationId)),
      expect: () => [
        ConsultationSummaryErrorState(),
      ],
      wait: const Duration(milliseconds: 5),
    );
  });
}
