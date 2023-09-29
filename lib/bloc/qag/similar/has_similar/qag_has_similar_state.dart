import 'package:equatable/equatable.dart';

sealed class QagHasSimilarState extends Equatable {
  @override
  List<Object> get props => [];
}

class QagHasSimilarInitialState extends QagHasSimilarState {}

class QagHasSimilarLoadingState extends QagHasSimilarState {}

class QagHasSimilarSuccessState extends QagHasSimilarState {
  final bool hasSimilar;

  QagHasSimilarSuccessState({required this.hasSimilar});

  @override
  List<Object> get props => [hasSimilar];
}

class QagHasSimilarErrorState extends QagHasSimilarState {}
