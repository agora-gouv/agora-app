import 'dart:convert';

import 'package:agora/bloc/consultation/details/consultation_details_action.dart';
import 'package:agora/bloc/consultation/details/consultation_details_state.dart';
import 'package:agora/extension/string_extension.dart';
import 'package:agora/infrastructure/consultation/consultation_repository.dart';
import 'package:agora/string/consultation_strings.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class ConsultationDetailsBloc extends Bloc<FetchConsultationDetailsEvent, ConsultationDetailsState> {
  final ConsultationRepository consultationRepository;

  ConsultationDetailsBloc({required this.consultationRepository}) : super(ConsultationDetailsInitialState()) {
    on<FetchConsultationDetailsEvent>(_handleConsultationDetails);
  }

  Future<void> _handleConsultationDetails(
    FetchConsultationDetailsEvent event,
    Emitter<ConsultationDetailsState> emit,
  ) async {
    emit(ConsultationDetailsLoadingState());
    final response = await consultationRepository.fetchConsultationDetails("1");
    if (response is GetConsultationDetailsSucceedResponse) {
      emit(
        ConsultationDetailsFetchedState(
          ConsultationDetailsViewModel(
            id: response.consultationDetails.id,
            title: response.consultationDetails.title,
            cover: Base64Decoder().convert(response.consultationDetails.cover),
            thematiqueId: response.consultationDetails.thematiqueId,
            endDate: ConsultationString.endDate.format(
              DateFormat("dd MMMM").format(response.consultationDetails.endDate),
            ),
            questionCount: response.consultationDetails.questionCount,
            estimatedTime: response.consultationDetails.estimatedTime,
            participantCount: response.consultationDetails.participantCount,
            participantCountGoal: response.consultationDetails.participantCountGoal,
            participantCountText: ConsultationString.participantCount.format(
              response.consultationDetails.participantCount.toString(),
            ),
            participantCountGoalText: ConsultationString.participantCountGoal.format(
              response.consultationDetails.participantCountGoal.toString(),
            ),
            description: response.consultationDetails.description,
            tipsDescription: response.consultationDetails.tipsDescription,
          ),
        ),
      );
    } else {
      emit(ConsultationDetailsErrorState());
    }
  }
}
