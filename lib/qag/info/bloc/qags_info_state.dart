import 'package:agora/common/helper/all_purpose_status.dart';
import 'package:equatable/equatable.dart';

class QagsInfoState extends Equatable {
  final AllPurposeStatus status;
  final String infoText;

  QagsInfoState({required this.status, required this.infoText});

  QagsInfoState.init()
      : status = AllPurposeStatus.loading,
        infoText = "";

  QagsInfoState clone({AllPurposeStatus? status, String? infoText}) {
    return QagsInfoState(
      status: status ?? this.status,
      infoText: infoText ?? this.infoText,
    );
  }

  @override
  List<Object?> get props => [status, infoText];
}
