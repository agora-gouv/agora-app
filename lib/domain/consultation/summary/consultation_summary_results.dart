import 'package:equatable/equatable.dart';

class ConsultationSummaryResults extends Equatable {
  final String questionTitle;
  final List<ConsultationSummaryResponse> responses;

  ConsultationSummaryResults({
    required this.questionTitle,
    required this.responses,
  });

  @override
  List<Object> get props => [questionTitle, responses];
}

class ConsultationSummaryResponse extends Equatable {
  final String label;
  final int ratio;

  ConsultationSummaryResponse({
    required this.label,
    required this.ratio,
  });

  @override
  List<Object> get props => [label, ratio];
}
