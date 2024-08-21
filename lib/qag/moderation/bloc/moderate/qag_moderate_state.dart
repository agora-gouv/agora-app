import 'package:equatable/equatable.dart';

abstract class QagModerateState extends Equatable {
  @override
  List<Object?> get props => [];
}

class QagModerateInitialState extends QagModerateState {}

class QagModerateLoadingState extends QagModerateState {
  final String qagId;
  final bool isAccept;

  QagModerateLoadingState({required this.qagId, required this.isAccept});

  @override
  List<Object?> get props => [qagId, isAccept];
}

class QagModerateSuccessState extends QagModerateState {
  final String qagId;

  QagModerateSuccessState({required this.qagId});

  @override
  List<Object?> get props => [qagId];
}

class QagModerateErrorState extends QagModerateState {
  final String qagId;

  QagModerateErrorState({required this.qagId});

  @override
  List<Object?> get props => [qagId];
}
