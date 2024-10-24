import 'package:agora/common/helper/all_purpose_status.dart';
import 'package:equatable/equatable.dart';

class QagsInfoState extends Equatable {
  final AllPurposeStatus status;
  final String infoText;
  final String texteTotalQuestions;

  QagsInfoState({required this.status, required this.infoText, required this.texteTotalQuestions});

  QagsInfoState.init()
      : status = AllPurposeStatus.loading,
        infoText = "",
        texteTotalQuestions = "";

  QagsInfoState clone({AllPurposeStatus? status, String? infoText, String? texteTotalQuestions}) {
    return QagsInfoState(
      status: status ?? this.status,
      infoText: infoText ?? this.infoText,
      texteTotalQuestions: texteTotalQuestions ?? this.texteTotalQuestions,
    );
  }

  @override
  List<Object?> get props => [status, infoText, texteTotalQuestions];
}
