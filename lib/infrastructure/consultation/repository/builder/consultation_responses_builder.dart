import 'package:agora/domain/consultation/questions/responses/consultation_question_response.dart';
import 'package:agora/domain/consultation/summary/consultation_summary_results.dart';

class ConsultationResponsesBuilder {
  static List<ConsultationSummaryResults> buildResults({
    required List<dynamic> uniqueChoiceResults,
    required List<dynamic> multipleChoicesResults,
    required List<ConsultationQuestionResponses> userResponses,
    required List<dynamic> questionWithOpenChoiceResults,
  }) {
    final List<ConsultationSummaryResults> uniqueChoices = uniqueChoiceResults.map((uniqueChoiceResult) {
      final questionId = uniqueChoiceResult["questionId"] as String;
      return ConsultationSummaryUniqueChoiceResults(
        questionTitle: uniqueChoiceResult["questionTitle"] as String,
        order: uniqueChoiceResult["order"] as int,
        responses: _buildSummaryResponses(uniqueChoiceResult, userResponses, questionId),
      );
    }).toList();

    final List<ConsultationSummaryResults> multipleChoices = multipleChoicesResults.map((multipleChoicesResult) {
      final questionId = multipleChoicesResult["questionId"] as String;
      return ConsultationSummaryMultipleChoicesResults(
        questionTitle: multipleChoicesResult["questionTitle"] as String,
        order: multipleChoicesResult["order"] as int,
        responses: _buildSummaryResponses(multipleChoicesResult, userResponses, questionId),
      );
    }).toList();

    final List<ConsultationSummaryResults> questionsWithOpenChoice =
        questionWithOpenChoiceResults.map((questionWithOpenChoice) {
      return ConsultationSummaryOpenResults(
        questionTitle: questionWithOpenChoice["questionTitle"] as String,
        order: questionWithOpenChoice["order"] as int,
      );
    }).toList();

    return uniqueChoices + multipleChoices + questionsWithOpenChoice;
  }

  static List<ConsultationSummaryResponse> _buildSummaryResponses(
      multipleChoicesResult, List<ConsultationQuestionResponses> userResponses, String questionId) {
    return (multipleChoicesResult["responses"] as List).map(
      (response) {
        final choiceId = response["choiceId"];
        return ConsultationSummaryResponse(
          label: response["label"] as String,
          ratio: response["ratio"] as int,
          isUserResponse: userResponses
              .any((response) => response.questionId == questionId && response.responseIds.contains(choiceId)),
        );
      },
    ).toList();
  }
}
