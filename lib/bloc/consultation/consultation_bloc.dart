import 'package:agora/bloc/consultation/consultation_event.dart';
import 'package:agora/bloc/consultation/consultation_state.dart';
import 'package:agora/infrastructure/consultation/consultation_presenter.dart';
import 'package:agora/infrastructure/consultation/repository/consultation_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ConsultationBloc extends Bloc<FetchConsultationsEvent, ConsultationState> {
  final ConsultationRepository consultationRepository;

  ConsultationBloc({
    required this.consultationRepository,
  }) : super(ConsultationInitialLoadingState()) {
    on<FetchConsultationsEvent>(_handleConsultations);
  }

  Future<void> _handleConsultations(
    FetchConsultationsEvent event,
    Emitter<ConsultationState> emit,
  ) async {
    final response = await consultationRepository.fetchConsultations();
    if (response is GetConsultationsSucceedResponse) {
      final ongoingViewModels = ConsultationPresenter.presentOngoingConsultations(response.ongoingConsultations);
      final finishedViewModels = ConsultationPresenter.presentFinishedConsultations(
        response.ongoingConsultations,
        response.finishedConsultations,
      );
      final answeredViewModels = ConsultationPresenter.presentAnsweredConsultations(response.answeredConsultations);
      emit(
        ConsultationsFetchedState(
          ongoingViewModels: ongoingViewModels,
          finishedViewModels: finishedViewModels,
          answeredViewModels: answeredViewModels,
        ),
      );
    } else {
      emit(ConsultationErrorState());
    }
  }
}
