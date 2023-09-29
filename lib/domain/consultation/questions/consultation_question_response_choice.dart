import 'package:equatable/equatable.dart';

class ConsultationQuestionResponseChoice extends Equatable {
  final String id;
  final String label;
  final int order;
  final bool hasOpenTextField;

  ConsultationQuestionResponseChoice({
    required this.id,
    required this.label,
    required this.order,
    required this.hasOpenTextField,
  });

  @override
  List<Object> get props => [
        id,
        label,
        order,
        hasOpenTextField,
      ];
}

class ConsultationQuestionResponseWithConditionChoice extends Equatable {
  final String id;
  final String label;
  final int order;
  final String nextQuestionId;
  final bool hasOpenTextField;

  ConsultationQuestionResponseWithConditionChoice({
    required this.id,
    required this.label,
    required this.order,
    required this.nextQuestionId,
    required this.hasOpenTextField,
  });

  @override
  List<Object> get props => [
        id,
        label,
        order,
        nextQuestionId,
        hasOpenTextField,
      ];
}
