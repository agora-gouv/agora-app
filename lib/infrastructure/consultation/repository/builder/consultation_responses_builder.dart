import 'package:agora/domain/consultation/questions/responses/consultation_question_response.dart';
import 'package:agora/domain/consultation/summary/consultation_summary_results.dart';

class ConsultationResponsesBuilder {
  static List<ConsultationSummaryResults> buildResults({
    required List<dynamic> uniqueChoiceResults,
    required List<dynamic> multipleChoicesResults,
    required List<ConsultationQuestionResponses> userResponses,
  }) {
    return _buildUniqueChoiceResults(uniqueChoiceResults, userResponses) +
        _buildMultipleChoicesResults(multipleChoicesResults, userResponses);
  }

  static List<ConsultationSummaryResults> _buildUniqueChoiceResults(
    List<dynamic> uniqueChoiceResults,
    List<ConsultationQuestionResponses> userResponses,
  ) {
    final List<ConsultationSummaryResults> results = [];
    for (final uniqueChoiceResult in uniqueChoiceResults) {
      final questionId = uniqueChoiceResult["questionId"] as String;
      results.add(
        ConsultationSummaryUniqueChoiceResults(
          questionTitle: uniqueChoiceResult["questionTitle"] as String,
          order: uniqueChoiceResult["order"] as int,
          responses: (uniqueChoiceResult["responses"] as List).map(
            (response) {
              final choiceId = response["choiceId"];
              return ConsultationSummaryResponse(
                label: response["label"] as String,
                ratio: response["ratio"] as int,
                userResponse: userResponses
                    .any((response) => response.questionId == questionId && response.responseIds.contains(choiceId)),
              );
            },
          ).toList(),
        ),
      );
    }
    return results;
  }

  static List<ConsultationSummaryResults> _buildMultipleChoicesResults(
    List<dynamic> multipleChoicesResults,
    List<ConsultationQuestionResponses> userResponses,
  ) {
    final List<ConsultationSummaryResults> results = [];
    for (final multipleChoicesResult in multipleChoicesResults) {
      final questionId = multipleChoicesResult["questionId"] as String;
      results.add(
        ConsultationSummaryMultipleChoicesResults(
          questionTitle: multipleChoicesResult["questionTitle"] as String,
          order: multipleChoicesResult["order"] as int,
          responses: (multipleChoicesResult["responses"] as List).map(
            (response) {
              final choiceId = response["choiceId"];
              return ConsultationSummaryResponse(
                label: response["label"] as String,
                ratio: response["ratio"] as int,
                userResponse: userResponses
                    .any((response) => response.questionId == questionId && response.responseIds.contains(choiceId)),
              );
            },
          ).toList(),
        ),
      );
    }
    return results;
  }
}
