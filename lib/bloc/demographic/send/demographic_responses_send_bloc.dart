import 'package:agora/bloc/demographic/send/demographic_responses_send_event.dart';
import 'package:agora/bloc/demographic/send/demographic_responses_send_state.dart';
import 'package:agora/infrastructure/demographic/demographic_repository.dart';
import 'package:agora/infrastructure/profile/profile_demographic_storage_client.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SendDemographicResponsesBloc extends Bloc<SendDemographicResponsesEvent, SendDemographicResponsesState> {
  final DemographicRepository demographicRepository;
  final ProfileDemographicStorageClient profileDemographicStorageClient;

  SendDemographicResponsesBloc({required this.demographicRepository, required this.profileDemographicStorageClient})
      : super(SendDemographicResponsesInitialLoadingState()) {
    on<SendDemographicResponsesEvent>(_handleSendDemographicResponses);
  }

  Future<void> _handleSendDemographicResponses(
    SendDemographicResponsesEvent event,
    Emitter<SendDemographicResponsesState> emit,
  ) async {
    final response = await demographicRepository.sendDemographicResponses(
      demographicResponses: event.demographicResponses,
    );
    if (response is SendDemographicResponsesSucceedResponse) {
      profileDemographicStorageClient.save(false);
      emit(SendDemographicResponsesSuccessState());
    } else {
      emit(SendDemographicResponsesFailureState());
    }
  }
}
