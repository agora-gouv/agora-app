import 'package:agora/bloc/consultation/question/response/stock/consultation_questions_responses_stock_bloc.dart';
import 'package:agora/bloc/consultation/question/response/stock/consultation_questions_responses_stock_event.dart';
import 'package:agora/bloc/consultation/question/response/stock/consultation_questions_responses_stock_state.dart';
import 'package:agora/domain/consultation/questions/responses/consultation_question_response.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../fakes/consultation/fake_consultation_question_storage_client.dart';

void main() {
  const consultationId = "consultationId";

  group("AddConsultationQuestionsResponseStockEvent", () {
    final fakeStorage1 = FakeConsultationQuestionStorageClient();
    blocTest<ConsultationQuestionsResponsesStockBloc, ConsultationQuestionsResponsesStockState>(
      "when add response - should update state with the new response",
      build: () => ConsultationQuestionsResponsesStockBloc(storageClient: fakeStorage1),
      seed: () => ConsultationQuestionsResponsesStockState(
        questionsStack: ["questionId"],
        questionsResponses: [
          ConsultationQuestionResponses(questionId: "questionId", responseIds: ["responseId"], responseText: ""),
        ],
      ),
      act: (bloc) => bloc.add(
        AddConsultationQuestionsResponseStockEvent(
          consultationId: consultationId,
          questionResponse: ConsultationQuestionResponses(
            questionId: "questionId2",
            responseIds: [],
            responseText: "opened response",
          ),
        ),
      ),
      expect: () => [
        ConsultationQuestionsResponsesStockState(
          questionsStack: ["questionId", "questionId2"],
          questionsResponses: [
            ConsultationQuestionResponses(questionId: "questionId", responseIds: ["responseId"], responseText: ""),
            ConsultationQuestionResponses(questionId: "questionId2", responseIds: [], responseText: "opened response"),
          ],
        ),
      ],
      wait: const Duration(milliseconds: 5),
      tearDown: () async {
        expect(fakeStorage1.consultationId, consultationId);
        expect(fakeStorage1.questionsStack, ["questionId", "questionId2"]);
        expect(
          fakeStorage1.questionsResponses,
          [
            ConsultationQuestionResponses(questionId: "questionId", responseIds: ["responseId"], responseText: ""),
            ConsultationQuestionResponses(
              questionId: "questionId2",
              responseIds: [],
              responseText: "opened response",
            ),
          ],
        );
      },
    );

    final fakeStorage2 = FakeConsultationQuestionStorageClient();
    blocTest<ConsultationQuestionsResponsesStockBloc, ConsultationQuestionsResponsesStockState>(
      "when add response for a specific questionId and this questionId already exists - should replace the previous one",
      build: () => ConsultationQuestionsResponsesStockBloc(storageClient: fakeStorage2),
      seed: () => ConsultationQuestionsResponsesStockState(
        questionsStack: ["questionId"],
        questionsResponses: [
          ConsultationQuestionResponses(questionId: "questionId", responseIds: ["responseId"], responseText: ""),
          ConsultationQuestionResponses(questionId: "questionId2", responseIds: [], responseText: "opened response"),
        ],
      ),
      act: (bloc) => bloc.add(
        AddConsultationQuestionsResponseStockEvent(
          consultationId: consultationId,
          questionResponse: ConsultationQuestionResponses(
            questionId: "questionId2",
            responseIds: [],
            responseText: "opened response new",
          ),
        ),
      ),
      expect: () => [
        ConsultationQuestionsResponsesStockState(
          questionsStack: ["questionId", "questionId2"],
          questionsResponses: [
            ConsultationQuestionResponses(questionId: "questionId", responseIds: ["responseId"], responseText: ""),
            ConsultationQuestionResponses(
              questionId: "questionId2",
              responseIds: [],
              responseText: "opened response new",
            ),
          ],
        ),
      ],
      wait: const Duration(milliseconds: 5),
      tearDown: () async {
        expect(fakeStorage2.consultationId, consultationId);
        expect(fakeStorage2.questionsStack, ["questionId", "questionId2"]);
        expect(
          fakeStorage2.questionsResponses,
          [
            ConsultationQuestionResponses(questionId: "questionId", responseIds: ["responseId"], responseText: ""),
            ConsultationQuestionResponses(
              questionId: "questionId2",
              responseIds: [],
              responseText: "opened response new",
            ),
          ],
        );
      },
    );
  });

  group("AddConsultationChapterStockEvent", () {
    final fakeStorageClient = FakeConsultationQuestionStorageClient();
    blocTest<ConsultationQuestionsResponsesStockBloc, ConsultationQuestionsResponsesStockState>(
      "when add chapter in stack - should update state with the new chapter",
      build: () => ConsultationQuestionsResponsesStockBloc(storageClient: fakeStorageClient),
      seed: () => ConsultationQuestionsResponsesStockState(
        questionsStack: ["questionId"],
        questionsResponses: [
          ConsultationQuestionResponses(questionId: "questionId", responseIds: ["responseId"], responseText: ""),
        ],
      ),
      act: (bloc) => bloc.add(AddConsultationChapterStockEvent(consultationId: consultationId, chapterId: "chapterId")),
      expect: () => [
        ConsultationQuestionsResponsesStockState(
          questionsStack: ["questionId", "chapterId"],
          questionsResponses: [
            ConsultationQuestionResponses(questionId: "questionId", responseIds: ["responseId"], responseText: ""),
          ],
        ),
      ],
      wait: const Duration(milliseconds: 5),
      tearDown: () async {
        expect(fakeStorageClient.consultationId, consultationId);
        expect(fakeStorageClient.questionsStack, ["questionId", "chapterId"]);
        expect(
          fakeStorageClient.questionsResponses,
          [
            ConsultationQuestionResponses(questionId: "questionId", responseIds: ["responseId"], responseText: ""),
          ],
        );
      },
    );
  });

  group("RemoveConsultationQuestionEvent", () {
    blocTest<ConsultationQuestionsResponsesStockBloc, ConsultationQuestionsResponsesStockState>(
      "when remove chapter or question in stack - should update state with the new chapter",
      build: () => ConsultationQuestionsResponsesStockBloc(
        storageClient: FakeConsultationQuestionStorageClient(),
      ),
      seed: () => ConsultationQuestionsResponsesStockState(
        questionsStack: ["questionId", "chapterId"],
        questionsResponses: [
          ConsultationQuestionResponses(questionId: "questionId", responseIds: ["responseId"], responseText: ""),
        ],
      ),
      act: (bloc) => bloc.add(RemoveConsultationQuestionEvent()),
      expect: () => [
        ConsultationQuestionsResponsesStockState(
          questionsStack: ["questionId"],
          questionsResponses: [
            ConsultationQuestionResponses(questionId: "questionId", responseIds: ["responseId"], responseText: ""),
          ],
        ),
      ],
      wait: const Duration(milliseconds: 5),
    );
  });

  group("RestoreSavingConsultationResponseEvent", () {
    final fakeStorageClient = FakeConsultationQuestionStorageClient();
    fakeStorageClient.save(
      consultationId: consultationId,
      questionsStack: ["questionId"],
      questionsResponses: [
        ConsultationQuestionResponses(questionId: "questionId", responseIds: ["responseId"], responseText: ""),
      ],
    );
    blocTest<ConsultationQuestionsResponsesStockBloc, ConsultationQuestionsResponsesStockState>(
      "Restore state from local response",
      build: () => ConsultationQuestionsResponsesStockBloc(storageClient: fakeStorageClient),
      act: (bloc) => bloc.add(RestoreSavingConsultationResponseEvent(consultationId: consultationId)),
      expect: () => [
        ConsultationQuestionsResponsesStockState(
          questionsStack: ["questionId"],
          questionsResponses: [
            ConsultationQuestionResponses(questionId: "questionId", responseIds: ["responseId"], responseText: ""),
          ],
        ),
      ],
      wait: const Duration(milliseconds: 5),
      tearDown: () async {
        expect(fakeStorageClient.consultationId, consultationId);
        expect(fakeStorageClient.questionsStack, ["questionId"]);
        expect(
          fakeStorageClient.questionsResponses,
          [
            ConsultationQuestionResponses(questionId: "questionId", responseIds: ["responseId"], responseText: ""),
          ],
        );
      },
    );
  });

  group("DeleteSavingConsultationResponseEvent", () {
    final fakeStorageClient = FakeConsultationQuestionStorageClient();
    fakeStorageClient.save(
      consultationId: consultationId,
      questionsStack: ["questionId"],
      questionsResponses: [
        ConsultationQuestionResponses(questionId: "questionId", responseIds: ["responseId"], responseText: ""),
      ],
    );
    blocTest<ConsultationQuestionsResponsesStockBloc, ConsultationQuestionsResponsesStockState>(
      "Delete local response",
      build: () => ConsultationQuestionsResponsesStockBloc(storageClient: fakeStorageClient),
      act: (bloc) => bloc.add(DeleteSavingConsultationResponseEvent(consultationId: consultationId)),
      expect: () => [],
      wait: const Duration(milliseconds: 5),
      tearDown: () async {
        expect(fakeStorageClient.consultationId, null);
        expect(fakeStorageClient.questionsStack, []);
        expect(fakeStorageClient.questionsResponses, []);
      },
    );
  });
}
