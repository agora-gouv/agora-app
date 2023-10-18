import 'dart:io';

import 'package:agora/common/client/agora_http_client.dart';
import 'package:agora/common/extension/date_extension.dart';
import 'package:agora/common/extension/qag_paginated_filter_extension.dart';
import 'package:agora/common/extension/thematique_extension.dart';
import 'package:agora/domain/qag/details/qag_details.dart';
import 'package:agora/domain/qag/moderation/qag_moderation_list.dart';
import 'package:agora/domain/qag/qag.dart';
import 'package:agora/domain/qag/qag_paginated.dart';
import 'package:agora/domain/qag/qag_paginated_filter.dart';
import 'package:agora/domain/qag/qag_response.dart';
import 'package:agora/domain/qag/qag_response_incoming.dart';
import 'package:agora/domain/qag/qag_response_paginated.dart';
import 'package:agora/domain/qag/qag_similar.dart';
import 'package:agora/domain/qag/qags_error_type.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';

abstract class QagRepository {
  Future<CreateQagRepositoryResponse> createQag({
    required String title,
    required String description,
    required String author,
    required String thematiqueId,
  });

  Future<GetQagsRepositoryResponse> fetchQags({
    required String? thematiqueId,
  });

  Future<GetQagsPaginatedRepositoryResponse> fetchQagsPaginated({
    required int pageNumber,
    required String? thematiqueId,
    required QagPaginatedFilter filter,
    required String? keywords,
  });

  Future<GetQagsResponseRepositoryResponse> fetchQagsResponse();

  Future<GetQagsResponsePaginatedRepositoryResponse> fetchQagsResponsePaginated({
    required int pageNumber,
  });

  Future<GetQagDetailsRepositoryResponse> fetchQagDetails({
    required String qagId,
  });

  Future<DeleteQagRepositoryResponse> deleteQag({
    required String qagId,
  });

  Future<SupportQagRepositoryResponse> supportQag({
    required String qagId,
  });

  Future<DeleteSupportQagRepositoryResponse> deleteSupportQag({
    required String qagId,
  });

  Future<QagFeedbackRepositoryResponse> giveQagResponseFeedback({
    required String qagId,
    required bool isHelpful,
  });

  Future<QagModerationListRepositoryResponse> fetchQagModerationList();

  Future<ModerateQagRepositoryResponse> moderateQag({
    required String qagId,
    required bool isAccepted,
  });

  Future<QagHasSimilarRepositoryResponse> hasSimilarQag({
    required String title,
  });

  Future<QagSimilarRepositoryResponse> getSimilarQags({
    required String title,
  });
}

class QagDioRepository extends QagRepository {
  final AgoraDioHttpClient httpClient;

  QagDioRepository({required this.httpClient});

  @override
  Future<CreateQagRepositoryResponse> createQag({
    required String title,
    required String description,
    required String author,
    required String thematiqueId,
  }) async {
    try {
      final response = await httpClient.post(
        "/qags",
        data: {
          "title": title,
          "description": description,
          "author": author,
          "thematiqueId": thematiqueId,
        },
      );
      return CreateQagSucceedResponse(qagId: response.data["qagId"] as String);
    } catch (e) {
      if ((e as DioException).response?.statusCode == 403) {
        return CreateQagFailedUnauthorizedResponse();
      }
      return CreateQagFailedResponse();
    }
  }

  @override
  Future<GetQagsRepositoryResponse> fetchQags({
    required String? thematiqueId,
  }) async {
    try {
      final response = await httpClient.get(
        "/qags",
        queryParameters: {"thematiqueId": thematiqueId},
      );
      final qags = response.data["qags"] as Map;
      return GetQagsSucceedResponse(
        qagPopular: _transformToQagList(qags["popular"] as List),
        qagLatest: _transformToQagList(qags["latest"] as List),
        qagSupporting: _transformToQagList(qags["supporting"] as List),
        errorCase: response.data["askQagErrorText"] as String?,
      );
    } catch (e) {
      if (e is DioException) {
        if (e.type == DioExceptionType.connectionTimeout || e.type == DioExceptionType.receiveTimeout) {
          return GetQagsFailedResponse(errorType: QagsErrorType.timeout);
        }
      }
      return GetQagsFailedResponse();
    }
  }

