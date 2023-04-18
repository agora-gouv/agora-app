import 'package:agora/domain/consultation/questions/consultation_question.dart';
import 'package:agora/domain/consultation/questions/consultation_question_response_choice.dart';
import 'package:agora/domain/consultation/questions/responses/consultation_question_response.dart';
import 'package:agora/domain/consultation/summary/consultation_summary.dart';
import 'package:agora/domain/consultation/summary/consultation_summary_et_ensuite.dart';
import 'package:agora/domain/consultation/summary/consultation_summary_results.dart';
import 'package:agora/infrastructure/consultation/repository/consultation_repository.dart';

// TODO suppress when debouncing is done
class MockConsultationSuccessRepository extends ConsultationDioRepository {
  MockConsultationSuccessRepository({required super.httpClient});

  @override
  Future<GetConsultationQuestionsRepositoryResponse> fetchConsultationQuestions({
    required String consultationId,
  }) async {
    return GetConsultationQuestionsSucceedResponse(
      consultationQuestions: [
        ConsultationQuestionUnique(
          id: "questionIdB",
          title: "Si vous vous lancez dans le co-voiturage, ...",
          order: 7,
          questionProgress: "Question 5/5",
          responseChoices: [
            ConsultationQuestionResponseChoice(id: "choiceAA", label: "non", order: 2),
            ConsultationQuestionResponseChoice(id: "choiceBB", label: "oui", order: 1),
          ],
        ),
        ConsultationQuestionUnique(
          id: "questionIdE",
          title: "Question EEE",
          order: 6,
          questionProgress: "Question 4/5",
          responseChoices: [
            ConsultationQuestionResponseChoice(id: "choiceAA", label: "non", order: 2),
            ConsultationQuestionResponseChoice(id: "choiceBB", label: "oui", order: 1),
          ],
        ),
        ConsultationQuestionOpened(
          id: "questionIdC",
          title: "Question C ?",
          order: 5,
          questionProgress: "Question 3/5",
        ),
        ConsultationQuestionChapter(
          id: "chapiter2",
          title: "titre du chapitre2",
          order: 4,
          description:
              "<body>La description avec textes <b>en gras</b> et potentiellement des <a href=\"https://google.fr\">liens</a><br/><br/><ul><li>example1 <b>en gras</b></li><li>example2</li></ul></body>",
        ),
        ConsultationQuestionOpened(
          id: "questionIdD",
          title: "Question D ?",
          order: 3,
          questionProgress: "Question 2/5",
        ),
        ConsultationQuestionMultiple(
          id: "questionIdA",
          title: "Comment vous rendez-vous généralement sur votre lieu de travail ?",
          order: 2,
          questionProgress: "Question 1/5",
          maxChoices: 2,
          responseChoices: [
            ConsultationQuestionResponseChoice(id: "choiceA", label: "En vélo ou à pied", order: 3),
            ConsultationQuestionResponseChoice(id: "choiceB", label: "En voiture", order: 1),
            ConsultationQuestionResponseChoice(id: "choiceC", label: "En transports en commun", order: 2),
          ],
        ),
        ConsultationQuestionChapter(
          id: "chapiter1",
          title: "titre du chapitre",
          order: 1,
          description:
              "<body>La description avec textes <b>en gras</b> et potentiellement des <a href=\"https://google.fr\">liens</a><br/><br/><ul><li>example1 <b>en gras</b></li><li>example2</li></ul></body>",
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
          ConsultationSummaryUniqueChoiceResults(
            questionTitle: "Les déplacements professionnels en covoiturage",
            order: 3,
            responses: [
              ConsultationSummaryResponse(label: "En voiture seul", ratio: 65),
              ConsultationSummaryResponse(label: "En transports en commun, vélo, à pied", ratio: 17),
              ConsultationSummaryResponse(label: "Je ne suis pas concerné", ratio: 16),
              ConsultationSummaryResponse(label: "En co-voiturage", ratio: 2),
            ],
          ),
          ConsultationSummaryMultipleChoicesResults(
            questionTitle:
                "Si vous vous lancez dans le co-voiturage, vous pouvez bénéficier d’une prime de 100 euros. Etes-vous intéressé(e) pour vous lancer ?",
            order: 2,
            responses: [
              ConsultationSummaryResponse(label: "Oui", ratio: 65),
              ConsultationSummaryResponse(label: "Non", ratio: 35),
            ],
          ),
          ConsultationSummaryMultipleChoicesResults(
            questionTitle: "Pour quelle raison principale ?",
            order: 1,
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
