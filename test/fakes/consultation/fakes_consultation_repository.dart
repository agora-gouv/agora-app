import 'package:agora/domain/consultation/consultation.dart';
import 'package:agora/domain/consultation/consultations_error_type.dart';
import 'package:agora/domain/consultation/details/consultation_details.dart';
import 'package:agora/domain/consultation/questions/consultation_question.dart';
import 'package:agora/domain/consultation/questions/consultation_question_response_choice.dart';
import 'package:agora/domain/consultation/questions/responses/consultation_question_response.dart';
import 'package:agora/domain/consultation/summary/consultation_summary.dart';
import 'package:agora/domain/consultation/summary/consultation_summary_et_ensuite.dart';
import 'package:agora/domain/consultation/summary/consultation_summary_results.dart';
import 'package:agora/domain/thematique/thematique.dart';
import 'package:agora/infrastructure/consultation/repository/consultation_repository.dart';

class FakeConsultationSuccessRepository extends ConsultationRepository {
  @override
  Future<GetConsultationsRepositoryResponse> fetchConsultations() async {
    return GetConsultationsSucceedResponse(
      ongoingConsultations: [
        ConsultationOngoing(
          id: "consultationId",
          title: "Développer le covoiturage au quotidien",
          coverUrl: "coverUrl1",
          thematique: Thematique(picto: "🚊", label: "Transports"),
          endDate: DateTime(2024, 1, 23),
          hasAnswered: false,
          highlightLabel: "Plus que 3 jours",
        )
      ],
      finishedConsultations: [
        ConsultationFinished(
          id: "consultationId2",
          title: "Quelles solutions pour les déserts médicaux ?",
          coverUrl: "coverUrl2",
          thematique: Thematique(picto: "🩺", label: "Santé"),
          step: 2,
        ),
      ],
      answeredConsultations: [
        ConsultationAnswered(
          id: "consultationId3",
          title: "Quand commencer ?",
          coverUrl: "coverUrl3",
          thematique: Thematique(picto: "🩺", label: "Santé"),
          step: 3,
        ),
      ],
    );
  }

  @override
  Future<GetConsultationDetailsRepositoryResponse> fetchConsultationDetails({
    required String consultationId,
  }) async {
    return GetConsultationDetailsSucceedResponse(
      consultationDetails: ConsultationDetails(
        id: "consultationId",
        title: "Développer le covoiturage au quotidien",
        coverUrl: "coverUrl",
        thematique: Thematique(picto: "🚊", label: "Transports"),
        endDate: DateTime(2023, 3, 3),
        questionCount: "5 à 10 questions",
        estimatedTime: "5 minutes",
        participantCount: 15035,
        participantCountGoal: 30000,
        description: "<body>La description avec textes <b>en gras</b></body>",
        tipsDescription: "<body>texte <i>riche</i></body>",
        hasAnswered: true,
      ),
    );
  }

  @override
  Future<GetConsultationQuestionsRepositoryResponse> fetchConsultationQuestions({
    required String consultationId,
  }) async {
    return GetConsultationQuestionsSucceedResponse(
      consultationQuestions: [
        ConsultationQuestionUnique(
          id: "questionIdB",
          title: "Si vous vous lancez dans le co-voiturage, ...",
          order: 4,
          questionProgress: "Question 3/4",
          responseChoices: [
            ConsultationQuestionResponseChoice(id: "choiceAA", label: "non", order: 2),
            ConsultationQuestionResponseChoice(id: "choiceBB", label: "oui", order: 1),
          ],
          nextQuestionId: "questionIdC",
          popupDescription: "<body>La description avec textes <b>en gras</b></body>",
        ),
        ConsultationQuestionOpened(
          id: "questionIdC",
          title: "Question C ?",
          order: 5,
          questionProgress: "Question 4/4",
          nextQuestionId: null,
          popupDescription: null,
        ),
        ConsultationQuestionMultiple(
          id: "questionIdA",
          title: "Comment vous rendez-vous généralement sur votre lieu de travail ?",
          order: 1,
          questionProgress: "Question 1/4",
          maxChoices: 2,
          responseChoices: [
            ConsultationQuestionResponseChoice(id: "choiceA", label: "En vélo ou à pied", order: 3),
            ConsultationQuestionResponseChoice(id: "choiceB", label: "En voiture", order: 1),
            ConsultationQuestionResponseChoice(id: "choiceC", label: "En transports en commun", order: 2),
          ],
          nextQuestionId: "questionIdD",
          popupDescription: "<body>La description avec textes <b>en gras</b></body>",
        ),
        ConsultationQuestionWithCondition(
          id: "questionIdD",
          title: "Avez vous ...?",
          order: 2,
          questionProgress: "Question 2/4",
          responseChoices: [
            ConsultationQuestionResponseWithConditionChoice(
              id: "choiceAAA",
              label: "non",
              order: 2,
              nextQuestionId: "questionIdB",
            ),
            ConsultationQuestionResponseWithConditionChoice(
              id: "choiceBBB",
              label: "oui",
              order: 1,
              nextQuestionId: "questionIdC",
            ),
          ],
          popupDescription: "<body>La description avec textes <b>en gras</b></body>",
        ),
        ConsultationQuestionChapter(
          id: "chapiter1",
          title: "titre du chapitre",
          order: 3,
          description: "description du chapitre",
          nextQuestionId: "questionIdB",
        ),
      ],
    );
  }