  @override
  Future<GetQagsPaginatedRepositoryResponse> fetchQagsPaginated({
    required int pageNumber,
    required String? thematiqueId,
    required QagPaginatedFilter filter,
    required String? keywords,
  }) async {
    try {
      final response = await httpClient.get(
        "/qags/page/$pageNumber",
        queryParameters: {
          "thematiqueId": thematiqueId,
          "filterType": filter.toFilterString(),
          "keywords": keywords,
        },
      );
      return GetQagsPaginatedSucceedResponse(
        maxPage: response.data["maxPageNumber"] as int,
        paginatedQags: _transformToQagPaginatedList(response.data["qags"] as List),
      );
    } catch (e) {
      return GetQagsPaginatedFailedResponse();
    }
  }

  @override
  Future<GetQagsResponseRepositoryResponse> fetchQagsResponse() async {
    try {
      final response = await httpClient.get("/qags/responses");
      final qagResponsesIncoming = response.data["incomingResponses"] as List;
      final qagResponses = response.data["responses"] as List;
      return GetQagsResponseSucceedResponse(
        qagResponsesIncoming: qagResponsesIncoming.map((qagResponseIncoming) {
          return QagResponseIncoming(
            qagId: qagResponseIncoming["qagId"] as String,
            thematique: (qagResponseIncoming["thematique"] as Map).toThematique(),
            title: qagResponseIncoming["title"] as String,
            supportCount: qagResponseIncoming["support"]["count"] as int,
            isSupported: qagResponseIncoming["support"]["isSupported"] as bool,
          );
        }).toList(),
        qagResponses: qagResponses.map((qagResponse) {
          return QagResponse(
            qagId: qagResponse["qagId"] as String,
            thematique: (qagResponse["thematique"] as Map).toThematique(),
            title: qagResponse["title"] as String,
            author: qagResponse["author"] as String,
            authorPortraitUrl: qagResponse["authorPortraitUrl"] as String,
            responseDate: (qagResponse["responseDate"] as String).parseToDateTime(),
          );
        }).toList(),
      );
    } catch (e) {
      return GetQagsResponseFailedResponse();
    }
  }

  @override
  Future<GetQagsResponsePaginatedRepositoryResponse> fetchQagsResponsePaginated({
    required int pageNumber,
  }) async {
    try {
      final response = await httpClient.get("/qags/responses/page/$pageNumber");
      return GetQagsResponsePaginatedSucceedResponse(
        maxPage: response.data["maxPageNumber"] as int,
        paginatedQagsResponse: _transformToQagResponsePaginatedList(response.data["responses"] as List),
      );
    } catch (e) {
      return GetQagsResponsePaginatedFailedResponse();
    }
  }

  @override
  Future<GetQagDetailsRepositoryResponse> fetchQagDetails({
    required String qagId,
  }) async {
    try {
      final response = await httpClient.get("/qags/$qagId");
      final qagDetailsSupport = response.data["support"] as Map;
      final qagDetailsResponse = response.data["response"] as Map?;
      final qagDetailsFeedbackResults = qagDetailsResponse?["feedbackResults"];
      return GetQagDetailsSucceedResponse(
        qagDetails: QagDetails(
          id: response.data["id"] as String,
          thematique: (response.data["thematique"] as Map).toThematique(),
          title: response.data["title"] as String,
          description: response.data["description"] as String,
          date: (response.data["date"] as String).parseToDateTime(),
          username: response.data["username"] as String,
          canShare: response.data["canShare"] as bool,
          canSupport: response.data["canSupport"] as bool,
          canDelete: response.data["canDelete"] as bool? ?? false,
          isAuthor: response.data["isAuthor"] as bool? ?? false,
          support: QagDetailsSupport(
            count: qagDetailsSupport["count"] as int,
            isSupported: qagDetailsSupport["isSupported"] as bool,
          ),
          response: qagDetailsResponse != null
              ? QagDetailsResponse(
                  author: qagDetailsResponse["author"] as String,
                  authorDescription: qagDetailsResponse["authorDescription"] as String,
                  responseDate: (qagDetailsResponse["responseDate"] as String).parseToDateTime(),
                  videoUrl: qagDetailsResponse["videoUrl"] as String,
                  videoWidth: qagDetailsResponse["videoWidth"] as int,
                  videoHeight: qagDetailsResponse["videoHeight"] as int,
                  transcription: qagDetailsResponse["transcription"] as String,
                  feedbackStatus: qagDetailsResponse["feedbackStatus"] as bool,
                  feedbackResults: qagDetailsFeedbackResults != null
                      ? QagFeedbackResults(
                          positiveRatio: qagDetailsFeedbackResults["positiveRatio"] as int,
                          negativeRatio: qagDetailsFeedbackResults["negativeRatio"] as int,
                          count: qagDetailsFeedbackResults["count"] as int,
                        )
                      : null,
                )
              : null,
        ),
      );
    } catch (e) {
      if (e is DioException) {
        final response = e.response;
        if (response != null && response.statusCode == HttpStatus.locked) {
          return GetQagDetailsModerateFailedResponse();
        }
      }
      return GetQagDetailsFailedResponse();
    }
  }

