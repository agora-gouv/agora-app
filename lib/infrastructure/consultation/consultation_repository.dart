import 'package:agora/common/client/agora_http_client.dart';
import 'package:agora/common/extension/date_extension.dart';
import 'package:agora/common/log/log.dart';
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
    required List<ConsultationQuestionResponses> questionsResponses,
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
          cover: response.data["coverUrl"] as String,
          thematiqueId: response.data["thematiqueId"] as String,
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
  }) async {
    try {
      final response = await httpClient.get("/consultations/$consultationId/questions");

      final List<ConsultationQuestion> questions = [];
      _buildUniqueChoiceQuestions(response.data["questionsUniqueChoice"] as List, questions);
      _buildOpenedQuestions(response.data["questionsOpened"] as List, questions);
      _buildMultipleChoicesQuestions(response.data["questionsMultipleChoices"] as List, questions);
      _buildChapters(response.data["chapters"] as List, questions);

      return GetConsultationQuestionsSucceedResponse(consultationQuestions: questions);
    } catch (e) {
      Log.e("fetchConsultationQuestions failed", e);
      return GetConsultationQuestionsFailedResponse();
    }
  }

  @override
  Future<SendConsultationResponsesRepositoryResponse> sendConsultationResponses({
    required String consultationId,
    required List<ConsultationQuestionResponses> questionsResponses,
  }) async {
    try {
      await httpClient.post(
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
      return SendConsultationResponsesSucceedResponse();
    } catch (e) {
      Log.e("sendConsultationResponses failed", e);
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
        participantCount: response.data["participantCount"] as int,
        results: (response.data["results"] as List)
            .map(
              (result) => ConsultationSummaryResults(
                questionTitle: result["questionTitle"] as String,
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

  void _buildUniqueChoiceQuestions(List<dynamic> questionsUniqueChoice, List<ConsultationQuestion> questions) {
    for (final questionUniqueChoice in questionsUniqueChoice) {
      questions.add(
        ConsultationQuestionUnique(
          id: questionUniqueChoice["id"] as String,
          title: questionUniqueChoice["titre"] as String,
          order: questionUniqueChoice["order"] as int,
          questionProgress: questionUniqueChoice["questionProgress"] as String,
          responseChoices: (questionUniqueChoice["possibleChoices"] as List)
              .map(
                (responseChoice) => ConsultationQuestionResponseChoice(
                  id: responseChoice["id"] as String,
                  label: responseChoice["label"] as String,
                  order: responseChoice["order"] as int,
                ),
              )
              .toList(),
        ),
      );
    }
  }

  void _buildOpenedQuestions(List<dynamic> questionsOpened, List<ConsultationQuestion> questions) {
    for (final questionOpened in questionsOpened) {
      questions.add(
        ConsultationQuestionOpened(
          id: questionOpened["id"] as String,
          title: questionOpened["titre"] as String,
          order: questionOpened["order"] as int,
          questionProgress: questionOpened["questionProgress"] as String,
        ),
      );
    }
  }

  void _buildMultipleChoicesQuestions(List<dynamic> questionsMultipleChoices, List<ConsultationQuestion> questions) {
    for (final questionMultipleChoices in questionsMultipleChoices) {
      questions.add(
        ConsultationQuestionMultiple(
          id: questionMultipleChoices["id"] as String,
          title: questionMultipleChoices["titre"] as String,
          order: questionMultipleChoices["order"] as int,
          questionProgress: questionMultipleChoices["questionProgress"] as String,
          maxChoices: questionMultipleChoices["maxChoices"] as int,
          responseChoices: (questionMultipleChoices["possibleChoices"] as List)
              .map(
                (responseChoice) => ConsultationQuestionResponseChoice(
                  id: responseChoice["id"] as String,
                  label: responseChoice["label"] as String,
                  order: responseChoice["order"] as int,
                ),
              )
              .toList(),
        ),
      );
    }
  }

  void _buildChapters(List<dynamic> chapters, List<ConsultationQuestion> questions) {
    for (final chapter in chapters) {
      questions.add(
        ConsultationChapter(
          id: chapter["id"] as String,
          title: chapter["titre"] as String,
          order: chapter["order"] as int,
          description: chapter["description"] as String,
        ),
      );
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
