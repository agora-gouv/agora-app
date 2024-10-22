import 'package:agora/common/helper/all_purpose_status.dart';
import 'package:agora/referentiel/territoire.dart';
import 'package:equatable/equatable.dart';

class ReferentielState extends Equatable {
  final AllPurposeStatus status;
  final List<Territoire> referentiel;

  ReferentielState({required this.status, required this.referentiel});

  ReferentielState.init()
      : status = AllPurposeStatus.notLoaded,
        referentiel = [];

  ReferentielState clone({AllPurposeStatus? status, List<Territoire>? referentiel}) {
    return ReferentielState(
      status: status ?? this.status,
      referentiel: referentiel ?? this.referentiel,
    );
  }

  @override
  List<Object?> get props => [status, referentiel];
}
