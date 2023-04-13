import 'package:agora/common/client/agora_http_client.dart';
import 'package:agora/common/extension/consultation_question_type_extension.dart';
import 'package:agora/domain/consultation/details/consultation_details.dart';
import 'package:agora/domain/consultation/questions/consultation_question.dart';
import 'package:agora/domain/consultation/questions/consultation_question_response_choice.dart';
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
    try {
      final response = await httpClient.get("/consultations/$consultationId/questions");
      final questions = (response.data["questions"] as List)
          .map(
            (question) => ConsultationQuestion(
              id: question["id"] as String,
              label: question["label"] as String,
              order: question["order"] as int,
              type: (question["type"] as String).toConsultationQuestionType(),
              maxChoices: question["maxChoices"] as int?,
              responseChoices: (question["possibleChoices"] as List)
                  .map(
                    (responseChoice) => ConsultationQuestionResponseChoice(
                      id: responseChoice["id"] as String,
                      label: responseChoice["label"] as String,
                      order: responseChoice["order"] as int,
                    ),
                  )
                  .toList(),
            ),
          )
          .toList();
      return GetConsultationQuestionsSucceedResponse(consultationQuestions: questions);
    } catch (e) {
      return GetConsultationQuestionsFailedResponse();
    }
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