  @override
  Future<DeleteQagRepositoryResponse> deleteQag({required String qagId}) async {
    try {
      await httpClient.delete("/qags/$qagId");
      return DeleteQagSucceedResponse();
    } catch (e) {
      return DeleteQagFailedResponse();
    }
  }

  @override
  Future<SupportQagRepositoryResponse> supportQag({
    required String qagId,
  }) async {
    try {
      await httpClient.post("/qags/$qagId/support");
      return SupportQagSucceedResponse();
    } catch (e) {
      return SupportQagFailedResponse();
    }
  }

  @override
  Future<DeleteSupportQagRepositoryResponse> deleteSupportQag({required String qagId}) async {
    try {
      await httpClient.delete("/qags/$qagId/support");
      return DeleteSupportQagSucceedResponse();
    } catch (e) {
      return DeleteSupportQagFailedResponse();
    }
  }

  @override
  Future<QagFeedbackRepositoryResponse> giveQagResponseFeedback({
    required String qagId,
    required bool isHelpful,
  }) async {
    try {
      final response = await httpClient.post(
        "/qags/$qagId/feedback",
        data: {"isHelpful": isHelpful},
      );

      if (response.data["positiveRatio"] != null &&
          response.data["negativeRatio"] != null &&
          response.data["count"] != null) {
        return QagFeedbackSuccessBodyWithRatioResponse(
          feedbackBody: QagFeedbackResults(
            positiveRatio: response.data["positiveRatio"] as int,
            negativeRatio: response.data["negativeRatio"] as int,
            count: response.data["count"] as int,
          ),
        );
      } else {
        return QagFeedbackSuccessBodyResponse();
      }
    } catch (e) {
      return QagFeedbackFailedResponse();
    }
  }

  @override
  Future<QagModerationListRepositoryResponse> fetchQagModerationList() async {
    try {
      final response = await httpClient.get("/moderate/qags");
      return QagModerationListSuccessResponse(
        qagModerationList: QagModerationList(
          totalNumber: response.data["totalNumber"] as int,
          qagsToModeration: (response.data["qagsToModerate"] as List)
              .map(
                (qagToModerate) => QagModeration(
                  id: qagToModerate["id"] as String,
                  thematique: (qagToModerate["thematique"] as Map).toThematique(),
                  title: qagToModerate["title"] as String,
                  description: qagToModerate["description"] as String,
                  date: (qagToModerate["date"] as String).parseToDateTime(),
                  username: qagToModerate["username"] as String,
                  supportCount: qagToModerate["support"]["count"] as int,
                  isSupported: qagToModerate["support"]["isSupported"] as bool,
                ),
              )
              .toList(),
        ),
      );
    } catch (e) {
      return QagModerationListFailedResponse();
    }
  }

  @override
  Future<ModerateQagRepositoryResponse> moderateQag({
    required String qagId,
    required bool isAccepted,
  }) async {
    try {
      await httpClient.put(
        "/moderate/qags/$qagId",
        data: {"isAccepted": isAccepted},
      );
      return ModerateQagSuccessResponse();
    } catch (e) {
      return ModerateQagFailedResponse();
    }
  }

  @override
  Future<QagHasSimilarRepositoryResponse> hasSimilarQag({
    required String title,
  }) async {
    try {
      final response = await httpClient.get(
        "/qags/has_similar",
        data: {"title": title},
      );
      return QagHasSimilarSuccessResponse(hasSimilar: response.data["hasSimilar"] as bool);
    } catch (e) {
      return QagHasSimilarFailedResponse();
    }
  }

