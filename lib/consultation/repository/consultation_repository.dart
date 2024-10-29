import 'package:agora/common/client/agora_http_client.dart';
import 'package:agora/common/extension/date_extension.dart';
import 'package:agora/common/extension/thematique_extension.dart';
import 'package:agora/common/log/sentry_wrapper.dart';
import 'package:agora/consultation/domain/consultation.dart';
import 'package:agora/consultation/domain/consultations_error_type.dart';
import 'package:agora/consultation/dynamic/domain/dynamic_consultation.dart';
import 'package:agora/consultation/dynamic/repository/dynamic_consultation_mapper.dart';
import 'package:agora/consultation/question/domain/consultation_question_response.dart';
import 'package:agora/consultation/question/domain/consultation_questions.dart';
import 'package:agora/consultation/question/repository/consultation_question_storage_client.dart';
import 'package:agora/consultation/repository/consultation_mapper.dart';
import 'package:agora/consultation/repository/consultation_questions_builder.dart';
import 'package:agora/consultation/repository/consultation_responses.dart';
import 'package:agora/referentiel/territoire.dart';
import 'package:dio/dio.dart';

abstract class ConsultationRepository {
  Future<GetConsultationsRepositoryResponse> fetchConsultations();

  Future<GetConsultationsFinishedPaginatedRepositoryResponse> fetchConsultationsFinishedPaginated({
    required int pageNumber,
    Territoire? territoire,
  });

  Future<GetConsultationsFinishedPaginatedRepositoryResponse> fetchConsultationsAnsweredPaginated({
    required int pageNumber,
  });

  Future<GetConsultationQuestionsRepositoryResponse> fetchConsultationQuestions({
    required String consultationId,
  });

  Future<SendConsultationResponsesRepositoryResponse> sendConsultationResponses({
    required String consultationId,
    required List<ConsultationQuestionResponses> questionsResponses,
  });

  Future<DynamicConsultationResponse> getDynamicConsultation(String consultationId);

  Future<DynamicConsultationResultsResponse> fetchDynamicConsultationResults({
    required String consultationId,
  });

  Future<DynamicConsultationUpdateResponse> fetchDynamicConsultationUpdate({
    required String updateId,
    required String consultationId,
  });

  Future<void> sendConsultationUpdateFeedback(String updateId, String consultationId, bool isPositive);

  Future<void> deleteConsultationUpdateFeedback(String updateId, String consultationId);

  GetConsultationsRepositoryResponse? get consultationsResponse;
}

class ConsultationDioRepository extends ConsultationRepository {
  final AgoraDioHttpClient httpClient;
  final SentryWrapper sentryWrapper;
  final Duration minimalSendingTime;
  final ConsultationQuestionStorageClient storageClient;
  final ConsultationMapper mapper;

  ConsultationDioRepository({
    required this.httpClient,
    required this.sentryWrapper,
    this.minimalSendingTime = const Duration(seconds: 2),
    required this.storageClient,
    required this.mapper,
  });

  @override
  GetConsultationsRepositoryResponse? consultationsResponse;

