import 'package:agora/qag/domain/qag_response.dart';
import 'package:equatable/equatable.dart';

sealed class QagResponseState extends Equatable {
  @override
  List<Object> get props => [];
}

class QagResponseInitialLoadingState extends QagResponseState {}

class QagResponseFetchedState extends QagResponseState {
  final List<QagResponseIncoming> incomingQagResponses;
  final List<QagResponse> qagResponses;

  QagResponseFetchedState({
    required this.incomingQagResponses,
    required this.qagResponses,
  });

  @override
  List<Object> get props => [incomingQagResponses, qagResponses];
}

class QagResponseErrorState extends QagResponseState {}
