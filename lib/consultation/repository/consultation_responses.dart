import 'package:agora/consultation/domain/consultation.dart';
import 'package:agora/consultation/domain/consultation_summary_results.dart';
import 'package:agora/consultation/domain/consultations_error_type.dart';
import 'package:agora/consultation/dynamic/domain/dynamic_consultation.dart';
import 'package:agora/consultation/question/domain/consultation_questions.dart';
import 'package:equatable/equatable.dart';

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
