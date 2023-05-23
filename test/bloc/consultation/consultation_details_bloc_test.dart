import 'package:agora/bloc/consultation/details/consultation_details_bloc.dart';
import 'package:agora/bloc/consultation/details/consultation_details_event.dart';
import 'package:agora/bloc/consultation/details/consultation_details_state.dart';
import 'package:agora/bloc/consultation/details/consultation_details_view_model.dart';
import 'package:agora/bloc/thematique/thematique_view_model.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';

import '../../fakes/consultation/fakes_consultation_repository.dart';

void main() {
  Intl.defaultLocale = "fr_FR";
  initializeDateFormatting('fr_FR', null);

  const consultationId = "consultationId";

  group("fetchConsultationDetailsEvent", () {
    blocTest(
      "when repository succeed - should emit success state",
      build: () => ConsultationDetailsBloc(
        consultationRepository: FakeConsultationSuccessRepository(),
      ),
      act: (bloc) => bloc.add(FetchConsultationDetailsEvent(consultationId: consultationId)),
      expect: () => [
        ConsultationDetailsFetchedState(
          ConsultationDetailsViewModel(
            id: consultationId,
            title: "Développer le covoiturage au quotidien",
            coverUrl: "coverUrl",
            thematique: ThematiqueViewModel(picto: "🚊", label: "Transports"),
            endDate: "Jusqu'au 3 mars",
            questionCount: "5 à 10 questions",
            estimatedTime: "5 minutes",
            participantCount: 15035,
            participantCountGoal: 30000,
            participantCountText: "15035 participants",
            participantCountGoalText: "Prochain objectif : 30000 !",
            description: "<body>La description avec textes <b>en gras</b></body>",
            tipsDescription: "<body>texte <i>riche</i></body>",
          ),
        ),
      ],
      wait: const Duration(milliseconds: 5),
    );

    blocTest(
      "when repository failed - should emit failure state",
      build: () => ConsultationDetailsBloc(
        consultationRepository: FakeConsultationFailureRepository(),
      ),
      act: (bloc) => bloc.add(FetchConsultationDetailsEvent(consultationId: consultationId)),
      expect: () => [
        ConsultationDetailsErrorState(),
      ],
      wait: const Duration(milliseconds: 5),
    );
  });
}
