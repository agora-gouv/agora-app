import 'package:agora/domain/consultation/questions/consultation_question.dart';
import 'package:agora/domain/consultation/questions/consultation_question_response_choice.dart';
import 'package:agora/domain/consultation/questions/consultation_question_type.dart';
import 'package:agora/domain/consultation/questions/responses/consultation_question_response.dart';
import 'package:agora/infrastructure/consultation/consultation_repository.dart';

// TODO suppress when debouncing is done
class MockConsultationSuccessRepository extends ConsultationDioRepository {
  MockConsultationSuccessRepository({required super.httpClient});

  @override
  Future<GetConsultationQuestionsRepositoryResponse> fetchConsultationQuestions({
    required String consultationId,
  }) async {
    return GetConsultationQuestionsSucceedResponse(
      consultationQuestions: [
        ConsultationQuestion(
          id: "questionIdD",
          label: "Donnez un feedback",
          order: 3,
          type: ConsultationQuestionType.ouverte,
          maxChoices: -1,
          responseChoices: [],
        ),
        ConsultationQuestion(
          id: "questionIdE",
          label: "Avez vous des conseilles à ajouter?",
          order: 5,
          type: ConsultationQuestionType.ouverte,
          maxChoices: -1,
          responseChoices: [],
        ),
        ConsultationQuestion(
          id: "questionIdB",
          label:
              "Si vous vous lancez dans le co-voiturage, vous pouvez bénéficier d’une prime de 100 euros. Etes-vous intéressé(e) pour vous lancer ?",
          order: 2,
          type: ConsultationQuestionType.unique,
          maxChoices: -1,
          responseChoices: [
            ConsultationQuestionResponseChoice(id: "choiceAA", label: "non", order: 2),
            ConsultationQuestionResponseChoice(id: "choiceBB", label: "oui", order: 1),
          ],
        ),
        ConsultationQuestion(
          id: "questionIdA",
          label: "Comment vous rendez-vous généralement sur votre lieu de travail ?",
          order: 1,
          type: ConsultationQuestionType.unique,
          maxChoices: -1,
          responseChoices: [
            ConsultationQuestionResponseChoice(id: "choiceA", label: "En vélo ou à pied", order: 4),
            ConsultationQuestionResponseChoice(id: "choiceB", label: "En co-voiturage", order: 2),
            ConsultationQuestionResponseChoice(id: "choiceC", label: "En transports en commun", order: 3),
            ConsultationQuestionResponseChoice(id: "choiceD", label: "Je ne suis pas concerné", order: 5),
            ConsultationQuestionResponseChoice(id: "choiceE", label: "En voiture, seul(e)", order: 1),
          ],
        ),
        ConsultationQuestion(
          id: "questionIdC",
          label: "Pour quelle raison principale ?",
          order: 4,
          type: ConsultationQuestionType.multiple,
          maxChoices: 3,
          responseChoices: [
            ConsultationQuestionResponseChoice(
              id: "choiceAAA",
              label: "Je veux être tranquille dans ma voiture",
              order: 4,
            ),
            ConsultationQuestionResponseChoice(
              id: "choiceBBB",
              label: "Je fais des trajets différents chaque jour",
              order: 2,
            ),
            ConsultationQuestionResponseChoice(
              id: "choiceCCC",
              label: "Je crains de ne pas être à l’heure en co-voiturant",
              order: 3,
            ),
            ConsultationQuestionResponseChoice(id: "choiceDDD", label: "Je crains pour ma sécurité", order: 5),
            ConsultationQuestionResponseChoice(
              id: "choiceEEE",
              label: "Je veux être flexible en cas d’imprévu",
              order: 1,
            ),
            ConsultationQuestionResponseChoice(id: "choiceFFF", label: "Autre", order: 6),
          ],
        ),
      ],
    );
  }

  @override
  Future<SendConsultationResponsesRepositoryResponse> sendConsultationResponses({
    required String consultationId,
    required List<ConsultationQuestionResponses> questionsResponses,
  }) async {
    return SendConsultationResponsesSucceedResponse();
  }
}
