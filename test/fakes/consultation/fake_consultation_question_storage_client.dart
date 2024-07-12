import 'package:agora/consultation/question/domain/consultation_question_response.dart';
import 'package:agora/consultation/question/repository/consultation_question_storage_client.dart';

class FakeConsultationQuestionStorageClient extends ConsultationQuestionStorageClient {
  String? consultationId;
  List<String> questionIdStack = [];
  List<ConsultationQuestionResponses> questionsResponses = [];
  String? restoreQuestionId;

  @override
  Future<void> save({
    required String consultationId,
    required List<String> questionIdStack,
    required List<ConsultationQuestionResponses> questionsResponses,
    required String? restoreQuestionId,
  }) async {
    this.consultationId = consultationId;
    this.questionIdStack = questionIdStack;
    this.questionsResponses = questionsResponses;
    this.restoreQuestionId = restoreQuestionId;
  }

  @override
  Future<(List<String>, List<ConsultationQuestionResponses>, String?)> get(String consultationId) async {
    if (this.consultationId == consultationId) {
      return (questionIdStack, questionsResponses, restoreQuestionId!);
    } else {
      return (<String>[], <ConsultationQuestionResponses>[], null);
    }
  }

  @override
  Future<void> clear(String consultationId) async {
    if (this.consultationId == consultationId) {
      this.consultationId = null;
      questionIdStack = [];
      questionsResponses = [];
      restoreQuestionId = null;
    }
  }
}
