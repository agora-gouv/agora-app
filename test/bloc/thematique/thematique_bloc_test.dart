import 'package:agora/bloc/thematique/thematique_action.dart';
import 'package:agora/bloc/thematique/thematique_bloc.dart';
import 'package:agora/bloc/thematique/thematique_state.dart';
import 'package:agora/infrastructure/thematique/mocks_thematique_repository.dart';
import 'package:bloc_test/bloc_test.dart';

void main() {
  blocTest(
    "fetchThematiqueEvent - when repository succeed - should emit success state",
    build: () => ThematiqueBloc(repository: MockThematiqueSuccessRepository()),
    act: (bloc) => bloc.add(FetchThematiqueEvent()),
    expect: () => [
      ThematiqueSuccessState(
        [
          ThematiqueViewModel(id: "1", picto: "\ud83d\udcbc", label: "Travail & emploi", color: 0xFFCFDEFC),
          ThematiqueViewModel(id: "2", picto: "\ud83c\udf31", label: "Transition écologique", color: 0xFFCFFCD9),
          ThematiqueViewModel(id: "3", picto: "\ud83e\ude7a", label: "Santé", color: 0xFFFCCFDD),
          ThematiqueViewModel(id: "4", picto: "\ud83d\udcc8", label: "Economie", color: 0xFFCFF6FC),
          ThematiqueViewModel(id: "5", picto: "\ud83c\udf93", label: "Education", color: 0xFFFCE7CF),
          ThematiqueViewModel(id: "6", picto: "\ud83c\udf0f", label: "International", color: 0xFFE8CFFC),
          ThematiqueViewModel(id: "7", picto: "\ud83d\ude8a", label: "Transports", color: 0xFFFCF7CF),
          ThematiqueViewModel(id: "8", picto: "\ud83d\ude94", label: "Sécurité", color: 0xFFE1E7F3),
        ],
      )
    ],
    wait: const Duration(milliseconds: 5),
  );

  blocTest(
    "fetchThematiqueEvent - when repository failed - should emit failure state",
    build: () => ThematiqueBloc(repository: MockThematiqueFailureRepository()),
    act: (bloc) => bloc.add(FetchThematiqueEvent()),
    expect: () => [ThematiqueErrorState()],
    wait: const Duration(milliseconds: 5),
  );
}
