import 'package:agora/bloc/consultation/summary/consultation_summary_view_model.dart';
import 'package:equatable/equatable.dart';

abstract class ConsultationSummaryState extends Equatable {
  @override
  List<Object?> get props => [];
}

class ConsultationSummaryInitialLoadingState extends ConsultationSummaryState {}

class ConsultationSummaryFetchedState extends ConsultationSummaryState {
  final ConsultationSummaryViewModel viewModel;

  ConsultationSummaryFetchedState(this.viewModel);

  @override
  List<Object> get props => [viewModel];
}

class ConsultationSummaryErrorState extends ConsultationSummaryState {}
