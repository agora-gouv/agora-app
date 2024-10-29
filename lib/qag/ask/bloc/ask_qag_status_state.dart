import 'package:agora/common/helper/all_purpose_status.dart';
import 'package:agora/qag/domain/qags_error_type.dart';
import 'package:equatable/equatable.dart';
import 'package:optional/optional.dart';

class AskQagStatusState extends Equatable {
  final AllPurposeStatus status;
  final String? askQagError;
  final QagsErrorType errorType;

  AskQagStatusState({required this.status, required this.askQagError, required this.errorType});

  AskQagStatusState.init()
      : status = AllPurposeStatus.notLoaded,
        askQagError = null,
        errorType = QagsErrorType.generic;

  AskQagStatusState clone({
    AllPurposeStatus? status,
    Optional<String>? askQagErrorOptional,
    QagsErrorType? errorType,
  }) {
    return AskQagStatusState(
      status: status ?? this.status,
      askQagError: askQagErrorOptional != null ? askQagErrorOptional.orElseNullable(null) : askQagError,
      errorType: errorType ?? this.errorType,
    );
  }

  @override
  List<Object?> get props => [status, askQagError, errorType];
}