  @override
  Future<SendConsultationResponsesRepositoryResponse> sendConsultationResponses({
    required String consultationId,
    required List<ConsultationQuestionResponses> questionsResponses,
  }) async {
    return SendConsultationResponsesSucceedResponse(shouldDisplayDemographicInformation: true);
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
            order: 2,
            responses: [
              ConsultationSummaryResponse(label: "En voiture seul", ratio: 65),
              ConsultationSummaryResponse(label: "En transports en commun, vélo, à pied", ratio: 17),
              ConsultationSummaryResponse(label: "Autres", ratio: 18),
            ],
          ),
          ConsultationSummaryMultipleChoicesResults(
            questionTitle: "Pour quelle raison principale ?",
            order: 1,
            responses: [
              ConsultationSummaryResponse(label: "Je veux être tranquille dans ma voiture", ratio: 42),
              ConsultationSummaryResponse(label: "Autres", ratio: 58),
            ],
          ),
        ],
        etEnsuite: ConsultationSummaryEtEnsuite(
          step: 1,
          description: "<body>textRiche</body>",
          explanationsTitle: "explanations title",
          explanations: [
            ConsultationSummaryEtEnsuiteExplanation(
              isTogglable: false,
              title: "toogle text title",
              intro: "<body>image introduction</body>",
              imageUrl: "<imageURL>",
              description: "<body>image description</body>",
            ),
          ],
          video: ConsultationSummaryEtEnsuiteVideo(
            title: "video title",
            intro: "<body>video intro</body>",
            videoUrl: "<videoUrl>",
            videoWidth: 1080,
            videoHeight: 1920,
            transcription: "transcription video",
          ),
          conclusion: ConsultationSummaryEtEnsuiteConclusion(
            title: "conclusion title",
            description: "<body>conclusion description</body>",
          ),
        ),
      ),
    );
  }
}

class FakeConsultationSuccessWithFinishedConsultationEmptyRepository extends FakeConsultationSuccessRepository {
  @override
  Future<GetConsultationsRepositoryResponse> fetchConsultations() async {
    return GetConsultationsSucceedResponse(
      ongoingConsultations: [
        ConsultationOngoing(
          id: "consultationId",
          title: "Développer le covoiturage au quotidien",
          coverUrl: "coverUrl",
          thematique: Thematique(picto: "🚊", label: "Transports"),
          endDate: DateTime(2024, 1, 23),
          hasAnswered: false,
          highlightLabel: null,
        )
      ],
      finishedConsultations: [],
      answeredConsultations: [],
    );
  }
}

class FakeConsultationFailureRepository extends ConsultationRepository {
  @override
  Future<GetConsultationsRepositoryResponse> fetchConsultations() async {
    return GetConsultationsFailedResponse();
  }

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

class FakeConsultationTimeoutFailureRepository extends FakeConsultationFailureRepository {
  @override
  Future<GetConsultationsRepositoryResponse> fetchConsultations() async {
    return GetConsultationsFailedResponse(errorType: ConsultationsErrorType.timeout);
  }
}

class FakeConsultationEtEnsuiteWithNullExplanationsAndNullVideoRepository extends FakeConsultationSuccessRepository {
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
            order: 2,
            responses: [
              ConsultationSummaryResponse(label: "En voiture seul", ratio: 65),
              ConsultationSummaryResponse(label: "En transports en commun, vélo, à pied", ratio: 17),
              ConsultationSummaryResponse(label: "Autres", ratio: 18),
            ],
          ),
          ConsultationSummaryMultipleChoicesResults(
            questionTitle: "Pour quelle raison principale ?",
            order: 1,
            responses: [
              ConsultationSummaryResponse(label: "Je veux être tranquille dans ma voiture", ratio: 42),
              ConsultationSummaryResponse(label: "Autres", ratio: 58),
            ],
          ),
        ],
        etEnsuite: ConsultationSummaryEtEnsuite(
          step: 1,
          description: "<body>textRiche</body>",
          explanationsTitle: null,
          explanations: [
            ConsultationSummaryEtEnsuiteExplanation(
              isTogglable: false,
              title: "toogle text title",
              intro: "<body>image introduction</body>",
              imageUrl: "<imageURL>",
              description: "<body>image description</body>",
            ),
          ],
          video: null,
          conclusion: null,
        ),
      ),
    );
  }
}
