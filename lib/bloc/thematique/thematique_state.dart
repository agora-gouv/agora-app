import 'package:equatable/equatable.dart';

abstract class ThematiqueState extends Equatable {
  @override
  List<Object?> get props => [];
}

class ThematiqueInitialState extends ThematiqueState {}

class ThematiqueSuccessState extends ThematiqueState {
  final List<ThematiqueViewModel> viewModel;

  ThematiqueSuccessState(this.viewModel);
}

class ThematiqueErrorState extends ThematiqueState {}

class ThematiqueViewModel extends Equatable {
  final int id;
  final String picto;
  final String label;
  final int color;

  ThematiqueViewModel({required this.id, required this.picto, required this.label, required this.color});

  @override
  List<Object> get props => [id, picto, label, color];
}
