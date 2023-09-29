import 'package:agora/bloc/consultation/details/consultation_details_view_model.dart';
import 'package:equatable/equatable.dart';

abstract class ConsultationDetailsState extends Equatable {
  @override
  List<Object?> get props => [];
}

class ConsultationDetailsInitialLoadingState extends ConsultationDetailsState {}

class ConsultationDetailsFetchedState extends ConsultationDetailsState {
  final ConsultationDetailsViewModel viewModel;

  ConsultationDetailsFetchedState(this.viewModel);

  @override
  List<Object> get props => [viewModel];
}

class ConsultationDetailsErrorState extends ConsultationDetailsState {}
