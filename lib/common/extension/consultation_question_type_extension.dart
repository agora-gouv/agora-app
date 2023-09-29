import 'package:agora/domain/consultation/questions/consultation_question_type.dart';

extension ConsultationQuestionTypeExtension on String {
  ConsultationQuestionType toConsultationQuestionType() {
    switch (this) {
      case "unique":
        return ConsultationQuestionType.unique;
      case "multiple":
        return ConsultationQuestionType.multiple;
      case "ouverte":
        return ConsultationQuestionType.ouverte;
      default:
        throw Exception("Question type doesn't exist: $this}");
    }
  }
}
