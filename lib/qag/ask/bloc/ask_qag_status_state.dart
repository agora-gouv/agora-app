import 'package:agora/qag/domain/qags_error_type.dart';
import 'package:equatable/equatable.dart';

sealed class AskQagStatusState extends Equatable {
  @override
  List<Object?> get props => [];
}

class AskQagInitialLoadingState extends AskQagStatusState {}

class AskQagStatusFetchedState extends AskQagStatusState {
  final String? askQagError;

  AskQagStatusFetchedState({required this.askQagError});

  @override
  List<Object?> get props => [askQagError];
}

class AskQagErrorState extends AskQagStatusState {
  final QagsErrorType errorType;

  AskQagErrorState({this.errorType = QagsErrorType.generic});

  @override
  List<Object> get props => [errorType];
}
