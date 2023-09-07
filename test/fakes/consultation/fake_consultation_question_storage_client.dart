import 'package:agora/domain/consultation/questions/responses/consultation_question_response.dart';
import 'package:agora/pages/consultation/question/consultation_question_storage_client.dart';

class FakeConsultationQuestionStorageClient extends ConsultationQuestionStorageClient {
  String? consultationId;
  List<String> questionsStack = [];
  List<ConsultationQuestionResponses> questionsResponses = [];

  @override
  Future<void> save({
    required String consultationId,
    required List<String> questionsStack,
    required List<ConsultationQuestionResponses> questionsResponses,
  }) async {
    this.consultationId = consultationId;
    this.questionsStack = questionsStack;
    this.questionsResponses = questionsResponses;
  }

  @override
  Future<(List<String>, List<ConsultationQuestionResponses>)> get(String consultationId) async {
    if (this.consultationId == consultationId) {
      return (questionsStack, questionsResponses);
    } else {
      return (<String>[], <ConsultationQuestionResponses>[]);
    }
  }

  @override
  Future<void> clear(String consultationId) async {
    if (this.consultationId == consultationId) {
      this.consultationId = null;
      questionsStack = [];
      questionsResponses = [];
    }
  }
}
