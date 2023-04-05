import 'package:agora/domain/consultation/questions/consultation_question_response_choice.dart';
import 'package:agora/domain/consultation/questions/consultation_question_type.dart';
import 'package:equatable/equatable.dart';

class ConsultationQuestion extends Equatable {
  final String id;
  final String label;
  final int order;
  final ConsultationQuestionType type;
  final List<ConsultationQuestionResponseChoice> responseChoices;

  ConsultationQuestion({
    required this.id,
    required this.label,
    required this.order,
    required this.type,
    required this.responseChoices,
  });

  @override
  List<Object> get props => [
        id,
        label,
        order,
        type,
        responseChoices,
      ];
}
