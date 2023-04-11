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
        step: ConsultationStrings.step.format(consultationSummary.etEnsuite.step.toString()),
        image: _getImageAsset(consultationSummary.etEnsuite.step),
        title: _buildTitle(consultationSummary.etEnsuite.step),
        description: consultationSummary.etEnsuite.description,
      ),
    );
  }

  static String _buildTitle(int step) {
    switch (step) {
      case 1:
        return ConsultationStrings.step1;
      case 2:
        return ConsultationStrings.step2;
      case 3:
        return ConsultationStrings.step3;
      default:
        throw Exception("Consultation Step not exist");
    }
  }

  static String _getImageAsset(int step) {
    switch (step) {
      case 1:
        return "assets/ic_consultation_step1.png";
      case 2:
        return "assets/ic_consultation_step2.png";
      case 3:
        return "assets/ic_consultation_step3.png";
      default:
        throw Exception("Consultation Step not exist");
    }
  }
}
