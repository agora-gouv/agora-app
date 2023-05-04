import 'package:agora/common/client/agora_http_client.dart';
import 'package:agora/common/extension/date_extension.dart';
import 'package:agora/common/log/log.dart';
import 'package:agora/domain/consultation/consultation.dart';
import 'package:agora/domain/consultation/details/consultation_details.dart';
import 'package:agora/domain/consultation/questions/consultation_question.dart';
import 'package:agora/domain/consultation/questions/responses/consultation_question_response.dart';
import 'package:agora/domain/consultation/summary/consultation_summary.dart';
import 'package:agora/domain/consultation/summary/consultation_summary_et_ensuite.dart';
import 'package:agora/domain/thematique/thematique.dart';
import 'package:agora/infrastructure/consultation/repository/builder/consultation_questions_builder.dart';
import 'package:agora/infrastructure/consultation/repository/builder/consultation_responses_builder.dart';
import 'package:equatable/equatable.dart';

abstract class ConsultationRepository {
  Future<GetConsultationsRepositoryResponse> fetchConsultations({
    required String deviceId,
  });

  Future<GetConsultationDetailsRepositoryResponse> fetchConsultationDetails({
    required String consultationId,
    required String deviceId,
  });

  Future<GetConsultationQuestionsRepositoryResponse> fetchConsultationQuestions({
    required String consultationId,
    required String deviceId,
  });

  Future<SendConsultationResponsesRepositoryResponse> sendConsultationResponses({
    required String consultationId,
    required String deviceId,
    required List<ConsultationQuestionResponses> questionsResponses,
  });

  Future<GetConsultationSummaryRepositoryResponse> fetchConsultationSummary({
    required String consultationId,
    required String deviceId,
  });
}

class ConsultationDioRepository extends ConsultationRepository {
  final AgoraDioHttpClient httpClient;

  ConsultationDioRepository({required this.httpClient});

  @override
  Future<GetConsultationsRepositoryResponse> fetchConsultations({
    required String deviceId,
  }) async {
    try {
      final response = await httpClient.get(
        "/consultations",
        headers: {"deviceId": deviceId},
      );
      final ongoingConsultations = response.data["ongoing"] as List;
      return GetConsultationsSucceedResponse(
        ongoingConsultations: ongoingConsultations.map((ongoingConsultation) {
          final thematique = ongoingConsultation["thematique"] as Map;
          return ConsultationOngoing(
            id: ongoingConsultation["id"] as String,
            title: ongoingConsultation["title"] as String,
            coverUrl: ongoingConsultation["coverUrl"] as String,
            thematique: Thematique(
              picto: thematique["picto"] as String,
              label: thematique["label"] as String,
              color: thematique["color"] as String,
            ),
            endDate: (ongoingConsultation["endDate"] as String).parseToDateTime(),
            hasAnswered: ongoingConsultation["hasAnswered"] as bool,
          );
        }).toList(),
      );
    } catch (e) {
      Log.e("fetchConsultations failed", e);
      return GetConsultationsFailedResponse();
    }
  }

  @override
  Future<GetConsultationDetailsRepositoryResponse> fetchConsultationDetails({
    required String consultationId,
    required String deviceId,
  }) async {
    try {
      final response = await httpClient.get(
        "/consultations/$consultationId",
        headers: {"deviceId": deviceId},
      );
      final thematique = response.data["thematique"] as Map?;
      return GetConsultationDetailsSucceedResponse(
        consultationDetails: ConsultationDetails(
          id: response.data["id"] as String,
          title: response.data["title"] as String,
          coverUrl: response.data["coverUrl"] as String,
          thematique: thematique != null
              ? Thematique(
                  picto: thematique["picto"] as String,
                  label: thematique["label"] as String,
                  color: thematique["color"] as String,
                )
              : Thematique(picto: "🩺", label: "Santé", color: "#FFFCCFDD"),
          endDate: (response.data["endDate"] as String).parseToDateTime(),
          questionCount: response.data["questionCount"] as String,
          estimatedTime: response.data["estimatedTime"] as String,
          participantCount: response.data["participantCount"] as int,
          participantCountGoal: response.data["participantCountGoal"] as int,
          description: response.data["description"] as String,
          tipsDescription: response.data["tipsDescription"] as String,
        ),
      );
    } catch (e) {
      Log.e("fetchConsultationDetails failed", e);
      return GetConsultationDetailsFailedResponse();
    }
  }

