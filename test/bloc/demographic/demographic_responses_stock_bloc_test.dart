import 'package:agora/bloc/demographic/stock/demographic_responses_stock_bloc.dart';
import 'package:agora/bloc/demographic/stock/demographic_responses_stock_event.dart';
import 'package:agora/bloc/demographic/stock/demographic_responses_stock_state.dart';
import 'package:agora/domain/demographic/demographic_response.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group("AddDemographicResponseStockEvent", () {
    blocTest(
      "when add response - should update state with the new response",
      build: () => DemographicResponsesStockBloc(),
      act: (bloc) => bloc
        ..add(
          AddDemographicResponseStockEvent(
            response: DemographicResponse(
              question: "questionCode1",
              response: "responseCode1",
            ),
          ),
        )
        ..add(
          AddDemographicResponseStockEvent(
            response: DemographicResponse(
              question: "questionCode2",
              response: "responseCode2",
            ),
          ),
        ),
      expect: () => [
        DemographicResponsesStockState(
          responses: [
            DemographicResponse(question: "questionCode1", response: "responseCode1"),
          ],
        ),
        DemographicResponsesStockState(
          responses: [
            DemographicResponse(question: "questionCode1", response: "responseCode1"),
            DemographicResponse(question: "questionCode2", response: "responseCode2"),
          ],
        ),
      ],
      wait: const Duration(milliseconds: 5),
    );

    blocTest(
      "when add response for a specific questionCode and this questionCode already exists - should replace the previous one",
      build: () => DemographicResponsesStockBloc(),
      act: (bloc) => bloc
        ..add(
          AddDemographicResponseStockEvent(
            response: DemographicResponse(
              question: "questionCode1",
              response: "responseCode1",
            ),
          ),
        )
        ..add(
          AddDemographicResponseStockEvent(
            response: DemographicResponse(
              question: "questionCode2",
              response: "responseCode2",
            ),
          ),
        )
        ..add(
          AddDemographicResponseStockEvent(
            response: DemographicResponse(
              question: "questionCode1",
              response: "responseCode3",
            ),
          ),
        ),
      expect: () => [
        DemographicResponsesStockState(
          responses: [
            DemographicResponse(question: "questionCode1", response: "responseCode1"),
          ],
        ),
        DemographicResponsesStockState(
          responses: [
            DemographicResponse(question: "questionCode1", response: "responseCode1"),
            DemographicResponse(question: "questionCode2", response: "responseCode2"),
          ],
        ),
        DemographicResponsesStockState(
          responses: [
            DemographicResponse(question: "questionCode2", response: "responseCode2"),
            DemographicResponse(question: "questionCode1", response: "responseCode3"),
          ],
        ),
      ],
      wait: const Duration(milliseconds: 5),
    );
  });
}
