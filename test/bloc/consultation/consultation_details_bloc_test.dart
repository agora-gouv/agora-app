import 'package:agora/bloc/consultation/details/consultation_details_action.dart';
import 'package:agora/bloc/consultation/details/consultation_details_bloc.dart';
import 'package:agora/bloc/consultation/details/consultation_details_state.dart';
import 'package:agora/infrastructure/consultation/mocks_consultation_repository.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';

void main() {
  Intl.defaultLocale = "fr_FR";
  initializeDateFormatting('fr_FR', null);

  blocTest(
    "fetchConsultationDetailsEvent - when repository succeed - should emit success state",
    build: () => ConsultationDetailsBloc(consultationRepository: FakeConsultationSuccessRepository()),
    act: (bloc) => bloc.add(FetchConsultationDetailsEvent()),
    expect: () => [
      ConsultationDetailsLoadingState(),
      ConsultationDetailsFetchedState(
        ConsultationDetailsViewModel(
          id: 1,
          title: "Développer le covoiturage au quotidien",
          cover: "imageEnBase64",
          thematiqueId: 7,
          endDate: "jusqu'au 03 mars",
          questionCount: "5 à 10 questions",
          estimatedTime: "5 minutes",
          participantCount: 15035,
          participantCountGoal: 30000,
          participantCountText: "15035 participants",
          participantCountGoalText: "Prochain objectif : 30000 !",
          description:
              "<body>La description avec textes <b>en gras</b> et potentiellement des <a href=\"https://google.fr\">liens</a><br/><br/><ul><li>example1 <b>en gras</b></li><li>example2</li></ul></body>",
          tipsDescription: "<body>Qui peut aussi être du texte <i>riche</i></body>",
        ),
      ),
    ],
    wait: const Duration(milliseconds: 200),
  );

  blocTest(
    "fetchConsultationDetailsEvent - when repository failed - should emit failure state",
    build: () => ConsultationDetailsBloc(consultationRepository: MockConsultationFailureRepository()),
    act: (bloc) => bloc.add(FetchConsultationDetailsEvent()),
    expect: () => [
      ConsultationDetailsLoadingState(),
      ConsultationDetailsErrorState(),
    ],
    wait: const Duration(milliseconds: 200),
  );
}
