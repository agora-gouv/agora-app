import 'package:agora/domain/consultation/questions/responses/consultation_question_response.dart';

class ConsultationQuestionsResponsesBuilder {
  static List<ConsultationQuestionResponses> build({
    required List<String> questionsStack,
    required List<ConsultationQuestionResponses> questionsResponses,
  }) {
    final filteredQuestionResponses = [...questionsResponses];
    filteredQuestionResponses.removeWhere((item) => !questionsStack.contains(item.questionId));
    return filteredQuestionResponses;
  }
}
