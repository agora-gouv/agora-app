import 'package:agora/common/helper/all_purpose_status.dart';
import 'package:agora/referentiel/territoire.dart';
import 'package:equatable/equatable.dart';

class TerritoireInfoState extends Equatable {
  final AllPurposeStatus status;
  final List<Territoire> departementsSuivis;
  final List<Territoire> regionsSuivies;

  const TerritoireInfoState({required this.status, required this.departementsSuivis, required this.regionsSuivies});

  TerritoireInfoState.init()
      : status = AllPurposeStatus.notLoaded,
        departementsSuivis = [],
        regionsSuivies = [];

  TerritoireInfoState clone({
    AllPurposeStatus? status,
    List<Territoire>? departementsSuivis,
    List<Territoire>? regionsSuivies,
  }) {
    return TerritoireInfoState(
      status: status ?? this.status,
      departementsSuivis: departementsSuivis ?? this.departementsSuivis,
      regionsSuivies: regionsSuivies ?? this.regionsSuivies,
    );
  }

  @override
  List<Object> get props => [status, departementsSuivis, regionsSuivies];
}
