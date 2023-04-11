import 'package:agora/bloc/consultation/summary/consultation_summary_view_model.dart';
import 'package:agora/common/extension/string_extension.dart';
import 'package:agora/common/strings/consultation_strings.dart';
import 'package:agora/domain/consultation/summary/consultation_summary.dart';

class ConsultationSummaryPresenter {
  static ConsultationSummaryViewModel present(ConsultationSummary consultationSummary) {
    return ConsultationSummaryViewModel(
      title: consultationSummary.title,
      participantCount: ConsultationStrings.participantCount.format(consultationSummary.participantCount.toString()),
      results: consultationSummary.results
          .map(
            (result) => ConsultationSummaryResultsViewModel(
              questionTitle: result.questionTitle,
              responses: result.responses
                  .map(
                    (response) => ConsultationSummaryResponseViewModel(
                      label: response.label,
                      ratio: response.ratio,
                    ),
                  )
                  .toList(),
            ),
          )
          .toList(),
      etEnsuite: ConsultationSummaryEtEnsuiteViewModel(
        step: consultationSummary.etEnsuite.step,
        description: consultationSummary.etEnsuite.description,
      ),
    );
  }
}
