import 'package:agora/consultation/question/domain/consultation_question_response.dart';

class ConsultationQuestionsResponsesBuilder {
  static List<ConsultationQuestionResponses> build({
    required List<String> questionIdStack,
    required List<ConsultationQuestionResponses> questionsResponses,
  }) {
    final filteredQuestionResponses = [...questionsResponses];
    filteredQuestionResponses.removeWhere((item) => !questionIdStack.contains(item.questionId));
    return filteredQuestionResponses;
  }
}
