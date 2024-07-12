import 'package:agora/common/client/agora_http_client.dart';
import 'package:agora/common/extension/date_extension.dart';
import 'package:agora/common/extension/thematique_extension.dart';
import 'package:agora/consultation/domain/consultation.dart';
import 'package:agora/consultation/domain/consultations_error_type.dart';
import 'package:agora/consultation/dynamic/domain/dynamic_consultation.dart';
import 'package:agora/consultation/domain/questions/consultation_questions.dart';
import 'package:agora/consultation/domain/questions/responses/consultation_question_response.dart';
import 'package:agora/consultation/domain/summary/consultation_summary_results.dart';
import 'package:agora/consultation/dynamic/repository/dynamic_consultation_mapper.dart';
import 'package:agora/consultation/repository/consultation_questions_builder.dart';
import 'package:agora/consultation/repository/consultation_responses_builder.dart';
import 'package:agora/infrastructure/errors/sentry_wrapper.dart';
import 'package:agora/consultation/pages/question/consultation_question_storage_client.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';

abstract class ConsultationRepository {
  Future<GetConsultationsRepositoryResponse> fetchConsultations();

  Future<GetConsultationsFinishedPaginatedRepositoryResponse> fetchConsultationsFinishedPaginated({
    required int pageNumber,
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
}

class ConsultationDioRepository extends ConsultationRepository {
  final AgoraDioHttpClient httpClient;
  final SentryWrapper sentryWrapper;
  final Duration minimalSendingTime;
  final ConsultationQuestionStorageClient storageClient;

  ConsultationDioRepository({
    required this.httpClient,
    required this.sentryWrapper,
    this.minimalSendingTime = const Duration(seconds: 2),
    required this.storageClient,
  });

  @override
  Future<GetConsultationsRepositoryResponse> fetchConsultations() async {
    const uri = "/consultations";
    try {
      final response = await httpClient.get(uri);
      final ongoingConsultations = response.data["ongoing"] as List;
      final finishedConsultations = response.data["finished"] as List;
      final answeredConsultations = response.data["answered"] as List;
      return GetConsultationsSucceedResponse(
        ongoingConsultations: ongoingConsultations.map((ongoingConsultation) {
          return ConsultationOngoing(
            id: ongoingConsultation["id"] as String,
            title: ongoingConsultation["title"] as String,
            coverUrl: ongoingConsultation["coverUrl"] as String,
            thematique: (ongoingConsultation["thematique"] as Map).toThematique(),
            endDate: (ongoingConsultation["endDate"] as String).parseToDateTime(),
            label: ongoingConsultation["highlightLabel"] as String?,
          );
        }).toList(),
        finishedConsultations: finishedConsultations.map((finishedConsultation) {
          return ConsultationFinished(
            id: finishedConsultation["id"] as String,
            title: finishedConsultation["title"] as String,
            coverUrl: finishedConsultation["coverUrl"] as String,
            thematique: (finishedConsultation["thematique"] as Map).toThematique(),
            label: finishedConsultation["updateLabel"] as String?,
            updateDate: (finishedConsultation["updateDate"] as String).parseToDateTime(),
          );
        }).toList(),
        answeredConsultations: answeredConsultations.map((answeredConsultation) {
          return ConsultationAnswered(
            id: answeredConsultation["id"] as String,
            title: answeredConsultation["title"] as String,
            coverUrl: answeredConsultation["coverUrl"] as String,
            thematique: (answeredConsultation["thematique"] as Map).toThematique(),
            label: answeredConsultation["updateLabel"] as String?,
          );
        }).toList(),
      );
    } catch (exception, stacktrace) {
      if (exception is DioException) {
        if (exception.type == DioExceptionType.connectionTimeout || exception.type == DioExceptionType.receiveTimeout) {
          return GetConsultationsFailedResponse(errorType: ConsultationsErrorType.timeout);
        }
      }
      sentryWrapper.captureException(exception, stacktrace, message: "Erreur lors de l'appel : $uri");
      return GetConsultationsFailedResponse();
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
            title: consultation["title"] as String,
            coverUrl: consultation["coverUrl"] as String,
            thematique: (consultation["thematique"] as Map).toThematique(),
            label: consultation["label"] as String?,
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
  }) async {
    final uri = "/consultations/finished/$pageNumber";
    try {
      final response = await httpClient.get(uri);
      return GetConsultationsPaginatedSucceedResponse(
        maxPage: response.data["maxPageNumber"] as int,
        consultationsPaginated: (response.data["consultations"] as List).map((finishedConsultation) {
          return ConsultationFinished(
            id: finishedConsultation["id"] as String,
            title: finishedConsultation["title"] as String,
            coverUrl: finishedConsultation["coverUrl"] as String,
            thematique: (finishedConsultation["thematique"] as Map).toThematique(),
            label: finishedConsultation["updateLabel"] as String?,
            updateDate: (finishedConsultation["updateDate"] as String).parseToDateTime(),
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
        results: ConsultationResponsesMapper.toConsultationSummaryResults(
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

abstract class GetConsultationsRepositoryResponse extends Equatable {
  @override
  List<Object> get props => [];
}

class GetConsultationsSucceedResponse extends GetConsultationsRepositoryResponse {
  final List<ConsultationOngoing> ongoingConsultations;
  final List<ConsultationFinished> finishedConsultations;
  final List<ConsultationAnswered> answeredConsultations;

  GetConsultationsSucceedResponse({
    required this.ongoingConsultations,
    required this.finishedConsultations,
    required this.answeredConsultations,
  });

  @override
  List<Object> get props => [
        ongoingConsultations,
        finishedConsultations,
        answeredConsultations,
      ];
}

class GetConsultationsFailedResponse extends GetConsultationsRepositoryResponse {
  final ConsultationsErrorType errorType;

  GetConsultationsFailedResponse({this.errorType = ConsultationsErrorType.generic});

  @override
  List<Object> get props => [errorType];
}

abstract class GetConsultationsFinishedPaginatedRepositoryResponse extends Equatable {
  @override
  List<Object> get props => [];
}

class GetConsultationsPaginatedSucceedResponse extends GetConsultationsFinishedPaginatedRepositoryResponse {
  final int maxPage;
  final List<ConsultationFinished> consultationsPaginated;

  GetConsultationsPaginatedSucceedResponse({
    required this.maxPage,
    required this.consultationsPaginated,
  });

  @override
  List<Object> get props => [maxPage, consultationsPaginated];
}

class GetConsultationsFinishedPaginatedFailedResponse extends GetConsultationsFinishedPaginatedRepositoryResponse {}

abstract class GetConsultationQuestionsRepositoryResponse extends Equatable {
  @override
  List<Object> get props => [];
}

class GetConsultationQuestionsSucceedResponse extends GetConsultationQuestionsRepositoryResponse {
  final ConsultationQuestions consultationQuestions;

  GetConsultationQuestionsSucceedResponse({required this.consultationQuestions});

  @override
  List<Object> get props => [consultationQuestions];
}

class GetConsultationQuestionsFailedResponse extends GetConsultationQuestionsRepositoryResponse {}

abstract class SendConsultationResponsesRepositoryResponse extends Equatable {
  @override
  List<Object> get props => [];
}

class SendConsultationResponsesSucceedResponse extends SendConsultationResponsesRepositoryResponse {
  final bool shouldDisplayDemographicInformation;

  SendConsultationResponsesSucceedResponse({required this.shouldDisplayDemographicInformation});

  @override
  List<Object> get props => [shouldDisplayDemographicInformation];
}

class SendConsultationResponsesFailureResponse extends SendConsultationResponsesRepositoryResponse {}

sealed class DynamicConsultationResponse extends Equatable {}

class DynamicConsultationSuccessResponse extends DynamicConsultationResponse {
  final DynamicConsultation consultation;

  DynamicConsultationSuccessResponse(this.consultation);

  @override
  List<Object?> get props => [consultation];
}

class DynamicConsultationErrorResponse extends DynamicConsultationResponse {
  @override
  List<Object?> get props => [];
}

sealed class DynamicConsultationResultsResponse extends Equatable {}

class DynamicConsultationsResultsErrorResponse extends DynamicConsultationResultsResponse {
  @override
  List<Object?> get props => [];
}

class DynamicConsultationsResultsSuccessResponse extends DynamicConsultationResultsResponse {
  final int participantCount;
  final String title;
  final String coverUrl;
  final List<ConsultationSummaryResults> results;

  DynamicConsultationsResultsSuccessResponse({
    required this.participantCount,
    required this.results,
    required this.title,
    required this.coverUrl,
  });

  @override
  List<Object?> get props => [participantCount, results, title, coverUrl];
}

sealed class DynamicConsultationUpdateResponse extends Equatable {}

class DynamicConsultationUpdateErrorResponse extends DynamicConsultationUpdateResponse {
  @override
  List<Object?> get props => [];
}

class DynamicConsultationUpdateSuccessResponse extends DynamicConsultationUpdateResponse {
  final DynamicConsultationUpdate update;

  DynamicConsultationUpdateSuccessResponse(this.update);

  @override
  List<Object?> get props => [update];
}
