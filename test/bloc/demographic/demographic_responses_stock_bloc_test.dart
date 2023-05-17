import 'package:agora/bloc/demographic/stock/demographic_responses_stock_bloc.dart';
import 'package:agora/bloc/demographic/stock/demographic_responses_stock_event.dart';
import 'package:agora/bloc/demographic/stock/demographic_responses_stock_state.dart';
import 'package:agora/domain/demographic/demographic_question_type.dart';
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
              questionType: DemographicQuestionType.gender,
              response: "responseCode1",
            ),
          ),
        )
        ..add(
          AddDemographicResponseStockEvent(
            response: DemographicResponse(
              questionType: DemographicQuestionType.yearOfBirth,
              response: "responseCode2",
            ),
          ),
        ),
      expect: () => [
        DemographicResponsesStockState(
          responses: [
            DemographicResponse(questionType: DemographicQuestionType.gender, response: "responseCode1"),
          ],
        ),
        DemographicResponsesStockState(
          responses: [
            DemographicResponse(questionType: DemographicQuestionType.gender, response: "responseCode1"),
            DemographicResponse(questionType: DemographicQuestionType.yearOfBirth, response: "responseCode2"),
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
              questionType: DemographicQuestionType.gender,
              response: "responseCode1",
            ),
          ),
        )
        ..add(
          AddDemographicResponseStockEvent(
            response: DemographicResponse(
              questionType: DemographicQuestionType.yearOfBirth,
              response: "responseCode2",
            ),
          ),
        )
        ..add(
          AddDemographicResponseStockEvent(
            response: DemographicResponse(
              questionType: DemographicQuestionType.gender,
              response: "responseCode3",
            ),
          ),
        ),
      expect: () => [
        DemographicResponsesStockState(
          responses: [
            DemographicResponse(questionType: DemographicQuestionType.gender, response: "responseCode1"),
          ],
        ),
        DemographicResponsesStockState(
          responses: [
            DemographicResponse(questionType: DemographicQuestionType.gender, response: "responseCode1"),
            DemographicResponse(questionType: DemographicQuestionType.yearOfBirth, response: "responseCode2"),
          ],
        ),
        DemographicResponsesStockState(
          responses: [
            DemographicResponse(questionType: DemographicQuestionType.yearOfBirth, response: "responseCode2"),
            DemographicResponse(questionType: DemographicQuestionType.gender, response: "responseCode3"),
          ],
        ),
      ],
      wait: const Duration(milliseconds: 5),
    );
  });

  group("DeleteDemographicResponseStockEvent", () {
    blocTest<DemographicResponsesStockBloc, DemographicResponsesStockState>(
      "when delete response - should update state with the new response",
      build: () => DemographicResponsesStockBloc(),
      seed: () => DemographicResponsesStockState(
        responses: [
          DemographicResponse(questionType: DemographicQuestionType.gender, response: "responseCode1"),
          DemographicResponse(questionType: DemographicQuestionType.yearOfBirth, response: "responseCode2"),
        ],
      ),
      act: (bloc) => bloc.add(DeleteDemographicResponseStockEvent(questionType: DemographicQuestionType.gender)),
      expect: () => [
        DemographicResponsesStockState(
          responses: [
            DemographicResponse(questionType: DemographicQuestionType.yearOfBirth, response: "responseCode2"),
          ],
        ),
      ],
      wait: const Duration(milliseconds: 5),
    );

    blocTest<DemographicResponsesStockBloc, DemographicResponsesStockState>(
      "when delete response and response not exists - should emit same state",
      build: () => DemographicResponsesStockBloc(),
      seed: () => DemographicResponsesStockState(
        responses: [
          DemographicResponse(questionType: DemographicQuestionType.gender, response: "responseCode1"),
          DemographicResponse(questionType: DemographicQuestionType.yearOfBirth, response: "responseCode2"),
        ],
      ),
      act: (bloc) => bloc..add(DeleteDemographicResponseStockEvent(questionType: DemographicQuestionType.cityType)),
      expect: () => [
        // when current state is same that previous state => state does not change
      ],
      wait: const Duration(milliseconds: 5),
    );
  });
}
