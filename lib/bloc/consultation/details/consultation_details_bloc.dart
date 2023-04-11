import 'package:agora/bloc/consultation/details/consultation_details_event.dart';
import 'package:agora/bloc/consultation/details/consultation_details_state.dart';
import 'package:agora/infrastructure/consultation/consultation_details_presenter.dart';
import 'package:agora/infrastructure/consultation/consultation_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ConsultationDetailsBloc extends Bloc<FetchConsultationDetailsEvent, ConsultationDetailsState> {
  final ConsultationRepository consultationRepository;

  ConsultationDetailsBloc({required this.consultationRepository}) : super(ConsultationDetailsInitialLoadingState()) {
    on<FetchConsultationDetailsEvent>(_handleConsultationDetails);
  }

  Future<void> _handleConsultationDetails(
    FetchConsultationDetailsEvent event,
    Emitter<ConsultationDetailsState> emit,
  ) async {
    final response = await consultationRepository.fetchConsultationDetails(consultationId: event.consultationId);
    if (response is GetConsultationDetailsSucceedResponse) {
      final consultationDetailsViewModel = ConsultationDetailsPresenter.present(response.consultationDetails);
      emit(ConsultationDetailsFetchedState(consultationDetailsViewModel));
    } else {
      emit(ConsultationDetailsErrorState());
    }
  }
}