  @override
  Future<QagSimilarRepositoryResponse> getSimilarQags({required String title}) async {
    try {
      final response = await httpClient.get(
        "/qags/similar",
        data: {"title": title},
      );
      return QagSimilarSuccessResponse(
        similarQags: (response.data["similarQags"] as List)
            .map(
              (qagToModerate) => QagSimilar(
                id: qagToModerate["id"] as String,
                thematique: (qagToModerate["thematique"] as Map).toThematique(),
                title: qagToModerate["title"] as String,
                description: qagToModerate["description"] as String,
                date: (qagToModerate["date"] as String).parseToDateTime(),
                username: qagToModerate["username"] as String,
                supportCount: qagToModerate["support"]["count"] as int,
                isSupported: qagToModerate["support"]["isSupported"] as bool,
              ),
            )
            .toList(),
      );
    } catch (e) {
      return QagSimilarFailedResponse();
    }
  }

  List<Qag> _transformToQagList(List<dynamic> qags) {
    return qags.map((qag) {
      final support = qag["support"] as Map;
      return Qag(
        id: qag["qagId"] as String,
        thematique: (qag["thematique"] as Map).toThematique(),
        title: qag["title"] as String,
        username: qag["username"] as String,
        date: (qag["date"] as String).parseToDateTime(),
        supportCount: support["count"] as int,
        isSupported: support["isSupported"] as bool,
        isAuthor: qag["isAuthor"] as bool,
      );
    }).toList();
  }

  List<QagPaginated> _transformToQagPaginatedList(List<dynamic> paginatedQags) {
    return paginatedQags.map((qag) {
      final support = qag["support"] as Map;
      return QagPaginated(
        id: qag["qagId"] as String,
        thematique: (qag["thematique"] as Map).toThematique(),
        title: qag["title"] as String,
        username: qag["username"] as String,
        date: (qag["date"] as String).parseToDateTime(),
        supportCount: support["count"] as int,
        isSupported: support["isSupported"] as bool,
        isAuthor: qag["isAuthor"] as bool,
      );
    }).toList();
  }

  List<QagResponsePaginated> _transformToQagResponsePaginatedList(List<dynamic> paginatedQagsResponse) {
    return paginatedQagsResponse.map((qagResponse) {
      return QagResponsePaginated(
        qagId: qagResponse["qagId"] as String,
        thematique: (qagResponse["thematique"] as Map).toThematique(),
        title: qagResponse["title"] as String,
        author: qagResponse["author"] as String,
        authorPortraitUrl: qagResponse["authorPortraitUrl"] as String,
        responseDate: (qagResponse["responseDate"] as String).parseToDateTime(),
      );
    }).toList();
  }
}

abstract class CreateQagRepositoryResponse extends Equatable {
  @override
  List<Object> get props => [];
}

class CreateQagSucceedResponse extends CreateQagRepositoryResponse {
  final String qagId;

  CreateQagSucceedResponse({required this.qagId});

  @override
  List<Object> get props => [qagId];
}

class CreateQagFailedResponse extends CreateQagRepositoryResponse {}

class CreateQagFailedUnauthorizedResponse extends CreateQagRepositoryResponse {}

abstract class GetQagsRepositoryResponse extends Equatable {
  @override
  List<Object> get props => [];
}

class GetQagsSucceedResponse extends GetQagsRepositoryResponse {
  final List<Qag> qagPopular;
  final List<Qag> qagLatest;
  final List<Qag> qagSupporting;
  final String? errorCase;

  GetQagsSucceedResponse({
    required this.qagPopular,
    required this.qagLatest,
    required this.qagSupporting,
    required this.errorCase,
  });

  @override
  List<Object> get props => [
        qagPopular,
        qagLatest,
        qagSupporting,
      ];
}

class GetQagsFailedResponse extends GetQagsRepositoryResponse {
  final QagsErrorType errorType;

  GetQagsFailedResponse({this.errorType = QagsErrorType.generic});

  @override
  List<Object> get props => [errorType];
}

abstract class GetQagsPaginatedRepositoryResponse extends Equatable {
  @override
  List<Object> get props => [];
}

class GetQagsPaginatedSucceedResponse extends GetQagsPaginatedRepositoryResponse {
  final int maxPage;
  final List<QagPaginated> paginatedQags;

  GetQagsPaginatedSucceedResponse({required this.maxPage, required this.paginatedQags});

  @override
  List<Object> get props => [maxPage, paginatedQags];
}

class GetQagsPaginatedFailedResponse extends GetQagsPaginatedRepositoryResponse {}

abstract class GetQagsResponseRepositoryResponse extends Equatable {
  @override
  List<Object> get props => [];
}

class GetQagsResponseSucceedResponse extends GetQagsResponseRepositoryResponse {
  final List<QagResponseIncoming> qagResponsesIncoming;
  final List<QagResponse> qagResponses;

