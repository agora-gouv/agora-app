import 'package:agora/bloc/consultation/consultation_view_model.dart';
import 'package:equatable/equatable.dart';

abstract class ConsultationState extends Equatable {
  @override
  List<Object?> get props => [];
}

class ConsultationInitialLoadingState extends ConsultationState {}

class ConsultationsFetchedState extends ConsultationState {
  final List<ConsultationOngoingViewModel> ongoingViewModels;

  ConsultationsFetchedState(this.ongoingViewModels);

  @override
  List<Object> get props => [ongoingViewModels];
}

class ConsultationEmptyState extends ConsultationState {}

class ConsultationErrorState extends ConsultationState {}
