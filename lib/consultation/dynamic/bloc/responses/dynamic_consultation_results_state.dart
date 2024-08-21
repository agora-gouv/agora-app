import 'package:agora/consultation/domain/consultation_summary_results.dart';
import 'package:equatable/equatable.dart';

sealed class DynamicConsultationResultsState extends Equatable {}

class DynamicConsultationResultsSuccessState extends DynamicConsultationResultsState {
  final int participantCount;
  final String title;
  final String coverUrl;
  final List<ConsultationSummaryResults> results;

  DynamicConsultationResultsSuccessState({
    required this.participantCount,
    required this.results,
    required this.title,
    required this.coverUrl,
  });

  @override
  List<Object?> get props => [participantCount, results, coverUrl, title];
}

class DynamicConsultationResultsErrorState extends DynamicConsultationResultsState {
  @override
  List<Object?> get props => [];
}

class DynamicConsultationResultsLoadingState extends DynamicConsultationResultsState {
  @override
  List<Object?> get props => [];
}
