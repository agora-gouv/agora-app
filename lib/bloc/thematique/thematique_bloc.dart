import 'package:agora/bloc/thematique/thematique_action.dart';
import 'package:agora/bloc/thematique/thematique_state.dart';
import 'package:agora/domain/thematique/thematique.dart';
import 'package:agora/extension/string_extension.dart';
import 'package:agora/infrastructure/thematique/thematique_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ThematiqueBloc extends Bloc<ThematiqueEvent, ThematiqueState> {
  final ThematiqueRepository repository;

  ThematiqueBloc({required this.repository}) : super(ThematiqueInitialState()) {
    on<FetchThematiqueEvent>(_handleThematiqueEvent);
  }

  Future<void> _handleThematiqueEvent(FetchThematiqueEvent event, Emitter<ThematiqueState> emit) async {
    final thematiquesResponse = await repository.fetchThematiques();
    if (thematiquesResponse is GetThematiqueSucceedResponse) {
      emit(ThematiqueSuccessState(_handleThematiques(thematiquesResponse.thematiques)));
    } else {
      emit(ThematiqueErrorState());
    }
  }

  List<ThematiqueViewModel> _handleThematiques(List<Thematique> thematiques) {
    return thematiques
        .map(
          (thematique) => ThematiqueViewModel(
            id: thematique.id,
            picto: thematique.picto,
            label: thematique.label,
            color: thematique.color.toColorInt(),
          ),
        )
        .toList();
  }
}
