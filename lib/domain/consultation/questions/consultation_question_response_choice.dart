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
