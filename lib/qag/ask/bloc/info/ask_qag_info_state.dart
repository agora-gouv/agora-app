import 'package:agora/common/helper/all_purpose_status.dart';
import 'package:equatable/equatable.dart';

class AskQagInfoState extends Equatable {
  final AllPurposeStatus status;
  final String regles;

  AskQagInfoState({required this.status, required this.regles});

  AskQagInfoState.init()
      : status = AllPurposeStatus.notLoaded,
        regles = '';

  AskQagInfoState clone({AllPurposeStatus? status, String? regles}) {
    return AskQagInfoState(
      status: status ?? this.status,
      regles: regles ?? this.regles,
    );
  }

  @override
  List<Object> get props => [status, regles];
}
