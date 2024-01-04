import 'package:agora/bloc/demographic/stock/demographic_responses_stock_event.dart';
import 'package:agora/bloc/demographic/stock/demographic_responses_stock_state.dart';
import 'package:agora/domain/demographic/demographic_response.dart';
import 'package:agora/pages/demographic/demographic_question_page.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DemographicResponsesStockBloc extends Bloc<DemographicResponseStockEvent, DemographicResponsesStockState> {
  DemographicResponsesStockBloc([DemographicQuestionArgumentsFromModify? arguments])
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

List<DemographicResponse> _mapArguments(DemographicQuestionArgumentsFromModify? arguments) {
  if (arguments == null) return [];
  return arguments.demographicInformations.map((information) {
    return DemographicResponse(
      demographicType: information.demographicType,
      response: information.data ?? '',
    );
  }).toList();
}
