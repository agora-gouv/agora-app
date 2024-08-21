import 'package:agora/thematique/bloc/thematique_bloc.dart';
import 'package:agora/thematique/bloc/thematique_event.dart';
import 'package:agora/thematique/bloc/thematique_state.dart';
import 'package:agora/thematique/bloc/thematique_with_id_view_model.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../fakes/thematique/fakes_thematique_repository.dart';

void main() {
  group("FetchFilterThematiqueEvent", () {
    blocTest(
      "when repository succeed - should emit loading then success state",
      build: () => ThematiqueBloc(repository: FakeThematiqueSuccessRepository()),
      act: (bloc) => bloc.add(FetchFilterThematiqueEvent()),
      expect: () => [
        ThematiqueInitialLoadingState(),
        ThematiqueSuccessState(
          [
            ThematiqueWithIdViewModel(id: null, picto: "\ud83d\udca1", label: "Toutes"),
            ThematiqueWithIdViewModel(id: "1", picto: "\ud83d\udcbc", label: "Travail & emploi"),
            ThematiqueWithIdViewModel(id: "2", picto: "\ud83c\udf31", label: "Transition écologique"),
            ThematiqueWithIdViewModel(id: "3", picto: "\ud83e\ude7a", label: "Santé"),
            ThematiqueWithIdViewModel(id: "4", picto: "\ud83d\udcc8", label: "Economie"),
            ThematiqueWithIdViewModel(id: "5", picto: "\ud83c\udf93", label: "Education"),
            ThematiqueWithIdViewModel(id: "6", picto: "\ud83c\udf0f", label: "International"),
            ThematiqueWithIdViewModel(id: "7", picto: "\ud83d\ude8a", label: "Transports"),
            ThematiqueWithIdViewModel(id: "8", picto: "\ud83d\ude94", label: "Sécurité"),
            ThematiqueWithIdViewModel(id: "9", picto: "\ud83d\udce6", label: "Autre"),
          ],
        ),
      ],
      wait: const Duration(milliseconds: 5),
    );

    blocTest(
      "when repository failed - should emit loading then failure state",
      build: () => ThematiqueBloc(repository: FakeThematiqueFailureRepository()),
      act: (bloc) => bloc.add(FetchFilterThematiqueEvent()),
      expect: () => [ThematiqueInitialLoadingState(), ThematiqueErrorState()],
      wait: const Duration(milliseconds: 5),
    );
  });

  group("FetchAskQaGThematiqueEvent", () {
    blocTest(
      "when repository succeed - should emit loading then success state",
      build: () => ThematiqueBloc(repository: FakeThematiqueSuccessRepository()),
      act: (bloc) => bloc.add(FetchAskQaGThematiqueEvent()),
      expect: () => [
        ThematiqueInitialLoadingState(),
        ThematiqueSuccessState(
          [
            ThematiqueWithIdViewModel(id: "9", picto: "\ud83d\udce6", label: "Autre / Je ne sais pas"),
            ThematiqueWithIdViewModel(id: "1", picto: "\ud83d\udcbc", label: "Travail & emploi"),
            ThematiqueWithIdViewModel(id: "2", picto: "\ud83c\udf31", label: "Transition écologique"),
            ThematiqueWithIdViewModel(id: "3", picto: "\ud83e\ude7a", label: "Santé"),
            ThematiqueWithIdViewModel(id: "4", picto: "\ud83d\udcc8", label: "Economie"),
            ThematiqueWithIdViewModel(id: "5", picto: "\ud83c\udf93", label: "Education"),
            ThematiqueWithIdViewModel(id: "6", picto: "\ud83c\udf0f", label: "International"),
            ThematiqueWithIdViewModel(id: "7", picto: "\ud83d\ude8a", label: "Transports"),
            ThematiqueWithIdViewModel(id: "8", picto: "\ud83d\ude94", label: "Sécurité"),
          ],
        ),
      ],
      wait: const Duration(milliseconds: 5),
    );

    blocTest(
      "when repository failed - should emit loading then failure state",
      build: () => ThematiqueBloc(repository: FakeThematiqueFailureRepository()),
      act: (bloc) => bloc.add(FetchAskQaGThematiqueEvent()),
      expect: () => [ThematiqueInitialLoadingState(), ThematiqueErrorState()],
      wait: const Duration(milliseconds: 5),
    );
  });
}
