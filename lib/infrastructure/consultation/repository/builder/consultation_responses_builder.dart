import 'package:agora/domain/consultation/summary/consultation_summary_results.dart';

class ConsultationResponsesBuilder {
  static List<ConsultationSummaryResults> buildResults({
    required List<dynamic> uniqueChoiceResults,
    required List<dynamic> multipleChoicesResults,
  }) {
    return _buildUniqueChoiceResults(uniqueChoiceResults) + _buildMultipleChoicesResults(multipleChoicesResults);
  }

  static List<ConsultationSummaryResults> _buildUniqueChoiceResults(List<dynamic> uniqueChoiceResults) {
    final List<ConsultationSummaryResults> results = [];
    for (final uniqueChoiceResult in uniqueChoiceResults) {
      results.add(
        ConsultationSummaryUniqueChoiceResults(
          questionTitle: uniqueChoiceResult["questionTitle"] as String,
          order: uniqueChoiceResult["order"] as int,
          responses: (uniqueChoiceResult["responses"] as List)
              .map(
                (response) => ConsultationSummaryResponse(
                  label: response["label"] as String,
                  ratio: response["ratio"] as int,
                ),
              )
              .toList(),
        ),
      );
    }
    return results;
  }

  static List<ConsultationSummaryResults> _buildMultipleChoicesResults(List<dynamic> multipleChoicesResults) {
    final List<ConsultationSummaryResults> results = [];
    for (final multipleChoicesResult in multipleChoicesResults) {
      results.add(
        ConsultationSummaryMultipleChoicesResults(
          questionTitle: multipleChoicesResult["questionTitle"] as String,
          order: multipleChoicesResult["order"] as int,
          responses: (multipleChoicesResult["responses"] as List)
              .map(
                (response) => ConsultationSummaryResponse(
                  label: response["label"] as String,
                  ratio: response["ratio"] as int,
                ),
              )
              .toList(),
        ),
      );
    }
    return results;
  }
}
