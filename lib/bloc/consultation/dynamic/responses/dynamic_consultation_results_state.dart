import 'package:agora/domain/consultation/summary/consultation_summary_results.dart';
import 'package:equatable/equatable.dart';

sealed class DynamicConsultationResultsState extends Equatable {}

class DynamicConsultationResultsSuccessState extends DynamicConsultationResultsState {
  final int participantCount;
  final List<ConsultationSummaryResults> results;

  DynamicConsultationResultsSuccessState({
    required this.participantCount,
    required this.results,
  });

  @override
  List<Object?> get props => [participantCount, results];
}

class DynamicConsultationResultsErrorState extends DynamicConsultationResultsState {
  @override
  List<Object?> get props => [];
}

class DynamicConsultationResultsLoadingState extends DynamicConsultationResultsState {
  @override
  List<Object?> get props => [];
}