  @override
  Future<GetConsultationQuestionsRepositoryResponse> fetchConsultationQuestions({
    required String consultationId,
    required String deviceId,
  }) async {
    try {
      final response = await httpClient.get(
        "/consultations/$consultationId/questions",
        headers: {"deviceId": deviceId},
      );
      return GetConsultationQuestionsSucceedResponse(
        consultationQuestions: ConsultationQuestionsBuilder.buildQuestions(
          uniqueChoiceQuestions: response.data["questionsUniqueChoice"] as List,
          openedQuestions: response.data["questionsOpened"] as List,
          multipleChoicesQuestions: response.data["questionsMultipleChoices"] as List,
          chapters: response.data["chapters"] as List,
        ),
      );
    } catch (e) {
      Log.e("fetchConsultationQuestions failed", e);
      return GetConsultationQuestionsFailedResponse();
    }
  }

  @override
  Future<SendConsultationResponsesRepositoryResponse> sendConsultationResponses({
    required String consultationId,
    required String deviceId,
    required List<ConsultationQuestionResponses> questionsResponses,
  }) async {
    try {
      await httpClient.post(
        "/consultations/$consultationId/responses",
        headers: {"deviceId": deviceId},
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
      return SendConsultationResponsesSucceedResponse();
    } catch (e) {
      Log.e("sendConsultationResponses failed", e);
      return SendConsultationResponsesFailureResponse();
    }
  }

  @override
  Future<GetConsultationSummaryRepositoryResponse> fetchConsultationSummary({
    required String consultationId,
    required String deviceId,
  }) async {
    try {
      final response = await httpClient.get(
        "/consultations/$consultationId/responses",
        headers: {"deviceId": deviceId},
      );
      final summary = ConsultationSummary(
        title: response.data["title"] as String,
        participantCount: response.data["participantCount"] as int,
        results: ConsultationResponsesBuilder.buildResults(
          uniqueChoiceResults: response.data["resultsUniqueChoice"] as List,
          multipleChoicesResults: response.data["resultsMultipleChoice"] as List,
        ),
        etEnsuite: ConsultationSummaryEtEnsuite(
          step: response.data["etEnsuite"]["step"] as int,
          description: response.data["etEnsuite"]["description"] as String,
        ),
      );
      return GetConsultationSummarySucceedResponse(consultationSummary: summary);
    } catch (e) {
      Log.e("fetchConsultationSummary failed", e);
      return GetConsultationSummaryFailedResponse();
    }
  }
}

abstract class GetConsultationsRepositoryResponse extends Equatable {
  @override
  List<Object> get props => [];
}

class GetConsultationsSucceedResponse extends GetConsultationsRepositoryResponse {
  final List<ConsultationOngoing> ongoingConsultations;

  GetConsultationsSucceedResponse({required this.ongoingConsultations});

  @override
  List<Object> get props => [ongoingConsultations];
}

class GetConsultationsFailedResponse extends GetConsultationsRepositoryResponse {}

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
  final List<ConsultationQuestion> consultationQuestions;

  GetConsultationQuestionsSucceedResponse({required this.consultationQuestions});

  @override
  List<Object> get props => [consultationQuestions];
}

class GetConsultationQuestionsFailedResponse extends GetConsultationQuestionsRepositoryResponse {}

abstract class SendConsultationResponsesRepositoryResponse extends Equatable {
  @override
  List<Object> get props => [];
}

class SendConsultationResponsesSucceedResponse extends SendConsultationResponsesRepositoryResponse {}

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
