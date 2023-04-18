import 'package:agora/bloc/consultation/summary/consultation_summary_view_model.dart';
import 'package:agora/common/extension/string_extension.dart';
import 'package:agora/common/strings/consultation_strings.dart';
import 'package:agora/domain/consultation/summary/consultation_summary.dart';
import 'package:agora/domain/consultation/summary/consultation_summary_results.dart';

class ConsultationSummaryPresenter {
  static ConsultationSummaryViewModel present(ConsultationSummary consultationSummary) {
    return ConsultationSummaryViewModel(
      title: consultationSummary.title,
      participantCount: ConsultationStrings.participantCount.format(consultationSummary.participantCount.toString()),
      results: consultationSummary.results.map(
        (consultationResult) {
          if (consultationResult is ConsultationSummaryUniqueChoiceResults) {
            return ConsultationSummaryUniqueChoiceResultsViewModel(
              questionTitle: consultationResult.questionTitle,
              order: consultationResult.order,
              responses: _buildResponses(consultationResult.responses),
            );
          } else if (consultationResult is ConsultationSummaryMultipleChoicesResults) {
            return ConsultationSummaryMultipleChoicesResultsViewModel(
              questionTitle: consultationResult.questionTitle,
              order: consultationResult.order,
              responses: _buildResponses(consultationResult.responses),
            );
          } else {
            throw Exception(
              "ConsultationSummaryPresenter : convert failed, type ${consultationResult.runtimeType} not handle",
            );
          }
        },
      ).toList()
        ..sort((viewModel1, viewModel2) => viewModel1.order.compareTo(viewModel2.order)),
      etEnsuite: ConsultationSummaryEtEnsuiteViewModel(
        step: ConsultationStrings.step.format(consultationSummary.etEnsuite.step.toString()),
        image: _getImageAsset(consultationSummary.etEnsuite.step),
        title: _buildTitle(consultationSummary.etEnsuite.step),
        description: consultationSummary.etEnsuite.description,
      ),
    );
  }

  static List<ConsultationSummaryResponseViewModel> _buildResponses(List<ConsultationSummaryResponse> responses) {
    return responses
        .map(
          (response) => ConsultationSummaryResponseViewModel(
            label: response.label,
            ratio: response.ratio,
          ),
        )
        .toList()
      ..sort((viewModel1, viewModel2) => viewModel2.ratio.compareTo(viewModel1.ratio));
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
