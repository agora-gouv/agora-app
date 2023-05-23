import 'package:agora/bloc/demographic/get/demographic_information_event.dart';
import 'package:agora/bloc/demographic/get/demographic_information_state.dart';
import 'package:agora/infrastructure/demographic/demographic_information_presenter.dart';
import 'package:agora/infrastructure/demographic/demographic_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DemographicInformationBloc extends Bloc<GetDemographicInformationEvent, DemographicInformationState> {
  final DemographicRepository demographicRepository;

  DemographicInformationBloc({required this.demographicRepository})
      : super(GetDemographicInformationInitialLoadingState()) {
    on<GetDemographicInformationEvent>(_handleGetDemographicResponses);
  }

  Future<void> _handleGetDemographicResponses(
    GetDemographicInformationEvent event,
    Emitter<DemographicInformationState> emit,
  ) async {
    final response = await demographicRepository.getDemographicResponses();
    if (response is GetDemographicInformationSucceedResponse) {
      final viewModels = DemographicInformationPresenter.present(response.demographicInformations);
      emit(GetDemographicInformationSuccessState(demographicInformationViewModels: viewModels));
    } else {
      emit(GetDemographicInformationFailureState());
    }
  }
}
