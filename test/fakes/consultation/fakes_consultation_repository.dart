import 'package:agora/domain/consultation/details/consultation_details.dart';
import 'package:agora/domain/consultation/questions/consultation_question.dart';
import 'package:agora/domain/consultation/questions/consultation_question_response_choice.dart';
import 'package:agora/domain/consultation/questions/consultation_question_type.dart';
import 'package:agora/domain/consultation/questions/responses/consultation_question_response.dart';
import 'package:agora/domain/consultation/summary/consultation_summary.dart';
import 'package:agora/domain/consultation/summary/consultation_summary_et_ensuite.dart';
import 'package:agora/domain/consultation/summary/consultation_summary_results.dart';
import 'package:agora/infrastructure/consultation/consultation_repository.dart';

class FakeConsultationSuccessRepository extends ConsultationRepository {
  @override
  Future<GetConsultationDetailsRepositoryResponse> fetchConsultationDetails({
    required String consultationId,
  }) async {
    return GetConsultationDetailsSucceedResponse(
      consultationDetails: ConsultationDetails(
        id: "consultationId",
        title: "Développer le covoiturage au quotidien",
        cover: "imageEnBase64",
        thematiqueId: "7",
        endDate: DateTime(2023, 3, 3),
        questionCount: "5 à 10 questions",
        estimatedTime: "5 minutes",
        participantCount: 15035,
        participantCountGoal: 30000,
        description: "<body>La description avec textes <b>en gras</b></body>",
        tipsDescription: "<body>texte <i>riche</i></body>",
      ),
    );
  }

  @override
  Future<GetConsultationQuestionsRepositoryResponse> fetchConsultationQuestions({
    required String consultationId,
  }) async {
    return GetConsultationQuestionsSucceedResponse(
      consultationQuestions: [
        ConsultationQuestion(
          id: "questionIdB",
          label: "Si vous vous lancez dans le co-voiturage, ...",
          order: 2,
          type: ConsultationQuestionType.unique,
          maxChoices: null,
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
          maxChoices: null,
          responseChoices: [
            ConsultationQuestionResponseChoice(id: "choiceA", label: "En vélo ou à pied", order: 1),
            ConsultationQuestionResponseChoice(id: "choiceC", label: "En transports en commun", order: 2),
          ],
        ),
        ConsultationQuestion(
          id: "questionIdC",
          label: "Question C ?",
          order: 3,
          type: ConsultationQuestionType.multiple,
          maxChoices: 2,
          responseChoices: [
            ConsultationQuestionResponseChoice(id: "choiceAAA", label: "En vélo ou à pied", order: 1),
            ConsultationQuestionResponseChoice(id: "choiceCCC", label: "En transports en commun", order: 3),
            ConsultationQuestionResponseChoice(id: "choiceBBB", label: "En voiture", order: 2),
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
              ConsultationSummaryResponse(label: "Autres", ratio: 18),
            ],
          ),
          ConsultationSummaryResults(
            questionTitle: "Pour quelle raison principale ?",
            responses: [
              ConsultationSummaryResponse(label: "Je veux être tranquille dans ma voiture", ratio: 42),
              ConsultationSummaryResponse(label: "Autres", ratio: 58),
            ],
          ),
        ],
        etEnsuite: ConsultationSummaryEtEnsuite(step: 1, description: "<body>textRiche</body>"),
      ),
    );
  }
}

class FakeConsultationFailureRepository extends ConsultationRepository {
  @override
  Future<GetConsultationDetailsRepositoryResponse> fetchConsultationDetails({
    required String consultationId,
  }) async {
    return GetConsultationDetailsFailedResponse();
  }

  @override
  Future<GetConsultationQuestionsRepositoryResponse> fetchConsultationQuestions({
    required String consultationId,
  }) async {
    return GetConsultationQuestionsFailedResponse();
  }

  @override
  Future<SendConsultationResponsesRepositoryResponse> sendConsultationResponses({
    required String consultationId,
    required List<ConsultationQuestionResponses> questionsResponses,
  }) async {
    return SendConsultationResponsesFailureResponse();
  }

  @override
  Future<GetConsultationSummaryRepositoryResponse> fetchConsultationSummary({
    required String consultationId,
  }) async {
    return GetConsultationSummaryFailedResponse();
  }
}
