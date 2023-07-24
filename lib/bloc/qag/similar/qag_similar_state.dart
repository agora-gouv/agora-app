import 'package:agora/bloc/qag/similar/qag_similar_view_model.dart';
import 'package:equatable/equatable.dart';

sealed class QagSimilarState extends Equatable {
  @override
  List<Object> get props => [];
}

class QagSimilarInitialState extends QagSimilarState {}

class QagSimilarLoadingState extends QagSimilarState {}

class QagSimilarSuccessState extends QagSimilarState {
  final List<QagSimilarViewModel> similarQags;

  QagSimilarSuccessState({required this.similarQags});

  @override
  List<Object> get props => [similarQags];
}

class QagSimilarErrorState extends QagSimilarState {}
