part of 'dynamic_consultation_results_page.dart';

sealed class _ViewModel extends Equatable {}

class _LoadingViewModel extends _ViewModel {
  @override
  List<Object?> get props => [];
}

class _ErrorViewModel extends _ViewModel {
  @override
  List<Object?> get props => [];
}

class _SuccessViewModel extends _ViewModel {
  final int participantCount;
  final List<ConsultationSummaryResultsViewModel> results;

  _SuccessViewModel({
    required this.participantCount,
    required this.results,
  });

  @override
  List<Object?> get props => [participantCount, results];
}
