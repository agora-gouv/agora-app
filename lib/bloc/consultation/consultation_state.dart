import 'package:agora/bloc/consultation/consultation_view_model.dart';
import 'package:equatable/equatable.dart';

abstract class ConsultationState extends Equatable {
  @override
  List<Object?> get props => [];
}

class ConsultationInitialLoadingState extends ConsultationState {}

class ConsultationsFetchedState extends ConsultationState {
  final List<ConsultationViewModel> viewModels;

  ConsultationsFetchedState(this.viewModels);

  @override
  List<Object> get props => [viewModels];
}

class ConsultationErrorState extends ConsultationState {}
