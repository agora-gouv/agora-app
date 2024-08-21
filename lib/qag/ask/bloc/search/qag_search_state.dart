import 'package:agora/qag/domain/qag.dart';
import 'package:equatable/equatable.dart';

abstract class QagSearchState extends Equatable {
  @override
  List<Object?> get props => [];
}

class QagSearchInitialState extends QagSearchState {}

class QagSearchLoadingState extends QagSearchState {}

class QagSearchLoadedState extends QagSearchState {
  final List<Qag> qags;

  QagSearchLoadedState({
    required this.qags,
  });

  @override
  List<Object?> get props => [qags];
}

class QagSearchErrorState extends QagSearchState {}
