import 'package:agora/domain/qag/qags_error_type.dart';
import 'package:equatable/equatable.dart';

sealed class AskQagState extends Equatable {
  @override
  List<Object?> get props => [];
}

class AskQagInitialLoadingState extends AskQagState {}

class QagAskFetchedState extends AskQagState {
  final String? askQagError;

  QagAskFetchedState({required this.askQagError});

  @override
  List<Object?> get props => [askQagError];
}

class AskQagErrorState extends AskQagState {
  final QagsErrorType errorType;

  AskQagErrorState({this.errorType = QagsErrorType.generic});

  @override
  List<Object> get props => [errorType];
}
