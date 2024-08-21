import 'package:agora/profil/demographic/bloc/get/demographic_information_event.dart';
import 'package:agora/profil/demographic/bloc/get/demographic_information_state.dart';
import 'package:agora/profil/demographic/domain/demographic_information.dart';
import 'package:agora/profil/demographic/repository/demographic_repository.dart';
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
    emit(GetDemographicInformationInitialLoadingState());
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
      final demographicInformationsWithEmptyData = currentState.demographicInformationResponse
          .map(
            (demographicInformation) => DemographicInformation(
              demographicType: demographicInformation.demographicType,
              data: null,
            ),
          )
          .toList();
      emit(GetDemographicInformationSuccessState(demographicInformationResponse: demographicInformationsWithEmptyData));
    }
  }
}
