import 'package:agora/bloc/qag/qag_view_model.dart';
import 'package:equatable/equatable.dart';

abstract class QagSearchState extends Equatable {
  @override
  List<Object?> get props => [];
}

class QagSearchInitialState extends QagSearchState {}

class QagSearchLoadingState extends QagSearchState {}

class QagSearchLoadedState extends QagSearchState {
  final List<QagViewModel> qagViewModels;

  QagSearchLoadedState({
    required this.qagViewModels,
  });
}

class QagSearchErrorState extends QagSearchState {}
