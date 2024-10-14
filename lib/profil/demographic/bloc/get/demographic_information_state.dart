import 'package:agora/common/helper/all_purpose_status.dart';
import 'package:agora/profil/demographic/domain/demographic_information.dart';
import 'package:agora/territorialisation/territoire.dart';
import 'package:equatable/equatable.dart';

class DemographicInformationState extends Equatable {
  final AllPurposeStatus status;
  final List<DemographicInformation> demographicInformationResponse;
  final List<Territoire> referentiel;

  DemographicInformationState({
    required this.status,
    required this.demographicInformationResponse,
    required this.referentiel,
  });

  DemographicInformationState.init()
      : status = AllPurposeStatus.loading,
        demographicInformationResponse = [],
        referentiel = [];

  DemographicInformationState clone({
    AllPurposeStatus? status,
    List<DemographicInformation>? demographicInformationResponse,
    List<Territoire>? referentiel,
  }) {
    return DemographicInformationState(
      status: status ?? this.status,
      demographicInformationResponse: demographicInformationResponse ?? this.demographicInformationResponse,
      referentiel: referentiel ?? this.referentiel,
    );
  }

  @override
  List<Object> get props => [status, demographicInformationResponse, referentiel];
}
