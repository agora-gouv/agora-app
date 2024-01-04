import 'package:agora/bloc/demographic/get/demographic_information_event.dart';
import 'package:agora/bloc/demographic/get/demographic_information_state.dart';
import 'package:agora/domain/demographic/demographic_information.dart';
import 'package:agora/infrastructure/demographic/demographic_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DemographicInformationBloc extends Bloc<DemographicInformationEvent, DemographicInformationState> {
  final DemographicRepository demographicRepository;

  DemographicInformationBloc({required this.demographicRepository})
      : super(GetDemographicInformationInitialLoadingState()) {
    on<GetDemographicInformationEvent>(_handleGetDemographicResponses);
    on<RemoveDemographicInformationEvent>(_handleRemoveDemographicInformation);
  }

  Future<void> _handleGetDemographicResponses(
    GetDemographicInformationEvent event,
    Emitter<DemographicInformationState> emit,
  ) async {
    final response = await demographicRepository.getDemographicResponses();
    if (response is GetDemographicInformationSucceedResponse) {
      emit(GetDemographicInformationSuccessState(demographicInformationResponse: response.demographicInformations));
    } else {
      emit(GetDemographicInformationFailureState());
    }
  }

  Future<void> _handleRemoveDemographicInformation(
    RemoveDemographicInformationEvent event,
    Emitter<DemographicInformationState> emit,
  ) async {
    final currentState = state;
    if (currentState is GetDemographicInformationSuccessState) {
      final emptyList = currentState.demographicInformationResponse.map(
        (e) => DemographicInformation(demographicType: e.demographicType, data: null),
      ).toList();
      emit(GetDemographicInformationSuccessState(demographicInformationResponse: emptyList));
    }
  }
}
