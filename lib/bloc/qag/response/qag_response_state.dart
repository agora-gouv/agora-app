import 'package:agora/bloc/qag/qag_view_model.dart';
import 'package:equatable/equatable.dart';

abstract class QagResponseState extends Equatable {
  @override
  List<Object> get props => [];
}

class QagResponseInitialLoadingState extends QagResponseState {}

class QagResponseFetchedState extends QagResponseState {
  final List<QagResponseTypeViewModel> qagResponseViewModels;

  QagResponseFetchedState({required this.qagResponseViewModels});

  @override
  List<Object> get props => [qagResponseViewModels];
}

class QagResponseErrorState extends QagResponseState {}
