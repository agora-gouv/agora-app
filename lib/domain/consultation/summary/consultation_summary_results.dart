import 'package:equatable/equatable.dart';

abstract class ConsultationSummaryResults extends Equatable {
  final String questionTitle;
  final int order;

  ConsultationSummaryResults({
    required this.questionTitle,
    required this.order,
  });

  @override
  List<Object> get props => [questionTitle, order];
}

class ConsultationSummaryUniqueChoiceResults extends ConsultationSummaryResults {
  final List<ConsultationSummaryResponse> responses;

  ConsultationSummaryUniqueChoiceResults({
    required super.questionTitle,
    required super.order,
    required this.responses,
  });

  @override
  List<Object> get props => [questionTitle, order, responses];
}

class ConsultationSummaryMultipleChoicesResults extends ConsultationSummaryResults {
  final List<ConsultationSummaryResponse> responses;

  ConsultationSummaryMultipleChoicesResults({
    required super.questionTitle,
    required super.order,
    required this.responses,
  });

  @override
  List<Object> get props => [questionTitle, order, responses];
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
