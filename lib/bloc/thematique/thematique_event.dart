import 'package:equatable/equatable.dart';

abstract class FetchThematiqueEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class FetchFilterThematiqueEvent extends FetchThematiqueEvent {}

class FetchAskQaGThematiqueEvent extends FetchThematiqueEvent {}
