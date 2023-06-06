import 'package:agora/bloc/thematique/thematique_event.dart';
import 'package:agora/bloc/thematique/thematique_state.dart';
import 'package:agora/infrastructure/thematique/thematique_presenter.dart';
import 'package:agora/infrastructure/thematique/thematique_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ThematiqueBloc extends Bloc<FetchThematiqueEvent, ThematiqueState> {
  final ThematiqueRepository repository;

  ThematiqueBloc({required this.repository}) : super(ThematiqueInitialLoadingState()) {
    on<FetchFilterThematiqueEvent>(_handleFetchFilterThematique);
    on<FetchAskQaGThematiqueEvent>(_handleFetchAskQaGThematique);
  }

  Future<void> _handleFetchFilterThematique(FetchFilterThematiqueEvent event, Emitter<ThematiqueState> emit) async {
    final thematiquesResponse = await repository.fetchThematiques();
    if (thematiquesResponse is GetThematiqueSucceedResponse) {
      final thematiqueViewModels = ThematiquePresenter.presentFilterThematique(thematiquesResponse.thematiques);
      emit(ThematiqueSuccessState(thematiqueViewModels));
    } else {
      emit(ThematiqueErrorState());
    }
  }

  Future<void> _handleFetchAskQaGThematique(FetchAskQaGThematiqueEvent event, Emitter<ThematiqueState> emit) async {
    final thematiquesResponse = await repository.fetchThematiques();
    if (thematiquesResponse is GetThematiqueSucceedResponse) {
      final thematiqueViewModels = ThematiquePresenter.presentAskQaGThematique(thematiquesResponse.thematiques);
      emit(ThematiqueSuccessState(thematiqueViewModels));
    } else {
      emit(ThematiqueErrorState());
    }
  }
}
