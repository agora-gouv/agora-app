import 'package:agora/consultation/domain/consultation.dart';
import 'package:agora/consultation/domain/consultation_summary_results.dart';
import 'package:agora/consultation/domain/consultations_error_type.dart';
import 'package:agora/consultation/dynamic/domain/dynamic_consultation.dart';
import 'package:agora/consultation/question/domain/consultation_question.dart';
import 'package:agora/consultation/question/domain/consultation_question_response.dart';
import 'package:agora/consultation/question/domain/consultation_question_response_choice.dart';
import 'package:agora/consultation/question/domain/consultation_questions.dart';
import 'package:agora/consultation/repository/consultation_repository.dart';
import 'package:agora/consultation/repository/consultation_responses.dart';
import 'package:agora/territorialisation/territoire.dart';
import 'package:agora/thematique/domain/thematique.dart';

class FakeConsultationSuccessRepository extends ConsultationRepository {
  FakeConsultationSuccessRepository([this.dynamicConsultation]);

  final DynamicConsultation? dynamicConsultation;

  @override
  Future<GetConsultationsRepositoryResponse> fetchConsultations() async {
    return GetConsultationsSucceedResponse(
      ongoingConsultations: [
        ConsultationOngoing(
          id: "consultationId",
          slug: "consultationId",
          title: "Développer le covoiturage au quotidien",
          coverUrl: "coverUrl1",
          thematique: Thematique(picto: "🚊", label: "Transports"),
          endDate: DateTime(2024, 1, 23),
          label: "Plus que 3 jours",
          territoire: "Paris",
        ),
      ],
      finishedConsultations: [
        ConsultationFinished(
          id: "consultationId2",
          slug: "consultationId2",
          title: "Quelles solutions pour les déserts médicaux ?",
          coverUrl: "coverUrl2",
          thematique: Thematique(picto: "🩺", label: "Santé"),
          label: 'label',
          territoire: "Paris",
        ),
      ],
      answeredConsultations: [
        ConsultationAnswered(
          id: "consultationId3",
          slug: "consultationId3",
          title: "Quand commencer ?",
          coverUrl: "coverUrl3",
          thematique: Thematique(picto: "🩺", label: "Santé"),
          label: 'label',
          territoire: "Paris",
        ),
      ],
    );
  }

  @override
  Future<GetConsultationsFinishedPaginatedRepositoryResponse> fetchConsultationsFinishedPaginated({
    required int pageNumber,
    Territoire? territoire,
  }) async {
    return GetConsultationsPaginatedSucceedResponse(
      maxPage: 3,
      consultationsPaginated: [
        ConsultationFinished(
          id: "consultationId",
          slug: "consultationId",
          title: "Quelles solutions pour les déserts médicaux ?",
          coverUrl: "coverUrl",
          thematique: Thematique(picto: "🩺", label: "Santé"),
          label: 'label',
          territoire: "Paris",
        ),
      ],
    );
  }

