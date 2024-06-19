import 'package:agora/bloc/thematique/thematique_with_id_view_model.dart';
import 'package:equatable/equatable.dart';

sealed class ThematiqueState extends Equatable {
  @override
  List<Object?> get props => [];
}

class ThematiqueInitialLoadingState extends ThematiqueState {}

class ThematiqueSuccessState extends ThematiqueState {
  final List<ThematiqueWithIdViewModel> thematiqueViewModels;

  ThematiqueSuccessState(this.thematiqueViewModels);

  @override
  List<Object?> get props => [thematiqueViewModels];
}

class ThematiqueErrorState extends ThematiqueState {}
