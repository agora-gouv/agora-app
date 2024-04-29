import 'package:agora/common/client/agora_http_client.dart';
import 'package:agora/common/extension/date_extension.dart';
import 'package:agora/common/extension/thematique_extension.dart';
import 'package:agora/domain/consultation/consultation.dart';
import 'package:agora/domain/consultation/consultation_finished_paginated.dart';
import 'package:agora/domain/consultation/consultations_error_type.dart';
import 'package:agora/domain/consultation/details/consultation_details.dart';
import 'package:agora/domain/consultation/dynamic/dynamic_consultation.dart';
import 'package:agora/domain/consultation/dynamic/dynamic_consultation_section.dart';
import 'package:agora/domain/consultation/questions/consultation_questions.dart';
import 'package:agora/domain/consultation/questions/responses/consultation_question_response.dart';
import 'package:agora/domain/consultation/summary/consultation_summary.dart';
import 'package:agora/domain/consultation/summary/consultation_summary_et_ensuite.dart';
import 'package:agora/domain/consultation/summary/consultation_summary_presentation.dart';
import 'package:agora/domain/consultation/summary/consultation_summary_results.dart';
import 'package:agora/infrastructure/consultation/repository/builder/consultation_questions_builder.dart';
import 'package:agora/infrastructure/consultation/repository/builder/consultation_responses_builder.dart';
import 'package:agora/infrastructure/errors/sentry_wrapper.dart';
import 'package:agora/pages/consultation/question/consultation_question_storage_client.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';

part 'dynamic_consultation_mapper.dart';

abstract class ConsultationRepository {
  Future<GetConsultationsRepositoryResponse> fetchConsultations();

  Future<GetConsultationsFinishedPaginatedRepositoryResponse> fetchConsultationsFinishedPaginated({
    required int pageNumber,
  });

  Future<GetConsultationsFinishedPaginatedRepositoryResponse> fetchConsultationsAnsweredPaginated({
    required int pageNumber,
  });

  Future<GetConsultationDetailsRepositoryResponse> fetchConsultationDetails({
    required String consultationId,
  });

  Future<GetConsultationQuestionsRepositoryResponse> fetchConsultationQuestions({
    required String consultationId,
  });

  Future<SendConsultationResponsesRepositoryResponse> sendConsultationResponses({
    required String consultationId,
    required List<ConsultationQuestionResponses> questionsResponses,
  });

