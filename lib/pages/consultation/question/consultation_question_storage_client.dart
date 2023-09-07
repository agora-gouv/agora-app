import 'package:agora/bloc/consultation/question/response/stock/consultation_question_response_hive.dart';
import 'package:agora/domain/consultation/questions/responses/consultation_question_response.dart';
import 'package:hive/hive.dart';

abstract class ConsultationQuestionStorageClient {
  Future<void> save({
    required String consultationId,
    required List<String> questionIdStack,
    required List<ConsultationQuestionResponses> questionsResponses,
  });

  Future<(List<String>, List<ConsultationQuestionResponses>)> get(String consultationId);

  Future<void> clear(String consultationId);
}

class ConsultationQuestionHiveStorageClient extends ConsultationQuestionStorageClient {
  final boxName = "consultationResponse";

  @override
  Future<void> save({
    required String consultationId,
    required List<String> questionIdStack,
    required List<ConsultationQuestionResponses> questionsResponses,
  }) async {
    final box = await _getBox();
    box.put("questionIdStack_$consultationId", questionIdStack);
    box.put(
      "questionsResponses_$consultationId",
      questionsResponses
          .map(
            (questionsResponse) => ConsultationQuestionResponsesHive(
              questionId: questionsResponse.questionId,
              responseIds: List.from(questionsResponse.responseIds),
              responseText: questionsResponse.responseText,
            ),
          )
          .toList(),
    );
  }

  @override
  Future<(List<String>, List<ConsultationQuestionResponses>)> get(String consultationId) async {
    final box = await _getBox();
    final localStack = box
        .get("questionIdStack_$consultationId")
        ?.map((localQuestionIdStack) => localQuestionIdStack as String)
        .toList();
    final localResponses = box
        .get("questionsResponses_$consultationId")
        ?.map((localQuestionResponses) => localQuestionResponses as ConsultationQuestionResponsesHive)
        .map(
          (questionResponsesHive) => ConsultationQuestionResponses(
            questionId: questionResponsesHive.questionId,
            responseIds: questionResponsesHive.responseIds,
            responseText: questionResponsesHive.responseText,
          ),
        )
        .toList();
    return (localStack ?? [], localResponses ?? []);
  }

  @override
  Future<void> clear(String consultationId) async {
    final box = await _getBox();
    box.deleteAll(["questionIdStack_$consultationId", "questionsResponses_$consultationId"]);
  }

  Future<Box<List<dynamic>>> _getBox() async {
    return await Hive.openBox<List<dynamic>>(boxName);
  }
}
