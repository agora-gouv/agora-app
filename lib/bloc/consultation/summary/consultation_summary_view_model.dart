import 'package:equatable/equatable.dart';

class ConsultationSummaryViewModel extends Equatable {
  final String title;
  final String participantCount;
  final List<ConsultationSummaryResultsViewModel> results;
  final ConsultationSummaryEtEnsuiteViewModel etEnsuite;

  ConsultationSummaryViewModel({
    required this.title,
    required this.participantCount,
    required this.results,
    required this.etEnsuite,
  });

  @override
  List<Object?> get props => [
        title,
        participantCount,
        results,
        etEnsuite,
      ];
}

class ConsultationSummaryResultsViewModel extends Equatable {
  final String questionTitle;
  final List<ConsultationSummaryResponseViewModel> responses;

  ConsultationSummaryResultsViewModel({
    required this.questionTitle,
    required this.responses,
  });

  @override
  List<Object> get props => [questionTitle, responses];
}

class ConsultationSummaryResponseViewModel extends Equatable {
  final String label;
  final int ratio;

  ConsultationSummaryResponseViewModel({
    required this.label,
    required this.ratio,
  });

  @override
  List<Object> get props => [label, ratio];
}

class ConsultationSummaryEtEnsuiteViewModel extends Equatable {
  final int step;
  final String description;

  ConsultationSummaryEtEnsuiteViewModel({
    required this.step,
    required this.description,
  });

  @override
  List<Object> get props => [step, description];
}
