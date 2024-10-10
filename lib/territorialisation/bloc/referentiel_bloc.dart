import 'package:agora/common/helper/all_purpose_status.dart';
import 'package:agora/territorialisation/bloc/referentiel_event.dart';
import 'package:agora/territorialisation/bloc/referentiel_state.dart';
import 'package:agora/territorialisation/repository/referentiel_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ReferentielBloc extends Bloc<ReferentielEvent, ReferentielState> {
  final ReferentielRepository referentielRepository;

  ReferentielBloc({required this.referentielRepository}) : super(ReferentielState.init()) {
    on<FetchReferentielEvent>(_handleFetchReferentiel);
  }

  Future<void> _handleFetchReferentiel(
    FetchReferentielEvent event,
    Emitter<ReferentielState> emit,
  ) async {
    emit(state.clone(status: AllPurposeStatus.loading));
    final response = await referentielRepository.fetchReferentielRegionsEtDepartements();
    if (response.isNotEmpty) {
      emit(
        state.clone(
          status: AllPurposeStatus.success,
          referentiel: response,
        ),
      );
    } else {
      emit(state.clone(status: AllPurposeStatus.error));
    }
  }
}
