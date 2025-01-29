import 'dart:async';

import 'package:agora/common/helper/all_purpose_status.dart';
import 'package:agora/profil/demographic/domain/demographic_question_type.dart';
import 'package:agora/profil/demographic/repository/demographic_repository.dart';
import 'package:agora/profil/territoire/bloc/territoire_info_event.dart';
import 'package:agora/profil/territoire/bloc/territoire_info_state.dart';
import 'package:agora/referentiel/departement.dart';
import 'package:agora/referentiel/repository/referentiel_repository.dart';
import 'package:agora/referentiel/territoire_helper.dart';
import 'package:collection/collection.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TerritoireInfoBloc extends Bloc<TerritoireInfoEvent, TerritoireInfoState> {
  final ReferentielRepository referentielRepository;
  final DemographicRepository demographicRepository;

  TerritoireInfoBloc({
    required this.referentielRepository,
    required this.demographicRepository,
  }) : super(TerritoireInfoState.init()) {
    on<GetTerritoireInfoEvent>(_handleGetTerritoireInfo);
    on<SendTerritoireInfoEvent>(_handleSendTerritoireInfo);
  }

  Future<void> _handleGetTerritoireInfo(GetTerritoireInfoEvent event, Emitter<TerritoireInfoState> emit) async {
    if (state.status == AllPurposeStatus.loading) return;

    emit(state.clone(status: AllPurposeStatus.loading));
    final referentielResponse = await referentielRepository.fetchReferentielRegionsEtDepartements();
    final response = await demographicRepository.getDemographicResponses();
    if (response is GetDemographicInformationSucceedResponse && referentielResponse.isNotEmpty) {
      final premierDepartement = response.demographicInformations.firstWhereOrNull(
        (info) => info.demographicType == DemographicQuestionType.primaryDepartment,
      );
      final secondDepartement = response.demographicInformations.firstWhereOrNull(
        (info) => info.demographicType == DemographicQuestionType.secondaryDepartment,
      );
      final departementsSuivis = [premierDepartement?.data, secondDepartement?.data]
          .nonNulls
          .map((departementLabel) => getTerritoireFromReferentiel(referentielResponse, departementLabel))
          .nonNulls
          .toList();
      final regionsSuivies = departementsSuivis
          .map((departement) => getRegionFromDepartement(departement as Departement, referentielResponse))
          .toList();
      emit(
        state.clone(
          status: AllPurposeStatus.success,
          departementsSuivis: departementsSuivis,
          regionsSuivies: regionsSuivies,
        ),
      );
    } else {
      emit(state.clone(status: AllPurposeStatus.error));
    }
  }

  Future<void> _handleSendTerritoireInfo(SendTerritoireInfoEvent event, Emitter<TerritoireInfoState> emit) async {
    emit(state.clone(status: AllPurposeStatus.loading));
    final departementLabels = event.departementsSuivis.map((departement) => departement.label).toList();
    final response = await demographicRepository.sendTerritoireInfo(departementsSuivis: departementLabels);
    if (response is SendTerritoireInfoRepositoryResponseSuccess) {
      emit(
        state.clone(
          status: AllPurposeStatus.success,
          departementsSuivis: event.departementsSuivis,
          regionsSuivies: event.regionsSuivies,
        ),
      );
    } else {
      emit(state.clone(status: AllPurposeStatus.error));
    }
  }
}