  Future<GetConsultationSummaryRepositoryResponse> fetchConsultationSummary({
    required String consultationId,
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
  final SentryWrapper? sentryWrapper;
  final Duration minimalSendingTime;
  final ConsultationQuestionStorageClient storageClient;

  ConsultationDioRepository({
    required this.httpClient,
    this.sentryWrapper,
    this.minimalSendingTime = const Duration(seconds: 2),
    required this.storageClient,
  });

  @override
  Future<GetConsultationsRepositoryResponse> fetchConsultations() async {
    try {
      final response = await httpClient.get(
        "/consultations",
      );
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
            highlightLabel: ongoingConsultation["highlightLabel"] as String?,
          );
        }).toList(),
        finishedConsultations: finishedConsultations.map((finishedConsultation) {
          return ConsultationFinished(
            id: finishedConsultation["id"] as String,
            title: finishedConsultation["title"] as String,
            coverUrl: finishedConsultation["coverUrl"] as String,
            thematique: (finishedConsultation["thematique"] as Map).toThematique(),
            label: finishedConsultation["updateLabel"] as String?,
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
    } catch (e, s) {
      if (e is DioException) {
        if (e.type == DioExceptionType.connectionTimeout || e.type == DioExceptionType.receiveTimeout) {
          return GetConsultationsFailedResponse(errorType: ConsultationsErrorType.timeout);
        }
      }
      sentryWrapper?.captureException(e, s);
      return GetConsultationsFailedResponse();
    }
  }

  @override
  Future<GetConsultationsFinishedPaginatedRepositoryResponse> fetchConsultationsAnsweredPaginated({
    required int pageNumber,
  }) async {
    try {
      final response = await httpClient.get("/consultations/answered/$pageNumber");
      return GetConsultationsPaginatedSucceedResponse(
        maxPage: response.data["maxPageNumber"] as int,
        consultationsPaginated: (response.data["consultations"] as List).map((consultation) {
          return ConsultationFinishedPaginated(
            id: consultation["id"] as String,
            title: consultation["title"] as String,
            coverUrl: consultation["coverUrl"] as String,
            thematique: (consultation["thematique"] as Map).toThematique(),
            label: consultation["label"] as String?,
          );
        }).toList(),
      );
    } catch (e, s) {
      sentryWrapper?.captureException(e, s);
      return GetConsultationsFinishedPaginatedFailedResponse();
    }
  }

  @override
  Future<GetConsultationsFinishedPaginatedRepositoryResponse> fetchConsultationsFinishedPaginated({
    required int pageNumber,
  }) async {
    try {
      final response = await httpClient.get("/consultations/finished/$pageNumber");
      return GetConsultationsPaginatedSucceedResponse(
        maxPage: response.data["maxPageNumber"] as int,
        consultationsPaginated: (response.data["consultations"] as List).map((finishedConsultation) {
          return ConsultationFinishedPaginated(
            id: finishedConsultation["id"] as String,
            title: finishedConsultation["title"] as String,
            coverUrl: finishedConsultation["coverUrl"] as String,
            thematique: (finishedConsultation["thematique"] as Map).toThematique(),
            label: finishedConsultation["updateLabel"] as String?,
          );
        }).toList(),
      );
    } catch (e, s) {
      sentryWrapper?.captureException(e, s);
      return GetConsultationsFinishedPaginatedFailedResponse();
    }
  }

  @override
  Future<GetConsultationDetailsRepositoryResponse> fetchConsultationDetails({
    required String consultationId,
  }) async {
    try {
      final response = await httpClient.get(
        "/consultations/$consultationId",
      );
      return GetConsultationDetailsSucceedResponse(
        consultationDetails: ConsultationDetails(
          id: response.data["id"] as String,
          title: response.data["title"] as String,
          coverUrl: response.data["coverUrl"] as String,
          thematique: (response.data["thematique"] as Map).toThematique(),
          endDate: (response.data["endDate"] as String).parseToDateTime(),
          questionCount: response.data["questionCount"] as String,
          estimatedTime: response.data["estimatedTime"] as String,
          participantCount: response.data["participantCount"] as int,
          participantCountGoal: response.data["participantCountGoal"] as int,
          description: response.data["description"] as String,
          tipsDescription: response.data["tipsDescription"] as String,
          hasAnswered: response.data["hasAnswered"] as bool,
        ),
      );
    } catch (e, s) {
      sentryWrapper?.captureException(e, s);
      return GetConsultationDetailsFailedResponse();
    }
  }

  @override
  Future<GetConsultationQuestionsRepositoryResponse> fetchConsultationQuestions({
    required String consultationId,
  }) async {
    try {
      final response = await httpClient.get(
        "/consultations/$consultationId/questions",
      );
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
    } catch (e, s) {
      sentryWrapper?.captureException(e, s);
      return GetConsultationQuestionsFailedResponse();
    }
  }

  @override
  Future<SendConsultationResponsesRepositoryResponse> sendConsultationResponses({
    required String consultationId,
    required List<ConsultationQuestionResponses> questionsResponses,
  }) async {
    try {
      final timer = Future.delayed(minimalSendingTime);
      final response = await httpClient.post(
        "/consultations/$consultationId/responses",
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
    } catch (e, s) {
      sentryWrapper?.captureException(e, s);
      return SendConsultationResponsesFailureResponse();
    }
  }

  @override
  Future<DynamicConsultationResultsResponse> fetchDynamicConsultationResults({required String consultationId}) async {
    try {
      final asyncResponse = httpClient.get(
        "/v2/consultations/$consultationId/responses",
      );
      final (_, userResponses, _) = await storageClient.get(consultationId);
      final response = await asyncResponse;
      return DynamicConsultationsResultsSuccessResponse(
        participantCount: response.data["participantCount"] as int,
        title: response.data["title"] as String,
        coverUrl: response.data["coverUrl"] as String,
        results: ConsultationResponsesBuilder.buildResults(
          uniqueChoiceResults: response.data["resultsUniqueChoice"] as List,
          multipleChoicesResults: response.data["resultsMultipleChoice"] as List,
          userResponses: userResponses,
        ),
      );
    } catch (e, s) {
      sentryWrapper?.captureException(e, s);
      return DynamicConsultationsResultsErrorResponse();
    }
  }

  @override
  Future<GetConsultationSummaryRepositoryResponse> fetchConsultationSummary({
    required String consultationId,
  }) async {
    try {
      final asyncResponse = httpClient.get(
        "/consultations/$consultationId/responses",
      );
      final (_, userResponses, _) = await storageClient.get(consultationId);
      final response = await asyncResponse;
      final etEnsuite = response.data["etEnsuite"];
      final presentation = response.data["presentation"];
      final explanations = etEnsuite["explanations"] as List;
      final etEnsuiteVideo = etEnsuite["video"] as Map?;
      final etEnsuiteConclusion = etEnsuite["conclusion"] as Map?;
      final summary = ConsultationSummary(
        title: response.data["title"] as String,
        participantCount: response.data["participantCount"] as int,
        results: ConsultationResponsesBuilder.buildResults(
          uniqueChoiceResults: response.data["resultsUniqueChoice"] as List,
          multipleChoicesResults: response.data["resultsMultipleChoice"] as List,
          userResponses: userResponses,
        ),
        etEnsuite: ConsultationSummaryEtEnsuite(
          step: etEnsuite["step"] as int,
          description: etEnsuite["description"] as String,
          explanationsTitle: etEnsuite["explanationsTitle"] as String?,
          explanations: explanations.map((explanation) {
            return ConsultationSummaryEtEnsuiteExplanation(
              isTogglable: explanation["isTogglable"] as bool,
              title: explanation["title"] as String,
              intro: explanation["intro"] as String,
              imageUrl: (explanation['image'] as Map?)?['url'] as String?,
              imageDescription: (explanation['image'] as Map?)?['description'] as String?,
              description: explanation["description"] as String,
            );
          }).toList(),
          video: etEnsuiteVideo != null
              ? ConsultationSummaryEtEnsuiteVideo(
                  title: etEnsuiteVideo["title"] as String,
                  intro: etEnsuiteVideo["intro"] as String,
                  videoUrl: etEnsuiteVideo["videoUrl"] as String,
                  videoWidth: etEnsuiteVideo["videoWidth"] as int,
                  videoHeight: etEnsuiteVideo["videoHeight"] as int,
                  transcription: etEnsuiteVideo["transcription"] as String,
                )
              : null,
          conclusion: etEnsuiteConclusion != null
              ? ConsultationSummaryEtEnsuiteConclusion(
                  title: etEnsuiteConclusion["title"] as String,
                  description: etEnsuiteConclusion["description"] as String,
                )
              : null,
        ),
        presentation: ConsultationSummaryPresentation(
          startDate: (presentation["startDate"] as String).parseToDateTime(),
          endDate: (presentation["endDate"] as String).parseToDateTime(),
          description: presentation["description"] as String,
          tipDescription: presentation["tipsDescription"] as String,
        ),
      );
      return GetConsultationSummarySucceedResponse(consultationSummary: summary);
    } catch (e, s) {
      sentryWrapper?.captureException(e, s);
      return GetConsultationSummaryFailedResponse();
    }
  }

  @override
  Future<DynamicConsultationResponse> getDynamicConsultation(String consultationId) async {
    try {
      final response = await httpClient.get(
        "/v2/consultations/$consultationId",
      );
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
        questionsInfos: _toQuestionsInfo(data["questionsInfo"]),
        responseInfos: _toResponseInfo(data["responsesInfo"], consultationId),
        infoHeader: _toInfoHeader(data["infoHeader"]),
        headerSections: ((data["body"]["headerSections"] ?? []) as List).map((e) => _toSection(e)).nonNulls.toList(),
        collapsedSections: (data["body"]["sectionsPreview"] as List).map((e) => _toSection(e)).nonNulls.toList(),
        expandedSections: (data["body"]["sections"] as List).map((e) => _toSection(e)).nonNulls.toList(),
        participationInfo: _toParticipationInfo(data["participationInfo"], shareText),
        downloadInfo: downloadUrl == null ? null : ConsultationDownloadInfo(url: downloadUrl),
        feedbackQuestion: _toFeedbackQuestion(data["feedbackQuestion"]),
        feedbackResult: _toFeedbackResults(data["feedbackResults"]),
        history: _toHistory(data["history"], consultationId),
        footer: _toFooter(data["footer"]),
        goals: _toGoals(data["goals"]),
      );
      return DynamicConsultationSuccessResponse(consultation);
    } catch (e, s) {
      sentryWrapper?.captureException(e, s);
      return DynamicConsultationErrorResponse();
    }
  }

  @override
  Future<DynamicConsultationUpdateResponse> fetchDynamicConsultationUpdate({
    required String updateId,
    required String consultationId,
  }) async {
    try {
      final response = await httpClient.get(
        "/v2/consultations/$consultationId/updates/$updateId",
      );
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
        consultationDatesInfos: _toConsultationDateInfo(data["consultationDates"]),
        responseInfos: _toResponseInfo(data["responsesInfo"], consultationId),
        infoHeader: _toInfoHeader(data["infoHeader"]),
        headerSections: ((data["body"]["headerSections"] ?? []) as List).map((e) => _toSection(e)).nonNulls.toList(),
        previewSections: (data["body"]["sectionsPreview"] as List).map((e) => _toSection(e)).nonNulls.toList(),
        expandedSections: (data["body"]["sections"] as List).map((e) => _toSection(e)).nonNulls.toList(),
        participationInfo: _toParticipationInfo(data["participationInfo"], shareText),
        downloadInfo: downloadUrl == null ? null : ConsultationDownloadInfo(url: downloadUrl),
        feedbackQuestion: _toFeedbackQuestion(data["feedbackQuestion"]),
        feedbackResult: _toFeedbackResults(data["feedbackResults"]),
        footer: _toFooter(data["footer"]),
        goals: _toGoals(data["goals"]),
      );
      return DynamicConsultationUpdateSuccessResponse(consultation);
    } catch (e, s) {
      sentryWrapper?.captureException(e, s);
      return DynamicConsultationUpdateErrorResponse();
    }
  }

  @override
  Future<void> sendConsultationUpdateFeedback(String updateId, String consultationId, bool isPositive) async {
    try {
      await httpClient.post(
        "/consultations/$consultationId/updates/$updateId/feedback",
        data: {
          "isPositive": isPositive,
        },
      );
    } catch (e, s) {
      sentryWrapper?.captureException(e, s);
    }
  }

  @override
  Future<void> deleteConsultationUpdateFeedback(String updateId, String consultationId) async {
    try {
      await httpClient.delete("/consultations/$consultationId/updates/$updateId/feedback");
    } catch (e, s) {
      sentryWrapper?.captureException(e, s);
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
  final List<ConsultationFinishedPaginated> consultationsPaginated;

  GetConsultationsPaginatedSucceedResponse({
    required this.maxPage,
    required this.consultationsPaginated,
  });

  @override
  List<Object> get props => [maxPage, consultationsPaginated];
}

class GetConsultationsFinishedPaginatedFailedResponse extends GetConsultationsFinishedPaginatedRepositoryResponse {}

abstract class GetConsultationDetailsRepositoryResponse extends Equatable {
  @override
  List<Object> get props => [];
}

class GetConsultationDetailsSucceedResponse extends GetConsultationDetailsRepositoryResponse {
  final ConsultationDetails consultationDetails;

  GetConsultationDetailsSucceedResponse({required this.consultationDetails});

  @override
  List<Object> get props => [consultationDetails];
}

class GetConsultationDetailsFailedResponse extends GetConsultationDetailsRepositoryResponse {}

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

abstract class GetConsultationSummaryRepositoryResponse extends Equatable {
  @override
  List<Object> get props => [];
}

class GetConsultationSummarySucceedResponse extends GetConsultationSummaryRepositoryResponse {
  final ConsultationSummary consultationSummary;

  GetConsultationSummarySucceedResponse({required this.consultationSummary});

  @override
  List<Object> get props => [consultationSummary];
}

class GetConsultationSummaryFailedResponse extends GetConsultationSummaryRepositoryResponse {}

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
