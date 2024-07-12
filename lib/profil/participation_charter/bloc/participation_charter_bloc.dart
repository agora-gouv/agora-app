import 'package:agora/profil/participation_charter/bloc/participation_charter_event.dart';
import 'package:agora/profil/participation_charter/bloc/participation_charter_state.dart';
import 'package:agora/profil/participation_charter/repository/participation_charter_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PartcipationCharterBloc extends Bloc<GetParticipationCharterEvent, ParticipationCharterState> {
  final ParticipationCharterRepository repository;

  PartcipationCharterBloc({required this.repository}) : super(GetParticipationCharterLoadingState()) {
    on<GetParticipationCharterEvent>(_handleGetParticipationCharterResponse);
  }

  Future<void> _handleGetParticipationCharterResponse(
    GetParticipationCharterEvent event,
    Emitter<ParticipationCharterState> emit,
  ) async {
    emit(GetParticipationCharterLoadingState());
    final response = await repository.getParticipationCharterResponse();

    if (response is GetParticipationCharterSucceedResponse) {
      emit(GetParticipationCharterLoadedState(extraText: response.extraText));
    } else {
      emit(GetParticipationCharterFailureState());
    }
  }
}
