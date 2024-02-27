part of 'dynamic_consultation_results_page.dart';

class _Presenter {
  static _ViewModel getViewModelFromState(DynamicConsultationResultsState state) {
    return switch (state) {
      DynamicConsultationResultsLoadingState() => _LoadingViewModel(),
      DynamicConsultationResultsErrorState() => _ErrorViewModel(),
      DynamicConsultationResultsSuccessState() => _presentSuccess(state),
    };
  }

  static _SuccessViewModel _presentSuccess(DynamicConsultationResultsSuccessState state) {
    return _SuccessViewModel(
      participantCount: state.participantCount,
      results: state.results
          .map((consultationResult) {
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
              return null;
            }
          })
          .nonNulls
          .toList(),
    );
  }

  static List<ConsultationSummaryResponseViewModel> _buildResponses(List<ConsultationSummaryResponse> responses) {
    return responses
        .map(
          (response) => ConsultationSummaryResponseViewModel(
            label: response.label,
            ratio: response.ratio,
            isUserResponse: response.isUserResponse,
          ),
        )
        .toList()
      ..sort((viewModel1, viewModel2) => viewModel2.ratio.compareTo(viewModel1.ratio));
  }
}
