import 'package:agora/bloc/consultation/consultation_view_model.dart';
import 'package:agora/domain/consultation/consultations_error_type.dart';
import 'package:equatable/equatable.dart';

abstract class ConsultationState extends Equatable {
  @override
  List<Object?> get props => [];
}

class ConsultationInitialLoadingState extends ConsultationState {}

class ConsultationsFetchedState extends ConsultationState {
  final List<ConsultationOngoingViewModel> ongoingViewModels;
  final List<ConsultationFinishedViewModel> finishedViewModels;
  final List<ConsultationAnsweredViewModel> answeredViewModels;

  ConsultationsFetchedState({
    required this.ongoingViewModels,
    required this.finishedViewModels,
    required this.answeredViewModels,
  });

  @override
  List<Object> get props => [
        ongoingViewModels,
        finishedViewModels,
        answeredViewModels,
      ];
}

class ConsultationErrorState extends ConsultationState {
  final ConsultationsErrorType errorType;

  ConsultationErrorState({required this.errorType});

  @override
  List<Object?> get props => [errorType];
}
