import 'package:agora/domain/consultation/questions/responses/consultation_question_response.dart';
import 'package:agora/domain/consultation/summary/consultation_summary_results.dart';

class ConsultationResponsesMapper {
  static List<ConsultationSummaryResults> toConsultationSummaryResults({
    required List<dynamic> uniqueChoiceResults,
    required List<dynamic> multipleChoicesResults,
    required List<ConsultationQuestionResponses> userResponses,
    required List<dynamic> questionWithOpenChoiceResults,
  }) {
    final List<ConsultationSummaryResults> uniqueChoices = [];
    for (final uniqueChoiceResult in uniqueChoiceResults) {
      final questionId = uniqueChoiceResult["questionId"] as String;
      uniqueChoices.add(
        ConsultationSummaryUniqueChoiceResults(
          questionTitle: uniqueChoiceResult["questionTitle"] as String,
          order: uniqueChoiceResult["order"] as int,
          seenRatio: uniqueChoiceResult["seenRatio"] as int,
          responses: _buildSummaryResponses(uniqueChoiceResult, userResponses, questionId),
        ),
      );
    }

    final List<ConsultationSummaryResults> multipleChoices = [];
    for (final multipleChoicesResult in multipleChoicesResults) {
      final questionId = multipleChoicesResult["questionId"] as String;
      multipleChoices.add(
        ConsultationSummaryMultipleChoicesResults(
          questionTitle: multipleChoicesResult["questionTitle"] as String,
          order: multipleChoicesResult["order"] as int,
          seenRatio: multipleChoicesResult["seenRatio"] as int,
          responses: _buildSummaryResponses(multipleChoicesResult, userResponses, questionId),
        ),
      );
    }

    final List<ConsultationSummaryResults> questionsWithOpenChoices = [];
    for (final questionWithOpenChoiceResult in questionWithOpenChoiceResults) {
      questionsWithOpenChoices.add(
        ConsultationSummaryOpenResults(
          questionTitle: questionWithOpenChoiceResult["questionTitle"] as String,
          order: questionWithOpenChoiceResult["order"] as int,
        ),
      );
    }
    final summaryResults = uniqueChoices + multipleChoices + questionsWithOpenChoices;
    summaryResults.sort((a, b) => a.order.compareTo(b.order));
    return summaryResults;
  }

  static List<ConsultationSummaryResponse> _buildSummaryResponses(
    multipleChoicesResult,
    List<ConsultationQuestionResponses> userResponses,
    String questionId,
  ) {
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
