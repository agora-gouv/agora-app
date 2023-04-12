import 'package:agora/common/client/agora_http_client.dart';
import 'package:agora/common/extension/string_extension.dart';
import 'package:agora/domain/consultation/details/consultation_details.dart';
import 'package:agora/domain/consultation/questions/consultation_question.dart';
import 'package:agora/domain/consultation/questions/consultation_question_response_choice.dart';
import 'package:agora/domain/consultation/questions/responses/consultation_question_response.dart';
import 'package:agora/domain/consultation/summary/consultation_summary.dart';
import 'package:agora/domain/consultation/summary/consultation_summary_et_ensuite.dart';
import 'package:agora/domain/consultation/summary/consultation_summary_results.dart';
import 'package:equatable/equatable.dart';

abstract class ConsultationRepository {
  Future<GetConsultationDetailsRepositoryResponse> fetchConsultationDetails({required String consultationId});

  Future<GetConsultationQuestionsRepositoryResponse> fetchConsultationQuestions({required String consultationId});

  Future<SendConsultationResponsesRepositoryResponse> sendConsultationResponses({
    required String consultationId,
    required List<ConsultationQuestionResponse> questionsResponses,
  });

  Future<GetConsultationSummaryRepositoryResponse> fetchConsultationSummary({required String consultationId});
}

class ConsultationDioRepository extends ConsultationRepository {
  final AgoraDioHttpClient httpClient;

  ConsultationDioRepository({required this.httpClient});

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
          cover: response.data["cover"] as String,
          thematiqueId: response.data["thematique_id"] as String,
          endDate: DateTime.parse(response.data["end_date"] as String),
          questionCount: response.data["question_count"] as String,
          estimatedTime: response.data["estimated_time"] as String,
          participantCount: response.data["participant_count"] as int,
          participantCountGoal: response.data["participant_count_goal"] as int,
          description: response.data["description"] as String,
          tipsDescription: response.data["tips_description"] as String,
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
              responseChoices: (question["possible_choices"] as List)
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
    required List<ConsultationQuestionResponse> questionsResponses,
  }) async {
    try {
      await httpClient.post(
        "/consultations/$consultationId/responses",
        data: {
          "id_consultation": consultationId,
          "responses": questionsResponses
              .map(
                (questionResponse) => {
                  "id_question": questionResponse.questionId,
                  "id_choice": questionResponse.responseIds,
                  "response_text": questionResponse.responseText,
                },
              )
              .toList(),
        },
      );
      return SendConsultationResponsesSucceedResponse();
    } catch (e) {
      return SendConsultationResponsesFailureResponse();
    }
  }

  @override
  Future<GetConsultationSummaryRepositoryResponse> fetchConsultationSummary({
    required String consultationId,
  }) async {
    try {
      final response = await httpClient.get("/consultations/$consultationId/responses");
      final summary = ConsultationSummary(
        title: response.data["title"] as String,
        participantCount: response.data["participant_count"] as int,
        results: (response.data["results"] as List)
            .map(
              (result) => ConsultationSummaryResults(
                questionTitle: result["question_title"] as String,
                responses: (result["responses"] as List)
                    .map(
                      (response) => ConsultationSummaryResponse(
                        label: response["label"] as String,
                        ratio: response["ratio"] as int,
                      ),
                    )
                    .toList(),
              ),
            )
            .toList(),
        etEnsuite: ConsultationSummaryEtEnsuite(
          step: response.data["et_ensuite"]["step"] as int,
          description: response.data["et_ensuite"]["description"] as String,
        ),
      );
      return GetConsultationSummarySucceedResponse(consultationSummary: summary);
    } catch (e) {
      return GetConsultationSummaryFailedResponse();
    }
  }
}

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
