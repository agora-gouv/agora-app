import 'package:agora/consultation/question/bloc/response/stock/consultation_question_response_hive.dart';
import 'package:agora/consultation/question/domain/consultation_question_response.dart';
import 'package:hive/hive.dart';

abstract class ConsultationQuestionStorageClient {
  Future<void> save({
    required String consultationId,
    required List<String> questionIdStack,
    required List<ConsultationQuestionResponses> questionsResponses,
    required String? restoreQuestionId,
  });

  Future<(List<String>, List<ConsultationQuestionResponses>, String?)> get(String consultationId);

  Future<void> clear(String consultationId);
}

class ConsultationQuestionHiveStorageClient extends ConsultationQuestionStorageClient {
  final listBoxName = "consultationResponse";
  final stringBoxName = "consultationNextRestoreQuestion";

  final valueToReplace = "{consultationId}";
  final questionIdStackKey = "questionIdStack_{consultationId}";
  final questionsResponsesKey = "questionsResponses_{consultationId}";
  final restoreQuestionIdKey = "restoreQuestionId_{consultationId}";

  @override
  Future<void> save({
    required String consultationId,
    required List<String> questionIdStack,
    required List<ConsultationQuestionResponses> questionsResponses,
    required String? restoreQuestionId,
  }) async {
    final listBox = await _getListBox();
    listBox.put(questionIdStackKey.replaceFirst(valueToReplace, consultationId), questionIdStack);
    listBox.put(
      questionsResponsesKey.replaceFirst(valueToReplace, consultationId),
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

    final stringBox = await _getStringBox();
    if (restoreQuestionId != null) {
      stringBox.put(restoreQuestionIdKey.replaceFirst(valueToReplace, consultationId), restoreQuestionId);
    }
  }

  @override
  Future<(List<String>, List<ConsultationQuestionResponses>, String?)> get(String consultationId) async {
    final listBox = await _getListBox();
    final localStack = listBox
        .get(questionIdStackKey.replaceFirst(valueToReplace, consultationId))
        ?.map((localQuestionIdStack) => localQuestionIdStack as String)
        .toList();
    final localResponses = listBox
        .get(questionsResponsesKey.replaceFirst(valueToReplace, consultationId))
        ?.map((localQuestionResponses) => localQuestionResponses as ConsultationQuestionResponsesHive)
        .map(
          (questionResponsesHive) => ConsultationQuestionResponses(
            questionId: questionResponsesHive.questionId,
            responseIds: questionResponsesHive.responseIds,
            responseText: questionResponsesHive.responseText,
          ),
        )
        .toList();

    final stringBox = await _getStringBox();
    final restoreQuestionId = stringBox.get(restoreQuestionIdKey.replaceFirst(valueToReplace, consultationId));

    return (localStack ?? [], localResponses ?? [], restoreQuestionId);
  }

  @override
  Future<void> clear(String consultationId) async {
    final listBox = await _getListBox();
    listBox.deleteAll([
      questionIdStackKey.replaceFirst(valueToReplace, consultationId),
      questionsResponsesKey.replaceFirst(valueToReplace, consultationId),
    ]);
    final stringBox = await _getStringBox();
    stringBox.delete(restoreQuestionIdKey.replaceFirst(valueToReplace, consultationId));
  }

  Future<Box<List<dynamic>>> _getListBox() async {
    return await Hive.openBox<List<dynamic>>(listBoxName);
  }

  Future<Box<String>> _getStringBox() async {
    return await Hive.openBox<String>(stringBoxName);
  }
}
