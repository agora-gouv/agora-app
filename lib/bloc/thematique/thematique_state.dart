import 'package:agora/bloc/thematique/thematique_view_model.dart';
import 'package:equatable/equatable.dart';

abstract class ThematiqueState extends Equatable {
  @override
  List<Object?> get props => [];
}

class ThematiqueInitialLoadingState extends ThematiqueState {}

class ThematiqueSuccessState extends ThematiqueState {
  final List<ThematiqueViewModel> viewModel;

  ThematiqueSuccessState(this.viewModel);

  @override
  List<Object?> get props => [viewModel];
}

class ThematiqueErrorState extends ThematiqueState {}
