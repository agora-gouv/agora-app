import 'package:dio/dio.dart';

enum AgoraDioExceptionType {
  // thematiques
  fetchThematiques,
  // demographics
  getDemographicResponses,
  sendDemographicResponses,
  // login
  signUpUpdateVersion,
  signUpTimeout,
  signUp,
  loginUpdateVersion,
  loginTimeout,
  login,
  // consultations
  fetchConsultations,
  fetchConsultationsTimeout,
  fetchConsultationsFinishedPaginated,
  fetchConsultationDetails,
  fetchConsultationQuestions,
  sendConsultationResponses,
  fetchConsultationSummary,
  // qags
  createQag,
  fetchQags,
  fetchQagsTimeout,
  fetchQagsPaginated,
  fetchQagsResponsePaginated,
  fetchQagDetails,
  fetchQagDetailsModerated,
  supportQag,
  deleteSupportQag,
  giveQagResponseFeedback,
  fetchQagModerationList,
  moderateQag,
}

extension DioExceptionExtension on DioException {
  DioException toAgoraDioException(AgoraDioExceptionType agoraType) {
    return switch (agoraType) {
      AgoraDioExceptionType.fetchThematiques => FetchThematiquesDioException(
          requestOptions: requestOptions,
          response: response,
          type: type,
          error: error,
          stackTrace: stackTrace,
          message: message,
        ),
      AgoraDioExceptionType.getDemographicResponses => GetDemographicDioException(
          requestOptions: requestOptions,
          response: response,
          type: type,
          error: error,
          stackTrace: stackTrace,
          message: message,
        ),
      AgoraDioExceptionType.sendDemographicResponses => SendDemographicDioException(
          requestOptions: requestOptions,
          response: response,
          type: type,
          error: error,
          stackTrace: stackTrace,
          message: message,
        ),
      AgoraDioExceptionType.signUpUpdateVersion => SignUpUpdateVersionDioException(
          requestOptions: requestOptions,
          response: response,
          type: type,
          error: error,
          stackTrace: stackTrace,
          message: message,
        ),
      AgoraDioExceptionType.signUpTimeout => SignUpTimeoutDioException(
          requestOptions: requestOptions,
          response: response,
          type: type,
          error: error,
          stackTrace: stackTrace,
          message: message,
        ),
      AgoraDioExceptionType.signUp => SignUpDioException(
          requestOptions: requestOptions,
          response: response,
          type: type,
          error: error,
          stackTrace: stackTrace,
          message: message,
        ),
      AgoraDioExceptionType.loginUpdateVersion => LoginUpdateVersionDioException(
          requestOptions: requestOptions,
          response: response,
          type: type,
          error: error,
          stackTrace: stackTrace,
          message: message,
        ),
      AgoraDioExceptionType.loginTimeout => LoginTimeoutDioException(
          requestOptions: requestOptions,
          response: response,
          type: type,
          error: error,
          stackTrace: stackTrace,
          message: message,
        ),
      AgoraDioExceptionType.login => LoginDioException(
          requestOptions: requestOptions,
          response: response,
          type: type,
          error: error,
          stackTrace: stackTrace,
          message: message,
        ),
      AgoraDioExceptionType.fetchConsultations => FetchConsultationsDioException(
          requestOptions: requestOptions,
          response: response,
          type: type,
          error: error,
          stackTrace: stackTrace,
          message: message,
        ),
      AgoraDioExceptionType.fetchConsultationsTimeout => FetchConsultationsTimeoutDioException(
          requestOptions: requestOptions,
          response: response,
          type: type,
          error: error,
          stackTrace: stackTrace,
          message: message,
        ),
      AgoraDioExceptionType.fetchConsultationsFinishedPaginated => FetchConsultationsFinishedPaginatedDioException(
          requestOptions: requestOptions,
          response: response,
          type: type,
          error: error,
          stackTrace: stackTrace,
          message: message,
        ),
      AgoraDioExceptionType.fetchConsultationDetails => FetchConsultationDetailsDioException(
          requestOptions: requestOptions,
          response: response,
          type: type,
          error: error,
          stackTrace: stackTrace,
          message: message,
        ),
      AgoraDioExceptionType.fetchConsultationQuestions => FetchConsultationQuestionsDioException(
          requestOptions: requestOptions,
          response: response,
          type: type,
          error: error,
          stackTrace: stackTrace,
          message: message,
        ),
      AgoraDioExceptionType.sendConsultationResponses => SendConsultationResponsesDioException(
          requestOptions: requestOptions,
          response: response,
          type: type,
          error: error,
          stackTrace: stackTrace,
          message: message,
        ),
      AgoraDioExceptionType.fetchConsultationSummary => FetchConsultationSummaryDioException(
          requestOptions: requestOptions,
          response: response,
          type: type,
          error: error,
          stackTrace: stackTrace,
          message: message,
        ),
      AgoraDioExceptionType.createQag => CreateQagDioException(
          requestOptions: requestOptions,
          response: response,
          type: type,
          error: error,
          stackTrace: stackTrace,
          message: message,
        ),
      AgoraDioExceptionType.fetchQags => FetchQagsDioException(
          requestOptions: requestOptions,
          response: response,
          type: type,
          error: error,
          stackTrace: stackTrace,
          message: message,
        ),
      AgoraDioExceptionType.fetchQagsTimeout => FetchQagsTimeoutDioException(
          requestOptions: requestOptions,
          response: response,
          type: type,
          error: error,
          stackTrace: stackTrace,
          message: message,
        ),
      AgoraDioExceptionType.fetchQagsPaginated => FetchQagsPaginatedDioException(
          requestOptions: requestOptions,
          response: response,
          type: type,
          error: error,
          stackTrace: stackTrace,
          message: message,
        ),
      AgoraDioExceptionType.fetchQagsResponsePaginated => FetchQagsResponsePaginatedDioException(
          requestOptions: requestOptions,
          response: response,
          type: type,
          error: error,
          stackTrace: stackTrace,
          message: message,
        ),
      AgoraDioExceptionType.fetchQagDetails => FetchQagDetailsDioException(
          requestOptions: requestOptions,
          response: response,
          type: type,
          error: error,
          stackTrace: stackTrace,
          message: message,
        ),
      AgoraDioExceptionType.fetchQagDetailsModerated => FetchQagDetailsModeratedDioException(
          requestOptions: requestOptions,
          response: response,
          type: type,
          error: error,
          stackTrace: stackTrace,
          message: message,
        ),
      AgoraDioExceptionType.supportQag => SupportQagDioException(
          requestOptions: requestOptions,
          response: response,
          type: type,
          error: error,
          stackTrace: stackTrace,
          message: message,
        ),
      AgoraDioExceptionType.deleteSupportQag => DeleteSupportQagDioException(
          requestOptions: requestOptions,
          response: response,
          type: type,
          error: error,
          stackTrace: stackTrace,
          message: message,
        ),
      AgoraDioExceptionType.giveQagResponseFeedback => GiveQagResponseFeedbackDioException(
          requestOptions: requestOptions,
          response: response,
          type: type,
          error: error,
          stackTrace: stackTrace,
          message: message,
        ),
      AgoraDioExceptionType.fetchQagModerationList => FetchQagModerationListDioException(
          requestOptions: requestOptions,
          response: response,
          type: type,
          error: error,
          stackTrace: stackTrace,
          message: message,
        ),
      AgoraDioExceptionType.moderateQag => ModerateQagDioException(
          requestOptions: requestOptions,
          response: response,
          type: type,
          error: error,
          stackTrace: stackTrace,
          message: message,
        ),
    };
  }
}

