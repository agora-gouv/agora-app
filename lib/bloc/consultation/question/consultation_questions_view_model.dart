import 'package:agora/domain/consultation/questions/consultation_question_type.dart';
import 'package:equatable/equatable.dart';

class ConsultationQuestionViewModel extends Equatable {
  final String id;
  final String label;
  final int order;
  final ConsultationQuestionType type;
  final int? maxChoices;
  final List<ConsultationQuestionResponseChoiceViewModel> responseChoicesViewModels;

  ConsultationQuestionViewModel({
    required this.id,
    required this.label,
    required this.order,
    required this.type,
    required this.maxChoices,
    required this.responseChoicesViewModels,
  });

  @override
  List<Object?> get props => [
        id,
        label,
        order,
        type,
        maxChoices,
        responseChoicesViewModels,
      ];
}

class ConsultationQuestionResponseChoiceViewModel extends Equatable {
  final String id;
  final String label;
  final int order;

  ConsultationQuestionResponseChoiceViewModel({
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
