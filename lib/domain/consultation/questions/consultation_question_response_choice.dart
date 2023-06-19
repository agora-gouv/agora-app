import 'package:equatable/equatable.dart';

class ConsultationQuestionResponseChoice extends Equatable {
  final String id;
  final String label;
  final int order;

  ConsultationQuestionResponseChoice({
    required this.id,
    required this.label,
    required this.order,
  });

  @override
  List<Object> get props => [
        id,
        label,
        order,
      ];
}

class ConsultationQuestionResponseWithConditionChoice extends Equatable {
  final String id;
  final String label;
  final int order;
  final String nextQuestionId;

  ConsultationQuestionResponseWithConditionChoice({
    required this.id,
    required this.label,
    required this.order,
    required this.nextQuestionId,
  });

  @override
  List<Object> get props => [
        id,
        label,
        order,
        nextQuestionId,
      ];
}