  @override
  Future<GetConsultationsRepositoryResponse> fetchConsultations() async {
    const uri = "/consultations";
    try {
      final response = await httpClient.get(uri);
      final ongoingConsultations = response.data["ongoing"] as List;
      final finishedConsultations = response.data["finished"] as List;
      final answeredConsultations = response.data["answered"] as List;
      final getConsultationsResponse = GetConsultationsSucceedResponse(
        ongoingConsultations: ongoingConsultations.map((ongoingConsultation) {
          return ConsultationOngoing(
            id: ongoingConsultation["id"] as String,
            slug: ongoingConsultation['slug'] as String,
            title: ongoingConsultation["title"] as String,
            coverUrl: ongoingConsultation["coverUrl"] as String,
            thematique: (ongoingConsultation["thematique"] as Map).toThematique(),
            endDate: (ongoingConsultation["endDate"] as String).parseToDateTime(),
            label: ongoingConsultation["highlightLabel"] as String?,
            territoire: ongoingConsultation["territory"] as String? ?? "",
          );
        }).toList(),
        finishedConsultations: finishedConsultations.map((finishedConsultation) {
          return ConsultationFinished(
            id: finishedConsultation["id"] as String,
            slug: finishedConsultation['slug'] as String,
            title: finishedConsultation["title"] as String,
            coverUrl: finishedConsultation["coverUrl"] as String,
            thematique: (finishedConsultation["thematique"] as Map).toThematique(),
            label: finishedConsultation["updateLabel"] as String?,
            updateDate: (finishedConsultation["updateDate"] as String).parseToDateTime(),
            territoire: finishedConsultation["territory"] as String? ?? "",
          );
        }).toList(),
        answeredConsultations: answeredConsultations.map((answeredConsultation) {
          return ConsultationAnswered(
            id: answeredConsultation["id"] as String,
            slug: answeredConsultation['slug'] as String,
            title: answeredConsultation["title"] as String,
            coverUrl: answeredConsultation["coverUrl"] as String,
            thematique: (answeredConsultation["thematique"] as Map).toThematique(),
            label: answeredConsultation["updateLabel"] as String?,
            territoire: answeredConsultation["territory"] as String? ?? "",
          );
        }).toList(),
      );
      consultationsResponse = getConsultationsResponse;
      return getConsultationsResponse;
    } catch (exception, stacktrace) {
      if (exception is DioException) {
        if (exception.type == DioExceptionType.connectionTimeout || exception.type == DioExceptionType.receiveTimeout) {
          return GetConsultationsFailedResponse(errorType: ConsultationsErrorType.timeout);
        }
      }
      sentryWrapper.captureException(exception, stacktrace, message: "Erreur lors de l'appel : $uri");
      final getConsultationsResponse = GetConsultationsFailedResponse();
      consultationsResponse = getConsultationsResponse;
      return getConsultationsResponse;
    }
  }

  @override
  Future<GetConsultationsFinishedPaginatedRepositoryResponse> fetchConsultationsAnsweredPaginated({
    required int pageNumber,
  }) async {
    final uri = "/consultations/answered/$pageNumber";
    try {
      final response = await httpClient.get(uri);
      return GetConsultationsPaginatedSucceedResponse(
        maxPage: response.data["maxPageNumber"] as int,
        consultationsPaginated: (response.data["consultations"] as List).map((consultation) {
          return ConsultationFinished(
            id: consultation["id"] as String,
            slug: consultation['slug'] as String,
            title: consultation["title"] as String,
            coverUrl: consultation["coverUrl"] as String,
            thematique: (consultation["thematique"] as Map).toThematique(),
            label: consultation["label"] as String?,
            territoire: consultation["territory"] as String? ?? "",
          );
        }).toList(),
      );
    } catch (exception, stacktrace) {
      sentryWrapper.captureException(exception, stacktrace, message: "Erreur lors de l'appel : $uri");
      return GetConsultationsFinishedPaginatedFailedResponse();
    }
  }

  @override
  Future<GetConsultationsFinishedPaginatedRepositoryResponse> fetchConsultationsFinishedPaginated({
    required int pageNumber,
    Territoire? territoire,
  }) async {
    String uri = "/consultations/finished/$pageNumber";
    if (territoire != null) {
      uri = "$uri?territory=${territoire.label}";
    }
    try {
      final response = await httpClient.get(uri);
      return GetConsultationsPaginatedSucceedResponse(
        maxPage: response.data["maxPageNumber"] as int,
        consultationsPaginated: (response.data["consultations"] as List).map((finishedConsultation) {
          return ConsultationFinished(
            id: finishedConsultation["id"] as String,
            slug: finishedConsultation['slug'] as String,
            title: finishedConsultation["title"] as String,
            coverUrl: finishedConsultation["coverUrl"] as String,
            thematique: (finishedConsultation["thematique"] as Map).toThematique(),
            label: finishedConsultation["updateLabel"] as String?,
            updateDate: (finishedConsultation["updateDate"] as String).parseToDateTime(),
            territoire: finishedConsultation["territory"] as String? ?? "",
          );
        }).toList(),
      );
    } catch (exception, stacktrace) {
      sentryWrapper.captureException(exception, stacktrace, message: "Erreur lors de l'appel : $uri");
      return GetConsultationsFinishedPaginatedFailedResponse();
    }
  }

