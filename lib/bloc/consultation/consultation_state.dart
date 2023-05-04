import 'package:agora/bloc/consultation/consultation_view_model.dart';
import 'package:equatable/equatable.dart';

abstract class ConsultationState extends Equatable {
  @override
  List<Object?> get props => [];
}

class ConsultationInitialLoadingState extends ConsultationState {}

class ConsultationsFetchedState extends ConsultationState {
  final List<ConsultationOngoingViewModel> ongoingViewModels;
  final List<ConsultationFinishedViewModel> finishedViewModels;

  ConsultationsFetchedState({
    required this.ongoingViewModels,
    required this.finishedViewModels,
  });

  @override
  List<Object> get props => [ongoingViewModels, finishedViewModels];
}

class ConsultationErrorState extends ConsultationState {}
