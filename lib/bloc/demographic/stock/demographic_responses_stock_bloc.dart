import 'package:agora/bloc/demographic/stock/demographic_responses_stock_event.dart';
import 'package:agora/bloc/demographic/stock/demographic_responses_stock_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DemographicResponsesStockBloc extends Bloc<AddDemographicResponseStockEvent, DemographicResponsesStockState> {
  DemographicResponsesStockBloc() : super(DemographicResponsesStockState(responses: [])) {
    on<AddDemographicResponseStockEvent>(_handleAddDemographicStockResponse);
  }

  Future<void> _handleAddDemographicStockResponse(
    AddDemographicResponseStockEvent event,
    Emitter<DemographicResponsesStockState> emit,
  ) async {
    final responses = [...state.responses];
    responses.removeWhere((response) => response.question == event.response.question);
    responses.add(event.response);
    emit(DemographicResponsesStockState(responses: responses));
  }
}
