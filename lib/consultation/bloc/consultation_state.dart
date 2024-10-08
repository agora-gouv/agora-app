import 'package:agora/consultation/bloc/consultation_view_model.dart';
import 'package:agora/consultation/domain/consultations_error_type.dart';
import 'package:equatable/equatable.dart';

sealed class ConsultationState extends Equatable {
  @override
  List<Object?> get props => [];
}

class ConsultationInitialLoadingState extends ConsultationState {}

class ConsultationsFetchedState extends ConsultationState {
  final List<ConsultationOngoingViewModel> ongoingViewModels;
  final List<ConsultationViewModel> finishedViewModels;
  final List<ConsultationAnsweredViewModel> answeredViewModels;
  final bool shouldDisplayFinishedAllButton;

  ConsultationsFetchedState({
    required this.ongoingViewModels,
    required this.finishedViewModels,
    required this.answeredViewModels,
    required this.shouldDisplayFinishedAllButton,
  });

  @override
  List<Object> get props => [
        ongoingViewModels,
        finishedViewModels,
        answeredViewModels,
        shouldDisplayFinishedAllButton,
      ];
}

class ConsultationErrorState extends ConsultationState {
  final ConsultationsErrorType errorType;

  ConsultationErrorState({required this.errorType});

  @override
  List<Object?> get props => [errorType];
}
