import 'package:agora/common/helper/all_purpose_status.dart';
import 'package:equatable/equatable.dart';

class ReponseInfoState extends Equatable {
  final AllPurposeStatus status;
  final String infoText;

  ReponseInfoState({required this.status, required this.infoText});

  ReponseInfoState.init()
      : status = AllPurposeStatus.loading,
        infoText = "";

  ReponseInfoState clone({AllPurposeStatus? status, String? infoText}) {
    return ReponseInfoState(
      status: status ?? this.status,
      infoText: infoText ?? this.infoText,
    );
  }

  @override
  List<Object?> get props => [status, infoText];
}
