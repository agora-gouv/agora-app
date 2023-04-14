import 'package:agora/common/client/agora_http_client.dart';
import 'package:agora/domain/consultation/details/consultation_details.dart';
import 'package:agora/domain/consultation/questions/consultation_question.dart';
import 'package:agora/domain/consultation/questions/consultation_question_response_choice.dart';
import 'package:agora/domain/consultation/questions/consultation_question_type.dart';
import 'package:agora/domain/consultation/questions/responses/consultation_question_response.dart';
import 'package:agora/domain/consultation/summary/consultation_summary.dart';
import 'package:agora/domain/consultation/summary/consultation_summary_et_ensuite.dart';
import 'package:agora/domain/consultation/summary/consultation_summary_results.dart';
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
          cover: response.data["coverUrl"] as String,
          thematiqueId: response.data["thematiqueId"] as String,
          endDate: DateTime.parse(response.data["endDate"] as String),
          questionCount: response.data["questionCount"] as String,
          estimatedTime: response.data["estimatedTime"] as String,
          participantCount: response.data["participantCount"] as int,
          participantCountGoal: response.data["participantCountGoal"] as int,
          description: response.data["description"] as String,
          tipsDescription: response.data["tipsDescription"] as String,
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

  @override
  Future<GetConsultationSummaryRepositoryResponse> fetchConsultationSummary({
    required String consultationId,
  }) async {
    return GetConsultationSummarySucceedResponse(
      consultationSummary: ConsultationSummary(
        title: "Développer le covoiturage au quotidien",
        participantCount: 15035,
        results: [
          ConsultationSummaryResults(
            questionTitle: "Les déplacements professionnels en covoiturage",
            responses: [
              ConsultationSummaryResponse(label: "En voiture seul", ratio: 65),
              ConsultationSummaryResponse(label: "En transports en commun, vélo, à pied", ratio: 17),
              ConsultationSummaryResponse(label: "Je ne suis pas concerné", ratio: 16),
              ConsultationSummaryResponse(label: "En co-voiturage", ratio: 2),
            ],
          ),
          ConsultationSummaryResults(
            questionTitle:
                "Si vous vous lancez dans le co-voiturage, vous pouvez bénéficier d’une prime de 100 euros. Etes-vous intéressé(e) pour vous lancer ?",
            responses: [
              ConsultationSummaryResponse(label: "Oui", ratio: 65),
              ConsultationSummaryResponse(label: "Non", ratio: 35),
            ],
          ),
          ConsultationSummaryResults(
            questionTitle: "Pour quelle raison principale ?",
            responses: [
              ConsultationSummaryResponse(label: "Je veux être tranquille dans ma voiture", ratio: 42),
              ConsultationSummaryResponse(label: "Je veux être flexible en cas d’imprévu", ratio: 25),
              ConsultationSummaryResponse(label: "Je crains pour ma sécurité", ratio: 16),
              ConsultationSummaryResponse(label: "Je crains de ne pas être à l’heure en co-voiturant", ratio: 8),
              ConsultationSummaryResponse(label: "Je fais des trajets différents chaque jour", ratio: 7),
              ConsultationSummaryResponse(label: "Autre", ratio: 2),
            ],
          ),
        ],
        etEnsuite: ConsultationSummaryEtEnsuite(
          step: 1,
          description:
              "<body>La description avec textes <b>en gras</b> et potentiellement des <a href=\"https://google.fr\">liens</a><br/><br/><ul><li>example1 <b>en gras</b></li><li>example2</li></ul></body>",
        ),
      ),
    );
  }
}
