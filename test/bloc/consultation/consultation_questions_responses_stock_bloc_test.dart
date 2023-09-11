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
        questionIdStack: ["previousQuestionId"],
        questionsResponses: [
          ConsultationQuestionResponses(
            questionId: "previousQuestionId",
            responseIds: ["responseId"],
            responseText: "",
          ),
        ],
        currentQuestionId: "currentQuestionId",
      ),
      act: (bloc) => bloc.add(
        AddConsultationQuestionsResponseStockEvent(
          consultationId: consultationId,
          questionResponse: ConsultationQuestionResponses(
            questionId: "currentQuestionId",
            responseIds: [],
            responseText: "opened response",
          ),
          nextQuestionId: "nextQuestionId",
        ),
      ),
      expect: () => [
        ConsultationQuestionsResponsesStockState(
          questionIdStack: ["previousQuestionId", "currentQuestionId"],
          questionsResponses: [
            ConsultationQuestionResponses(
              questionId: "previousQuestionId",
              responseIds: ["responseId"],
              responseText: "",
            ),
            ConsultationQuestionResponses(
              questionId: "currentQuestionId",
              responseIds: [],
              responseText: "opened response",
            ),
          ],
          currentQuestionId: "nextQuestionId",
        ),
      ],
      wait: const Duration(milliseconds: 5),
      tearDown: () async {
        expect(fakeStorage1.consultationId, consultationId);
        expect(fakeStorage1.questionIdStack, ["previousQuestionId", "currentQuestionId"]);
        expect(
          fakeStorage1.questionsResponses,
          [
            ConsultationQuestionResponses(
              questionId: "previousQuestionId",
              responseIds: ["responseId"],
              responseText: "",
            ),
            ConsultationQuestionResponses(
              questionId: "currentQuestionId",
              responseIds: [],
              responseText: "opened response",
            ),
          ],
        );
        expect(fakeStorage1.restoreQuestionId, "nextQuestionId");
      },
    );

    final fakeStorage2 = FakeConsultationQuestionStorageClient();
    blocTest<ConsultationQuestionsResponsesStockBloc, ConsultationQuestionsResponsesStockState>(
      "when add response for a specific questionId and this questionId already exists - should replace the previous one",
      build: () => ConsultationQuestionsResponsesStockBloc(storageClient: fakeStorage2),
      seed: () => ConsultationQuestionsResponsesStockState(
        questionIdStack: ["previousQuestionId"],
        questionsResponses: [
          ConsultationQuestionResponses(
            questionId: "previousQuestionId",
            responseIds: ["responseId"],
            responseText: "",
          ),
          ConsultationQuestionResponses(
            questionId: "currentQuestionId",
            responseIds: [],
            responseText: "opened response",
          ),
        ],
        currentQuestionId: "currentQuestionId",
      ),
      act: (bloc) => bloc.add(
        AddConsultationQuestionsResponseStockEvent(
          consultationId: consultationId,
          questionResponse: ConsultationQuestionResponses(
            questionId: "currentQuestionId",
            responseIds: [],
            responseText: "opened response new",
          ),
          nextQuestionId: "nextQuestionId",
        ),
      ),
      expect: () => [
        ConsultationQuestionsResponsesStockState(
          questionIdStack: ["previousQuestionId", "currentQuestionId"],
          questionsResponses: [
            ConsultationQuestionResponses(
              questionId: "previousQuestionId",
              responseIds: ["responseId"],
              responseText: "",
            ),
            ConsultationQuestionResponses(
              questionId: "currentQuestionId",
              responseIds: [],
              responseText: "opened response new",
            ),
          ],
          currentQuestionId: "nextQuestionId",
        ),
      ],
      wait: const Duration(milliseconds: 5),
      tearDown: () async {
        expect(fakeStorage2.consultationId, consultationId);
        expect(fakeStorage2.questionIdStack, ["previousQuestionId", "currentQuestionId"]);
        expect(
          fakeStorage2.questionsResponses,
          [
            ConsultationQuestionResponses(
              questionId: "previousQuestionId",
              responseIds: ["responseId"],
              responseText: "",
            ),
            ConsultationQuestionResponses(
              questionId: "currentQuestionId",
              responseIds: [],
              responseText: "opened response new",
            ),
          ],
        );
        expect(fakeStorage2.restoreQuestionId, "nextQuestionId");
      },
    );
  });

  group("AddConsultationChapterStockEvent", () {
    final fakeStorageClient = FakeConsultationQuestionStorageClient();
    blocTest<ConsultationQuestionsResponsesStockBloc, ConsultationQuestionsResponsesStockState>(
      "when add chapter in stack - should update state with the new chapter",
      build: () => ConsultationQuestionsResponsesStockBloc(storageClient: fakeStorageClient),
      seed: () => ConsultationQuestionsResponsesStockState(
        questionIdStack: ["previousQuestionId"],
        questionsResponses: [
          ConsultationQuestionResponses(
            questionId: "previousQuestionId",
            responseIds: ["responseId"],
            responseText: "",
          ),
        ],
        currentQuestionId: "nextQuestionId",
      ),
      act: (bloc) => bloc.add(
        AddConsultationChapterStockEvent(
          consultationId: consultationId,
          chapterId: "chapterId",
          nextQuestionId: "nextQuestionId",
        ),
      ),
      expect: () => [
        ConsultationQuestionsResponsesStockState(
          questionIdStack: ["previousQuestionId", "chapterId"],
          questionsResponses: [
            ConsultationQuestionResponses(
              questionId: "previousQuestionId",
              responseIds: ["responseId"],
              responseText: "",
            ),
          ],
          currentQuestionId: "nextQuestionId",
        ),
      ],
      wait: const Duration(milliseconds: 5),
      tearDown: () async {
        expect(fakeStorageClient.consultationId, consultationId);
        expect(fakeStorageClient.questionIdStack, ["previousQuestionId", "chapterId"]);
        expect(
          fakeStorageClient.questionsResponses,
          [
            ConsultationQuestionResponses(
              questionId: "previousQuestionId",
              responseIds: ["responseId"],
              responseText: "",
            ),
          ],
        );
        expect(fakeStorageClient.restoreQuestionId, "nextQuestionId");
      },
    );
  });

  group("RemoveConsultationQuestionEvent", () {
    blocTest<ConsultationQuestionsResponsesStockBloc, ConsultationQuestionsResponsesStockState>(
      "when remove chapter or question in stack - should update state with the updated stack",
      build: () => ConsultationQuestionsResponsesStockBloc(
        storageClient: FakeConsultationQuestionStorageClient(),
      ),
      seed: () => ConsultationQuestionsResponsesStockState(
        questionIdStack: ["previousQuestionId", "chapterId"],
        questionsResponses: [
          ConsultationQuestionResponses(
            questionId: "previousQuestionId",
            responseIds: ["responseId"],
            responseText: "",
          ),
        ],
        currentQuestionId: "nextQuestionId",
      ),
      act: (bloc) => bloc.add(RemoveConsultationQuestionEvent()),
      expect: () => [
        ConsultationQuestionsResponsesStockState(
          questionIdStack: ["previousQuestionId"],
          questionsResponses: [
            ConsultationQuestionResponses(
              questionId: "previousQuestionId",
              responseIds: ["responseId"],
              responseText: "",
            ),
          ],
          currentQuestionId: "chapterId",
        ),
      ],
      wait: const Duration(milliseconds: 5),
    );

    blocTest<ConsultationQuestionsResponsesStockBloc, ConsultationQuestionsResponsesStockState>(
      "when stack is empty - should update state with shouldPop = true",
      build: () => ConsultationQuestionsResponsesStockBloc(
        storageClient: FakeConsultationQuestionStorageClient(),
      ),
      seed: () => ConsultationQuestionsResponsesStockState(
        questionIdStack: [],
        questionsResponses: [
          ConsultationQuestionResponses(
            questionId: "previousQuestionId",
            responseIds: ["responseId"],
            responseText: "",
          ),
        ],
        currentQuestionId: "nextQuestionId",
      ),
      act: (bloc) => bloc.add(RemoveConsultationQuestionEvent()),
      expect: () => [
        ConsultationQuestionsResponsesStockState(
          questionIdStack: [],
          questionsResponses: [],
          currentQuestionId: null,
          shouldPop: true,
        ),
      ],
      wait: const Duration(milliseconds: 5),
    );
  });

  group("RestoreSavingConsultationResponseEvent", () {
    final fakeStorageClient = FakeConsultationQuestionStorageClient();
    fakeStorageClient.save(
      consultationId: consultationId,
      questionIdStack: ["previousQuestionId"],
      questionsResponses: [
        ConsultationQuestionResponses(questionId: "previousQuestionId", responseIds: ["responseId"], responseText: ""),
      ],
      restoreQuestionId: "currentQuestionId",
    );
    blocTest<ConsultationQuestionsResponsesStockBloc, ConsultationQuestionsResponsesStockState>(
      "Restore state from local response",
      build: () => ConsultationQuestionsResponsesStockBloc(storageClient: fakeStorageClient),
      act: (bloc) => bloc.add(RestoreSavingConsultationResponseEvent(consultationId: consultationId)),
      expect: () => [
        ConsultationQuestionsResponsesStockState(
          questionIdStack: ["previousQuestionId"],
          questionsResponses: [
            ConsultationQuestionResponses(
              questionId: "previousQuestionId",
              responseIds: ["responseId"],
              responseText: "",
            ),
          ],
          currentQuestionId: "currentQuestionId",
        ),
      ],
      wait: const Duration(milliseconds: 5),
      tearDown: () async {
        expect(fakeStorageClient.consultationId, consultationId);
        expect(fakeStorageClient.questionIdStack, ["previousQuestionId"]);
        expect(
          fakeStorageClient.questionsResponses,
          [
            ConsultationQuestionResponses(
              questionId: "previousQuestionId",
              responseIds: ["responseId"],
              responseText: "",
            ),
          ],
        );
        expect(fakeStorageClient.restoreQuestionId, "currentQuestionId");
      },
    );
  });

  group("DeleteSavingConsultationResponseEvent", () {
    final fakeStorageClient = FakeConsultationQuestionStorageClient();
    fakeStorageClient.save(
      consultationId: consultationId,
      questionIdStack: ["previousQuestionId"],
      questionsResponses: [
        ConsultationQuestionResponses(questionId: "previousQuestionId", responseIds: ["responseId"], responseText: ""),
      ],
      restoreQuestionId: "lastQuestionId",
    );
    blocTest<ConsultationQuestionsResponsesStockBloc, ConsultationQuestionsResponsesStockState>(
      "Delete local response",
      build: () => ConsultationQuestionsResponsesStockBloc(storageClient: fakeStorageClient),
      act: (bloc) => bloc.add(DeleteSavingConsultationResponseEvent(consultationId: consultationId)),
      expect: () => [
        ConsultationQuestionsResponsesStockState(
          questionIdStack: [],
          questionsResponses: [],
          currentQuestionId: null,
        ),
      ],
      wait: const Duration(milliseconds: 5),
      tearDown: () async {
        expect(fakeStorageClient.consultationId, null);
        expect(fakeStorageClient.questionIdStack, []);
        expect(fakeStorageClient.questionsResponses, []);
        expect(fakeStorageClient.restoreQuestionId, null);
      },
    );
  });

  group("ResetToLastQuestionEvent", () {
    final fakeStorageClient = FakeConsultationQuestionStorageClient();
    blocTest<ConsultationQuestionsResponsesStockBloc, ConsultationQuestionsResponsesStockState>(
      "when send responses to server failed - should reset to last question",
      build: () => ConsultationQuestionsResponsesStockBloc(storageClient: fakeStorageClient),
      seed: () => ConsultationQuestionsResponsesStockState(
        questionIdStack: ["previousQuestionId", "lastQuestionId"],
        questionsResponses: [
          ConsultationQuestionResponses(
            questionId: "previousQuestionId",
            responseIds: ["responseId"],
            responseText: "",
          ),
          ConsultationQuestionResponses(
            questionId: "lastQuestionId",
            responseIds: [],
            responseText: "response",
          ),
        ],
        currentQuestionId: null,
      ),
      act: (bloc) => bloc.add(ResetToLastQuestionEvent(consultationId: consultationId)),
      expect: () => [
        ConsultationQuestionsResponsesStockState(
          questionIdStack: ["previousQuestionId"],
          questionsResponses: [
            ConsultationQuestionResponses(
              questionId: "previousQuestionId",
              responseIds: ["responseId"],
              responseText: "",
            ),
            ConsultationQuestionResponses(
              questionId: "lastQuestionId",
              responseIds: [],
              responseText: "response",
            ),
          ],
          currentQuestionId: "lastQuestionId",
        ),
      ],
      wait: const Duration(milliseconds: 5),
      tearDown: () async {
        expect(fakeStorageClient.consultationId, consultationId);
        expect(fakeStorageClient.questionIdStack, ["previousQuestionId"]);
        expect(
          fakeStorageClient.questionsResponses,
          [
            ConsultationQuestionResponses(
              questionId: "previousQuestionId",
              responseIds: ["responseId"],
              responseText: "",
            ),
            ConsultationQuestionResponses(
              questionId: "lastQuestionId",
              responseIds: [],
              responseText: "response",
            ),
          ],
        );
        expect(fakeStorageClient.restoreQuestionId, "lastQuestionId");
      },
    );
  });
}
