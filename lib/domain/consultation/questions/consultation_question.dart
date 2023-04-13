import 'package:agora/domain/consultation/questions/consultation_question_response_choice.dart';
import 'package:agora/domain/consultation/questions/consultation_question_type.dart';
import 'package:equatable/equatable.dart';

class ConsultationQuestion extends Equatable {
  final String id;
  final String label;
  final int order;
  final ConsultationQuestionType type;
  final int? maxChoices;
  final List<ConsultationQuestionResponseChoice> responseChoices;

  ConsultationQuestion({
    required this.id,
    required this.label,
    required this.order,
    required this.type,
    required this.maxChoices,
    required this.responseChoices,
  });

  @override
  List<Object?> get props => [
        id,
        label,
        order,
        type,
        maxChoices,
        responseChoices,
      ];
}