  @override
  Future<GetConsultationQuestionsRepositoryResponse> fetchConsultationQuestions({
    required String consultationId,
  }) async {
    final uri = "/consultations/$consultationId/questions";
    try {
      final response = await httpClient.get(uri);
      return GetConsultationQuestionsSucceedResponse(
        consultationQuestions: ConsultationQuestions(
          questionCount: response.data["questionCount"] as int,
          questions: ConsultationQuestionsBuilder.buildQuestions(
            uniqueChoiceQuestions: response.data["questionsUniqueChoice"] as List,
            openedQuestions: response.data["questionsOpened"] as List,
            multipleChoicesQuestions: response.data["questionsMultipleChoices"] as List,
            withConditionQuestions: response.data["questionsWithCondition"] as List,
            chapters: response.data["chapters"] as List,
          ),
        ),
      );
    } catch (exception, stacktrace) {
      sentryWrapper.captureException(exception, stacktrace, message: "Erreur lors de l'appel : $uri");
      return GetConsultationQuestionsFailedResponse();
    }
  }

  @override
  Future<SendConsultationResponsesRepositoryResponse> sendConsultationResponses({
    required String consultationId,
    required List<ConsultationQuestionResponses> questionsResponses,
  }) async {
    final uri = "/consultations/$consultationId/responses";
    try {
      final timer = Future.delayed(minimalSendingTime);
      final response = await httpClient.post(
        uri,
        data: {
          "consultationId": consultationId,
          "responses": questionsResponses
              .map(
                (questionResponse) => {
                  "questionId": questionResponse.questionId,
                  "choiceIds": questionResponse.responseIds,
                  "responseText": questionResponse.responseText,
                },
              )
              .toList(),
        },
      );
      await timer;
      return SendConsultationResponsesSucceedResponse(
        shouldDisplayDemographicInformation: response.data["askDemographicInfo"] as bool,
      );
    } catch (exception, stacktrace) {
      sentryWrapper.captureException(exception, stacktrace, message: "Erreur lors de l'appel : $uri");
      return SendConsultationResponsesFailureResponse();
    }
  }

  @override
  Future<DynamicConsultationResultsResponse> fetchDynamicConsultationResults({required String consultationId}) async {
    final uri = "/v2/consultations/$consultationId/responses";
    try {
      final asyncResponse = httpClient.get(uri);
      final (_, userResponses, _) = await storageClient.get(consultationId);
      final response = await asyncResponse;
      return DynamicConsultationsResultsSuccessResponse(
        participantCount: response.data["participantCount"] as int,
        title: response.data["title"] as String,
        coverUrl: response.data["coverUrl"] as String,
        results: mapper.toConsultationSummaryResults(
          uniqueChoiceResults: response.data["resultsUniqueChoice"] as List,
          multipleChoicesResults: response.data["resultsMultipleChoice"] as List,
          questionWithOpenChoiceResults: response.data["resultsOpen"] as List,
          userResponses: userResponses,
        ),
      );
    } catch (exception, stacktrace) {
      sentryWrapper.captureException(exception, stacktrace, message: "Erreur lors de l'appel : $uri");
      return DynamicConsultationsResultsErrorResponse();
    }
  }