  GetQagsResponseSucceedResponse({
    required this.qagResponsesIncoming,
    required this.qagResponses,
  });

  @override
  List<Object> get props => [
        qagResponsesIncoming,
        qagResponses,
      ];
}

class GetQagsResponseFailedResponse extends GetQagsResponseRepositoryResponse {}

abstract class GetQagsResponsePaginatedRepositoryResponse extends Equatable {
  @override
  List<Object> get props => [];
}

class GetQagsResponsePaginatedSucceedResponse extends GetQagsResponsePaginatedRepositoryResponse {
  final int maxPage;
  final List<QagResponsePaginated> paginatedQagsResponse;

  GetQagsResponsePaginatedSucceedResponse({required this.maxPage, required this.paginatedQagsResponse});

  @override
  List<Object> get props => [maxPage, paginatedQagsResponse];
}

class GetQagsResponsePaginatedFailedResponse extends GetQagsResponsePaginatedRepositoryResponse {}

abstract class GetQagDetailsRepositoryResponse extends Equatable {
  @override
  List<Object> get props => [];
}

class GetQagDetailsSucceedResponse extends GetQagDetailsRepositoryResponse {
  final QagDetails qagDetails;

  GetQagDetailsSucceedResponse({required this.qagDetails});

  @override
  List<Object> get props => [qagDetails];
}

class GetQagDetailsModerateFailedResponse extends GetQagDetailsRepositoryResponse {}

class GetQagDetailsFailedResponse extends GetQagDetailsRepositoryResponse {}

abstract class DeleteQagRepositoryResponse extends Equatable {
  @override
  List<Object> get props => [];
}

class DeleteQagSucceedResponse extends DeleteQagRepositoryResponse {}

class DeleteQagFailedResponse extends DeleteQagRepositoryResponse {}

abstract class SupportQagRepositoryResponse extends Equatable {
  @override
  List<Object> get props => [];
}

class SupportQagSucceedResponse extends SupportQagRepositoryResponse {}

class SupportQagFailedResponse extends SupportQagRepositoryResponse {}

abstract class DeleteSupportQagRepositoryResponse extends Equatable {
  @override
  List<Object> get props => [];
}

class DeleteSupportQagSucceedResponse extends DeleteSupportQagRepositoryResponse {}

class DeleteSupportQagFailedResponse extends DeleteSupportQagRepositoryResponse {}

abstract class QagFeedbackRepositoryResponse extends Equatable {
  @override
  List<Object> get props => [];
}

class QagFeedbackSuccessBodyResponse extends QagFeedbackRepositoryResponse {}

class QagFeedbackSuccessBodyWithRatioResponse extends QagFeedbackRepositoryResponse {
  final QagFeedbackResults feedbackBody;

  QagFeedbackSuccessBodyWithRatioResponse({required this.feedbackBody});
}

class QagFeedbackFailedResponse extends QagFeedbackRepositoryResponse {}

abstract class QagModerationListRepositoryResponse extends Equatable {
  @override
  List<Object> get props => [];
}

class QagModerationListSuccessResponse extends QagModerationListRepositoryResponse {
  final QagModerationList qagModerationList;

  QagModerationListSuccessResponse({required this.qagModerationList});

  @override
  List<Object> get props => [qagModerationList];
}

class QagModerationListFailedResponse extends QagModerationListRepositoryResponse {}

abstract class ModerateQagRepositoryResponse extends Equatable {
  @override
  List<Object> get props => [];
}

class ModerateQagSuccessResponse extends ModerateQagRepositoryResponse {}

class ModerateQagFailedResponse extends ModerateQagRepositoryResponse {}

abstract class QagHasSimilarRepositoryResponse extends Equatable {
  @override
  List<Object> get props => [];
}

class QagHasSimilarSuccessResponse extends QagHasSimilarRepositoryResponse {
  final bool hasSimilar;

  QagHasSimilarSuccessResponse({required this.hasSimilar});

  @override
  List<Object> get props => [hasSimilar];
}

class QagHasSimilarFailedResponse extends QagHasSimilarRepositoryResponse {}

abstract class QagSimilarRepositoryResponse extends Equatable {
  @override
  List<Object> get props => [];
}

class QagSimilarSuccessResponse extends QagSimilarRepositoryResponse {
  final List<QagSimilar> similarQags;

  QagSimilarSuccessResponse({required this.similarQags});

  @override
  List<Object> get props => [similarQags];
}

class QagSimilarFailedResponse extends QagSimilarRepositoryResponse {}
