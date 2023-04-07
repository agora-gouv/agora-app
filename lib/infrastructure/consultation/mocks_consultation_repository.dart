import 'package:agora/common/client/agora_http_client.dart';
import 'package:agora/domain/consultation/details/consultation_details.dart';
import 'package:agora/domain/consultation/questions/consultation_question.dart';
import 'package:agora/domain/consultation/questions/consultation_question_response_choice.dart';
import 'package:agora/domain/consultation/questions/consultation_question_type.dart';
import 'package:agora/domain/consultation/questions/responses/consultation_question_response.dart';
import 'package:agora/infrastructure/consultation/consultation_repository.dart';

// TODO suppress when debouncing is done
class MockConsultationSuccessRepository extends ConsultationRepository {
  final AgoraDioHttpClient httpClient;

  MockConsultationSuccessRepository({required this.httpClient});

  @override
  Future<GetConsultationDetailsRepositoryResponse> fetchConsultationDetails({
    required String consultationId,
  }) async {
    try {
      final response = await httpClient.get("/consultations/$consultationId");
      return GetConsultationDetailsSucceedResponse(
        consultationDetails: ConsultationDetails(
          id: response.data["id"] as String,
          title: response.data["title"] as String,
          cover: response.data["cover"] as String,
          thematiqueId: response.data["thematique_id"] as String,
          endDate: DateTime.parse(response.data["end_date"] as String),
          questionCount: response.data["question_count"] as String,
          estimatedTime: response.data["estimated_time"] as String,
          participantCount: response.data["participant_count"] as int,
          participantCountGoal: response.data["participant_count_goal"] as int,
          description: response.data["description"] as String,
          tipsDescription: response.data["tips_description"] as String,
        ),
      );
    } catch (e) {
      return GetConsultationDetailsFailedResponse();
    }
  }

  @override
  Future<GetConsultationQuestionsRepositoryResponse> fetchConsultationQuestions({
    required String consultationId,
  }) async {
    return GetConsultationQuestionsSucceedResponse(
      consultationQuestions: [
        ConsultationQuestion(
          id: "questionIdB",
          label:
              "Si vous vous lancez dans le co-voiturage, vous pouvez bénéficier d’une prime de 100 euros. Etes-vous intéressé(e) pour vous lancer ?",
          order: 2,
          type: ConsultationQuestionType.unique,
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
          order: 3,
          type: ConsultationQuestionType.unique,
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
    required List<ConsultationQuestionResponse> questionsResponses,
  }) async {
    return SendConsultationResponsesSucceedResponse();
  }
}