  @override
  Future<GetConsultationQuestionsRepositoryResponse> fetchConsultationQuestions({
    required String consultationId,
  }) async {
    return GetConsultationQuestionsSucceedResponse(
      consultationQuestions: ConsultationQuestions(
        questionCount: 5,
        questions: [
          ConsultationQuestionUnique(
            id: "questionIdB",
            title: "Si vous vous lancez dans le co-voiturage, ...",
            order: 4,
            responseChoices: [
              ConsultationQuestionResponseChoice(id: "choiceAA", label: "non", order: 2, hasOpenTextField: false),
              ConsultationQuestionResponseChoice(id: "choiceBB", label: "oui", order: 1, hasOpenTextField: false),
              ConsultationQuestionResponseChoice(
                id: "choiceCC",
                label: "Autre (précisez)",
                order: 3,
                hasOpenTextField: true,
              ),
            ],
            nextQuestionId: "questionIdC",
            popupDescription: "<body>La description avec textes <b>en gras</b></body>",
          ),
          ConsultationQuestionOpened(
            id: "questionIdC",
            title: "Question C ?",
            order: 5,
            nextQuestionId: null,
            popupDescription: null,
          ),
          ConsultationQuestionMultiple(
            id: "questionIdA",
            title: "Comment vous rendez-vous généralement sur votre lieu de travail ?",
            order: 1,
            maxChoices: 2,
            responseChoices: [
              ConsultationQuestionResponseChoice(
                id: "choiceA",
                label: "En vélo ou à pied 🚲",
                order: 3,
                hasOpenTextField: false,
              ),
              ConsultationQuestionResponseChoice(
                id: "choiceB",
                label: "En voiture 🚗",
                order: 1,
                hasOpenTextField: false,
              ),
              ConsultationQuestionResponseChoice(
                id: "choiceC",
                label: "En transports en commun 🚃",
                order: 2,
                hasOpenTextField: false,
              ),
              ConsultationQuestionResponseChoice(
                id: "choiceD",
                label: "Autre (précisez)",
                order: 4,
                hasOpenTextField: true,
              ),
            ],
            nextQuestionId: "questionIdD",
            popupDescription: "<body>La description avec textes <b>en gras</b></body>",
          ),
          ConsultationQuestionWithCondition(
            id: "questionIdD",
            title: "Avez vous ...?",
            order: 2,
            responseChoices: [
              ConsultationQuestionResponseWithConditionChoice(
                id: "choiceAAA",
                label: "non",
                order: 2,
                nextQuestionId: "questionIdB",
                hasOpenTextField: false,
              ),
              ConsultationQuestionResponseWithConditionChoice(
                id: "choiceBBB",
                label: "oui",
                order: 1,
                nextQuestionId: "questionIdC",
                hasOpenTextField: false,
              ),
              ConsultationQuestionResponseWithConditionChoice(
                id: "choiceCCC",
                label: "Autre (précisez)",
                order: 3,
                nextQuestionId: "questionIdB",
                hasOpenTextField: true,
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
            imageUrl: "https://url.com/image.jpg",
          ),
        ],
      ),
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
  Future<DynamicConsultationResponse> getDynamicConsultation(String consultationId) async {
    if (dynamicConsultation != null) {
      return DynamicConsultationSuccessResponse(dynamicConsultation!);
    }
    return DynamicConsultationErrorResponse();
  }

  @override
  Future<DynamicConsultationResultsResponse> fetchDynamicConsultationResults({required String consultationId}) async {
    return DynamicConsultationsResultsSuccessResponse(
      title: "Développer le covoiturage au quotidien",
      coverUrl: "coverUrl",
      participantCount: 1200,
      results: [
        ConsultationSummaryUniqueChoiceResults(
          questionTitle: "Les déplacements professionnels en covoiturage",
          order: 1,
          seenRatio: 100,
          responses: [
            ConsultationSummaryResponse(label: "En voiture seul", ratio: 65, isUserResponse: true),
            ConsultationSummaryResponse(label: "Autre", ratio: 35),
          ],
        ),
      ],
    );
  }

  @override
  Future<DynamicConsultationUpdateResponse> fetchDynamicConsultationUpdate({
    required String updateId,
    required String consultationId,
  }) async {
    final update = DynamicConsultationUpdate(
      id: 'id',
      shareText: 'shareText',
      responseInfos: null,
      infoHeader: null,
      previewSections: [],
      expandedSections: [],
      participationInfo: null,
      downloadInfo: null,
      feedbackQuestion: null,
      feedbackResult: null,
      footer: null,
      consultationDatesInfos: null,
      title: 'title',
      coverUrl: 'coverUrl',
      thematicLogo: 'logo',
      thematicLabel: 'label',
      headerSections: [],
      goals: [],
    );
    return DynamicConsultationUpdateSuccessResponse(update);
  }

  @override
  Future<GetConsultationsFinishedPaginatedRepositoryResponse> fetchConsultationsAnsweredPaginated({
    required int pageNumber,
  }) async {
    return GetConsultationsPaginatedSucceedResponse(
      maxPage: 3,
      consultationsPaginated: [
        ConsultationFinished(
          id: "consultationId",
          slug: "consultationId",
          title: "Quelles solutions pour les déserts médicaux ?",
          coverUrl: "coverUrl",
          thematique: Thematique(picto: "🩺", label: "Santé"),
          label: 'label',
          territoire: "Paris",
        ),
      ],
    );
  }

  @override
  Future<void> sendConsultationUpdateFeedback(String updateId, String consultationId, bool isPositive) async {}

  @override
  Future<void> deleteConsultationUpdateFeedback(String updateId, String consultationId) async {}

  @override
  bool get isFetchConsultationDataCached => false;
}

class FakeConsultationSuccessWithFinishedConsultationEmptyRepository extends FakeConsultationSuccessRepository {
  @override
  Future<GetConsultationsRepositoryResponse> fetchConsultations() async {
    return GetConsultationsSucceedResponse(
      ongoingConsultations: [
        ConsultationOngoing(
          id: "consultationId",
          slug: "consultationId",
          title: "Développer le covoiturage au quotidien",
          coverUrl: "coverUrl",
          thematique: Thematique(picto: "🚊", label: "Transports"),
          endDate: DateTime(2024, 1, 23),
          label: null,
          territoire: "Paris",
        ),
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
  Future<GetConsultationsFinishedPaginatedRepositoryResponse> fetchConsultationsFinishedPaginated({
    required int pageNumber,
    Territoire? territoire,
  }) async {
    return GetConsultationsFinishedPaginatedFailedResponse();
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
  Future<DynamicConsultationResponse> getDynamicConsultation(String consultationId) async {
    return DynamicConsultationErrorResponse();
  }

  @override
  Future<DynamicConsultationResultsResponse> fetchDynamicConsultationResults({required String consultationId}) async {
    return DynamicConsultationsResultsErrorResponse();
  }

  @override
  Future<DynamicConsultationUpdateResponse> fetchDynamicConsultationUpdate({
    required String updateId,
    required String consultationId,
  }) async {
    return DynamicConsultationUpdateErrorResponse();
  }

  @override
  Future<GetConsultationsFinishedPaginatedRepositoryResponse> fetchConsultationsAnsweredPaginated({
    required int pageNumber,
  }) async {
    return GetConsultationsFinishedPaginatedFailedResponse();
  }

  @override
  Future<void> sendConsultationUpdateFeedback(String updateId, String consultationId, bool isPositive) async {}

  @override
  Future<void> deleteConsultationUpdateFeedback(String updateId, String consultationId) async {}

  @override
  bool get isFetchConsultationDataCached => false;
}

class FakeConsultationTimeoutFailureRepository extends FakeConsultationFailureRepository {
  @override
  Future<GetConsultationsRepositoryResponse> fetchConsultations() async {
    return GetConsultationsFailedResponse(errorType: ConsultationsErrorType.timeout);
  }

  @override
  Future<GetConsultationsFinishedPaginatedRepositoryResponse> fetchConsultationsAnsweredPaginated({
    required int pageNumber,
  }) async {
    return GetConsultationsFinishedPaginatedFailedResponse();
  }
}
