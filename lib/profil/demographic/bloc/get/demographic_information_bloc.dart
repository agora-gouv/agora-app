import 'package:agora/common/helper/all_purpose_status.dart';
import 'package:agora/profil/demographic/bloc/get/demographic_information_event.dart';
import 'package:agora/profil/demographic/bloc/get/demographic_information_state.dart';
import 'package:agora/profil/demographic/domain/demographic_information.dart';
import 'package:agora/profil/demographic/repository/demographic_repository.dart';
import 'package:agora/referentiel/repository/referentiel_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DemographicInformationBloc extends Bloc<DemographicInformationEvent, DemographicInformationState> {
  final DemographicRepository demographicRepository;
  final ReferentielRepository referentielRepository;

  DemographicInformationBloc({required this.demographicRepository, required this.referentielRepository})
      : super(DemographicInformationState.init()) {
    on<GetDemographicInformationEvent>(_handleGetDemographicResponses);
    on<RemoveDemographicInformationEvent>(_handleRemoveDemographicInformation);
  }

  Future<void> _handleGetDemographicResponses(
    GetDemographicInformationEvent event,
    Emitter<DemographicInformationState> emit,
  ) async {
    emit(state.clone(status: AllPurposeStatus.loading));
    final referentielResponse = await referentielRepository.fetchReferentielRegionsEtDepartements();
    final response = await demographicRepository.getDemographicResponses();
    if (response is GetDemographicInformationSucceedResponse && referentielResponse.isNotEmpty) {
      emit(
        state.clone(
          status: AllPurposeStatus.success,
          demographicInformationResponse: response.demographicInformations,
          referentiel: referentielResponse,
        ),
      );
    } else {
      emit(state.clone(status: AllPurposeStatus.error));
    }
  }

  Future<void> _handleRemoveDemographicInformation(
    RemoveDemographicInformationEvent event,
    Emitter<DemographicInformationState> emit,
  ) async {
    final currentState = state;
    if (state.status == AllPurposeStatus.success) {
      final demographicInformationsWithEmptyData = currentState.demographicInformationResponse
          .map(
            (demographicInformation) => DemographicInformation(
              demographicType: demographicInformation.demographicType,
              data: null,
            ),
          )
          .toList();
      emit(
        state.clone(
          status: AllPurposeStatus.success,
          demographicInformationResponse: demographicInformationsWithEmptyData,
        ),
      );
    }
  }
}
