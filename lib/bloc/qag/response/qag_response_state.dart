import 'package:agora/bloc/qag/response/qag_response_view_model.dart';
import 'package:equatable/equatable.dart';

sealed class QagResponseState extends Equatable {
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
