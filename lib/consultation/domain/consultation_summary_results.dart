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
  final int seenRatio;
  final List<ConsultationSummaryResponse> responses;

  ConsultationSummaryUniqueChoiceResults({
    required super.questionTitle,
    required super.order,
    required this.seenRatio,
    required this.responses,
  });

  @override
  List<Object> get props => [questionTitle, order, seenRatio, responses];
}

class ConsultationSummaryMultipleChoicesResults extends ConsultationSummaryResults {
  final int seenRatio;
  final List<ConsultationSummaryResponse> responses;

  ConsultationSummaryMultipleChoicesResults({
    required super.questionTitle,
    required super.order,
    required this.seenRatio,
    required this.responses,
  });

  @override
  List<Object> get props => [questionTitle, order, seenRatio, responses];
}

class ConsultationSummaryOpenResults extends ConsultationSummaryResults {
  ConsultationSummaryOpenResults({required super.questionTitle, required super.order});
}

class ConsultationSummaryResponse extends Equatable {
  final String label;
  final int ratio;
  final bool isUserResponse;

  ConsultationSummaryResponse({
    required this.label,
    required this.ratio,
    this.isUserResponse = false,
  });

  @override
  List<Object> get props => [label, ratio, isUserResponse];
}
