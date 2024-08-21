import 'package:agora/profil/demographic/bloc/stock/demographic_responses_stock_event.dart';
import 'package:agora/profil/demographic/bloc/stock/demographic_responses_stock_state.dart';
import 'package:agora/profil/demographic/domain/demographic_response.dart';
import 'package:agora/profil/demographic/pages/demographic_question_page.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DemographicResponsesStockBloc extends Bloc<DemographicResponseStockEvent, DemographicResponsesStockState> {
  DemographicResponsesStockBloc([DemographicQuestionArguments? arguments])
      : super(DemographicResponsesStockState(responses: _mapArguments(arguments))) {
    on<AddDemographicResponseStockEvent>(_handleAddDemographicStockResponse);
    on<DeleteDemographicResponseStockEvent>(_handleDeleteDemographicStockResponse);
  }

  Future<void> _handleAddDemographicStockResponse(
    AddDemographicResponseStockEvent event,
    Emitter<DemographicResponsesStockState> emit,
  ) async {
    final responses = [...state.responses];
    responses.removeWhere((response) => response.demographicType == event.response.demographicType);
    responses.add(event.response);
    emit(DemographicResponsesStockState(responses: responses));
  }

  Future<void> _handleDeleteDemographicStockResponse(
    DeleteDemographicResponseStockEvent event,
    Emitter<DemographicResponsesStockState> emit,
  ) async {
    final responses = [...state.responses];
    responses.removeWhere((response) => response.demographicType == event.demographicType);
    emit(DemographicResponsesStockState(responses: responses));
  }
}

List<DemographicResponse> _mapArguments(DemographicQuestionArguments? arguments) {
  return switch (arguments) {
    final DemographicQuestionArgumentsFromModify modifyArguments =>
      modifyArguments.demographicInformations.map((information) {
        return DemographicResponse(
          demographicType: information.demographicType,
          response: information.data ?? '',
        );
      }).toList(),
    DemographicQuestionArgumentsFromQuestion _ => [],
    null => [],
  };
}