class FetchThematiquesDioException extends DioException {
  FetchThematiquesDioException({
    required super.requestOptions,
    super.response,
    super.type,
    super.error,
    super.stackTrace,
    super.message,
  });
}

class GetDemographicDioException extends DioException {
  GetDemographicDioException({
    required super.requestOptions,
    super.response,
    super.type,
    super.error,
    super.stackTrace,
    super.message,
  });
}

class SendDemographicDioException extends DioException {
  SendDemographicDioException({
    required super.requestOptions,
    super.response,
    super.type,
    super.error,
    super.stackTrace,
    super.message,
  });
}

class SignUpUpdateVersionDioException extends DioException {
  SignUpUpdateVersionDioException({
    required super.requestOptions,
    super.response,
    super.type,
    super.error,
    super.stackTrace,
    super.message,
  });
}

class SignUpTimeoutDioException extends DioException {
  SignUpTimeoutDioException({
    required super.requestOptions,
    super.response,
    super.type,
    super.error,
    super.stackTrace,
    super.message,
  });
}

class SignUpDioException extends DioException {
  SignUpDioException({
    required super.requestOptions,
    super.response,
    super.type,
    super.error,
    super.stackTrace,
    super.message,
  });
}

class LoginUpdateVersionDioException extends DioException {
  LoginUpdateVersionDioException({
    required super.requestOptions,
    super.response,
    super.type,
    super.error,
    super.stackTrace,
    super.message,
  });
}

