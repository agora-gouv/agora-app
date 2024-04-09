part of 'dynamic_consultation_update_page.dart';

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
  final String shareText;
  final String consultationId;
  final List<DynamicViewModelSection> sections;

  _SuccessViewModel({
    required this.consultationId,
    required this.shareText,
    required this.sections,
  });

  @override
  List<Object?> get props => [shareText, consultationId, sections];
}
