import 'package:equatable/equatable.dart';

abstract class ThematiqueEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class FetchThematiqueEvent extends ThematiqueEvent {}