  @override
  Future<DynamicConsultationResponse> getDynamicConsultation(String consultationId) async {
    final uri = "/v2/consultations/$consultationId";
    try {
      final response = await httpClient.get(uri);
      final data = response.data;
      final shareText = data["shareText"] as String;
      final downloadUrl = data["downloadAnalysisUrl"] as String?;
      final consultation = DynamicConsultation(
        id: consultationId,
        title: data["title"] as String,
        coverUrl: data["coverUrl"] as String,
        shareText: shareText,
        thematicLogo: data["thematique"]["picto"] as String,
        thematicLabel: data["thematique"]["label"] as String,
        questionsInfos: toQuestionsInfo(data["questionsInfo"]),
        responseInfos: toResponseInfo(data["responsesInfo"], consultationId),
        infoHeader: toInfoHeader(data["infoHeader"]),
        headerSections: ((data["body"]["headerSections"] ?? []) as List).map((e) => toSection(e)).nonNulls.toList(),
        collapsedSections: (data["body"]["sectionsPreview"] as List).map((e) => toSection(e)).nonNulls.toList(),
        expandedSections: (data["body"]["sections"] as List).map((e) => toSection(e)).nonNulls.toList(),
        participationInfo: toParticipationInfo(data["participationInfo"], shareText),
        downloadInfo: downloadUrl == null ? null : ConsultationDownloadInfo(url: downloadUrl),
        feedbackQuestion: toFeedbackQuestion(data["feedbackQuestion"]),
        feedbackResult: toFeedbackResults(data["feedbackResults"]),
        history: toHistory(data["history"], consultationId),
        footer: toFooter(data["footer"]),
        goals: toGoals(data["goals"]),
        territoire: data["territory"] as String,
      );
      return DynamicConsultationSuccessResponse(consultation);
    } catch (exception, stacktrace) {
      sentryWrapper.captureException(exception, stacktrace, message: "Erreur lors de l'appel : $uri");
      return DynamicConsultationErrorResponse();
    }
  }

  @override
  Future<DynamicConsultationUpdateResponse> fetchDynamicConsultationUpdate({
    required String updateId,
    required String consultationId,
  }) async {
    final uri = "/v2/consultations/$consultationId/updates/$updateId";
    try {
      final response = await httpClient.get(uri);
      final data = response.data;
      final shareText = data["shareText"] as String;
      final downloadUrl = data["downloadAnalysisUrl"] as String?;
      final consultation = DynamicConsultationUpdate(
        id: consultationId,
        title: data["title"] as String,
        coverUrl: data["coverUrl"] as String,
        thematicLogo: data["thematique"]["picto"] as String,
        thematicLabel: data["thematique"]["label"] as String,
        shareText: shareText,
        consultationDatesInfos: toConsultationDateInfo(data["consultationDates"]),
        responseInfos: toResponseInfo(data["responsesInfo"], consultationId),
        infoHeader: toInfoHeader(data["infoHeader"]),
        headerSections: ((data["body"]["headerSections"] ?? []) as List).map((e) => toSection(e)).nonNulls.toList(),
        previewSections: (data["body"]["sectionsPreview"] as List).map((e) => toSection(e)).nonNulls.toList(),
        expandedSections: (data["body"]["sections"] as List).map((e) => toSection(e)).nonNulls.toList(),
        participationInfo: toParticipationInfo(data["participationInfo"], shareText),
        downloadInfo: downloadUrl == null ? null : ConsultationDownloadInfo(url: downloadUrl),
        feedbackQuestion: toFeedbackQuestion(data["feedbackQuestion"]),
        feedbackResult: toFeedbackResults(data["feedbackResults"]),
        footer: toFooter(data["footer"]),
        goals: toGoals(data["goals"]),
      );
      return DynamicConsultationUpdateSuccessResponse(consultation);
    } catch (exception, stacktrace) {
      sentryWrapper.captureException(exception, stacktrace, message: "Erreur lors de l'appel : $uri");
      return DynamicConsultationUpdateErrorResponse();
    }
  }

  @override
  Future<void> sendConsultationUpdateFeedback(String updateId, String consultationId, bool isPositive) async {
    final uri = "/consultations/$consultationId/updates/$updateId/feedback";
    try {
      await httpClient.post(
        uri,
        data: {
          "isPositive": isPositive,
        },
      );
    } catch (exception, stacktrace) {
      sentryWrapper.captureException(exception, stacktrace, message: "Erreur lors de l'appel : $uri");
    }
  }

  @override
  Future<void> deleteConsultationUpdateFeedback(String updateId, String consultationId) async {
    final uri = "/consultations/$consultationId/updates/$updateId/feedback";
    try {
      await httpClient.delete(uri);
    } catch (exception, stacktrace) {
      sentryWrapper.captureException(exception, stacktrace, message: "Erreur lors de l'appel : $uri");
    }
  }
}
