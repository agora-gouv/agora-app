import 'package:agora/domain/consultation/summary/consultation_summary_et_ensuite.dart';
import 'package:agora/domain/consultation/summary/consultation_summary_presentation.dart';
import 'package:agora/domain/consultation/summary/consultation_summary_results.dart';
import 'package:equatable/equatable.dart';

class ConsultationSummary extends Equatable {
  final String title;
  final int participantCount;
  final List<ConsultationSummaryResults> results;
  final ConsultationSummaryEtEnsuite etEnsuite;
  final ConsultationSummaryPresentation presentation;

  ConsultationSummary({
    required this.title,
    required this.participantCount,
    required this.results,
    required this.etEnsuite,
    required this.presentation,
  });

  @override
  List<Object> get props => [
        title,
        participantCount,
        results,
        etEnsuite,
        presentation,
      ];
}