class LoginTimeoutDioException extends DioException {
  LoginTimeoutDioException({
    required super.requestOptions,
    super.response,
    super.type,
    super.error,
    super.stackTrace,
    super.message,
  });
}

class LoginDioException extends DioException {
  LoginDioException({
    required super.requestOptions,
    super.response,
    super.type,
    super.error,
    super.stackTrace,
    super.message,
  });
}

class FetchConsultationsDioException extends DioException {
  FetchConsultationsDioException({
    required super.requestOptions,
    super.response,
    super.type,
    super.error,
    super.stackTrace,
    super.message,
  });
}

class FetchConsultationsTimeoutDioException extends DioException {
  FetchConsultationsTimeoutDioException({
    required super.requestOptions,
    super.response,
    super.type,
    super.error,
    super.stackTrace,
    super.message,
  });
}

class FetchConsultationsFinishedPaginatedDioException extends DioException {
  FetchConsultationsFinishedPaginatedDioException({
    required super.requestOptions,
    super.response,
    super.type,
    super.error,
    super.stackTrace,
    super.message,
  });
}

class FetchConsultationDetailsDioException extends DioException {
  FetchConsultationDetailsDioException({
    required super.requestOptions,
    super.response,
    super.type,
    super.error,
    super.stackTrace,
    super.message,
  });
}

class FetchConsultationQuestionsDioException extends DioException {
  FetchConsultationQuestionsDioException({
    required super.requestOptions,
    super.response,
    super.type,
    super.error,
    super.stackTrace,
    super.message,
  });
}

class SendConsultationResponsesDioException extends DioException {
  SendConsultationResponsesDioException({
    required super.requestOptions,
    super.response,
    super.type,
    super.error,
    super.stackTrace,
    super.message,
  });
}

class FetchConsultationSummaryDioException extends DioException {
  FetchConsultationSummaryDioException({
    required super.requestOptions,
    super.response,
    super.type,
    super.error,
    super.stackTrace,
    super.message,
  });
}

class CreateQagDioException extends DioException {
  CreateQagDioException({
    required super.requestOptions,
    super.response,
    super.type,
    super.error,
    super.stackTrace,
    super.message,
  });
}

class FetchQagsDioException extends DioException {
  FetchQagsDioException({
    required super.requestOptions,
    super.response,
    super.type,
    super.error,
    super.stackTrace,
    super.message,
  });
}

class FetchQagsTimeoutDioException extends DioException {
  FetchQagsTimeoutDioException({
    required super.requestOptions,
    super.response,
    super.type,
    super.error,
    super.stackTrace,
    super.message,
  });
}

class FetchQagsPaginatedDioException extends DioException {
  FetchQagsPaginatedDioException({
    required super.requestOptions,
    super.response,
    super.type,
    super.error,
    super.stackTrace,
    super.message,
  });
}

class FetchQagsResponsePaginatedDioException extends DioException {
  FetchQagsResponsePaginatedDioException({
    required super.requestOptions,
    super.response,
    super.type,
    super.error,
    super.stackTrace,
    super.message,
  });
}

class FetchQagDetailsDioException extends DioException {
  FetchQagDetailsDioException({
    required super.requestOptions,
    super.response,
    super.type,
    super.error,
    super.stackTrace,
    super.message,
  });
}

class FetchQagDetailsModeratedDioException extends DioException {
  FetchQagDetailsModeratedDioException({
    required super.requestOptions,
    super.response,
    super.type,
    super.error,
    super.stackTrace,
    super.message,
  });
}

class SupportQagDioException extends DioException {
  SupportQagDioException({
    required super.requestOptions,
    super.response,
    super.type,
    super.error,
    super.stackTrace,
    super.message,
  });
}

class DeleteSupportQagDioException extends DioException {
  DeleteSupportQagDioException({
    required super.requestOptions,
    super.response,
    super.type,
    super.error,
    super.stackTrace,
    super.message,
  });
}

class GiveQagResponseFeedbackDioException extends DioException {
  GiveQagResponseFeedbackDioException({
    required super.requestOptions,
    super.response,
    super.type,
    super.error,
    super.stackTrace,
    super.message,
  });
}

class FetchQagModerationListDioException extends DioException {
  FetchQagModerationListDioException({
    required super.requestOptions,
    super.response,
    super.type,
    super.error,
    super.stackTrace,
    super.message,
  });
}

class ModerateQagDioException extends DioException {
  ModerateQagDioException({
    required super.requestOptions,
    super.response,
    super.type,
    super.error,
    super.stackTrace,
    super.message,
  });
}
