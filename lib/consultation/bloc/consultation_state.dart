import 'package:agora/common/helper/all_purpose_status.dart';
import 'package:agora/consultation/bloc/consultation_view_model.dart';
import 'package:agora/consultation/domain/consultations_error_type.dart';
import 'package:equatable/equatable.dart';
import 'package:optional/optional.dart';

class ConsultationState extends Equatable {
  final AllPurposeStatus status;
  final List<ConsultationOngoingViewModel> ongoingViewModels;
  final List<ConsultationViewModel> finishedViewModels;
  final List<ConsultationAnsweredViewModel> answeredViewModels;
  final bool shouldDisplayFinishedAllButton;
  final ConsultationsErrorType? errorType;

  ConsultationState({
    required this.status,
    required this.ongoingViewModels,
    required this.finishedViewModels,
    required this.answeredViewModels,
    required this.shouldDisplayFinishedAllButton,
    this.errorType,
  });

  ConsultationState.init(this.status)
      : ongoingViewModels = [],
        finishedViewModels = [],
        answeredViewModels = [],
        shouldDisplayFinishedAllButton = false,
        errorType = null;

  ConsultationState clone({
    AllPurposeStatus? status,
    List<ConsultationOngoingViewModel>? ongoingViewModels,
    List<ConsultationViewModel>? finishedViewModels,
    List<ConsultationAnsweredViewModel>? answeredViewModels,
    bool? shouldDisplayFinishedAllButton,
    Optional<ConsultationsErrorType>? errorTypeOptional,
  }) {
    return ConsultationState(
      status: status ?? this.status,
      ongoingViewModels: ongoingViewModels ?? this.ongoingViewModels,
      finishedViewModels: finishedViewModels ?? this.finishedViewModels,
      answeredViewModels: answeredViewModels ?? this.answeredViewModels,
      shouldDisplayFinishedAllButton: shouldDisplayFinishedAllButton ?? this.shouldDisplayFinishedAllButton,
      errorType: errorTypeOptional != null ? errorTypeOptional.orElseNullable(null) : errorType,
    );
  }

  @override
  List<Object?> get props => [
        status,
        ongoingViewModels,
        finishedViewModels,
        answeredViewModels,
        shouldDisplayFinishedAllButton,
        errorType,
      ];
}
