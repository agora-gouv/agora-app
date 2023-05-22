import 'package:agora/common/client/agora_http_client.dart';
import 'package:agora/common/extension/date_extension.dart';
import 'package:agora/common/extension/thematique_extension.dart';
import 'package:agora/common/log/log.dart';
import 'package:agora/domain/qag/details/qag_details.dart';
import 'package:agora/domain/qag/qag.dart';
import 'package:agora/domain/qag/qag_response.dart';
import 'package:equatable/equatable.dart';

abstract class QagRepository {
  Future<CreateQagRepositoryResponse> createQag({
    required String deviceId,
    required String title,
    required String description,
    required String author,
    required String thematiqueId,
  });

  Future<GetQagsRepositoryResponse> fetchQags({
    required String? thematiqueId,
  });

  Future<GetQagDetailsRepositoryResponse> fetchQagDetails({
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
}

class QagDioRepository extends QagRepository {
  final AgoraDioHttpClient httpClient;

  QagDioRepository({required this.httpClient});

  @override
  Future<CreateQagRepositoryResponse> createQag({
    required String deviceId,
    required String title,
    required String description,
    required String author,
    required String thematiqueId,
  }) async {
    try {
      await httpClient.post(
        "/qags",
        data: {
          "title": title,
          "description": description,
          "author": author,
          "thematiqueId": thematiqueId,
        },
        headers: {"deviceId": deviceId},
      );
      return CreateQagSucceedResponse();
    } catch (e) {
      Log.e("createQag failed", e);
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
      final qagResponses = response.data["responses"] as List;
      final qags = response.data["qags"] as Map;
      return GetQagsSucceedResponse(
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
        qagPopular: _transformToQagList(qags["popular"] as List),
        qagLatest: _transformToQagList(qags["latest"] as List),
        qagSupporting: _transformToQagList(qags["supporting"] as List),
      );
    } catch (e) {
      Log.e("fetchQags failed", e);
      return GetQagsFailedResponse();
    }
  }

  @override
  Future<GetQagDetailsRepositoryResponse> fetchQagDetails({
    required String qagId,
  }) async {
    try {
      final response = await httpClient.get(
        "/qags/$qagId",
      );
      final qagDetailsSupport = response.data["support"] as Map?;
      final qagDetailsResponse = response.data["response"] as Map?;
      return GetQagDetailsSucceedResponse(
        qagDetails: QagDetails(
          id: response.data["id"] as String,
          thematique: (response.data["thematique"] as Map).toThematique(),
          title: response.data["title"] as String,
          description: response.data["description"] as String,
          date: (response.data["date"] as String).parseToDateTime(),
          username: response.data["username"] as String,
          support: qagDetailsSupport != null
              ? QagDetailsSupport(
                  count: qagDetailsSupport["count"] as int,
                  isSupported: qagDetailsSupport["isSupported"] as bool,
                )
              : null,
          response: qagDetailsResponse != null
              ? QagDetailsResponse(
                  author: qagDetailsResponse["author"] as String,
                  authorDescription: qagDetailsResponse["authorDescription"] as String,
                  responseDate: (qagDetailsResponse["responseDate"] as String).parseToDateTime(),
                  videoUrl: qagDetailsResponse["videoUrl"] as String,
                  transcription: qagDetailsResponse["transcription"] as String,
                  feedbackStatus: qagDetailsResponse["feedbackStatus"] as bool,
                )
              : null,
        ),
      );
    } catch (e) {
      Log.e("fetchQagDetails failed", e);
      return GetQagDetailsFailedResponse();
    }
  }

  @override
  Future<SupportQagRepositoryResponse> supportQag({
    required String qagId,
  }) async {
    try {
      await httpClient.post(
        "/qags/$qagId/support",
      );
      return SupportQagSucceedResponse();
    } catch (e) {
      Log.e("supportQag failed", e);
      return SupportQagFailedResponse();
    }
  }

  @override
  Future<DeleteSupportQagRepositoryResponse> deleteSupportQag({required String qagId}) async {
    try {
      await httpClient.delete(
        "/qags/$qagId/support",
      );
      return DeleteSupportQagSucceedResponse();
    } catch (e) {
      Log.e("deleteSupportQag failed", e);
      return DeleteSupportQagFailedResponse();
    }
  }

  @override
  Future<QagFeedbackRepositoryResponse> giveQagResponseFeedback({
    required String qagId,
    required bool isHelpful,
  }) async {
    try {
      await httpClient.post(
        "/qags/$qagId/feedback",
        data: {"isHelpful": isHelpful},
      );
      return QagFeedbackSuccessResponse();
    } catch (e) {
      Log.e("giveQagResponseFeedback failed", e);
      return QagFeedbackFailedResponse();
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
      );
    }).toList();
  }
}

abstract class CreateQagRepositoryResponse extends Equatable {
  @override
  List<Object> get props => [];
}

class CreateQagSucceedResponse extends CreateQagRepositoryResponse {}

class CreateQagFailedResponse extends CreateQagRepositoryResponse {}

abstract class GetQagsRepositoryResponse extends Equatable {
  @override
  List<Object> get props => [];
}

class GetQagsSucceedResponse extends GetQagsRepositoryResponse {
  final List<QagResponse> qagResponses;
  final List<Qag> qagPopular;
  final List<Qag> qagLatest;
  final List<Qag> qagSupporting;

  GetQagsSucceedResponse({
    required this.qagResponses,
    required this.qagPopular,
    required this.qagLatest,
    required this.qagSupporting,
  });

  @override
  List<Object> get props => [
        qagResponses,
        qagPopular,
        qagLatest,
        qagSupporting,
      ];
}

class GetQagsFailedResponse extends GetQagsRepositoryResponse {}

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

class GetQagDetailsFailedResponse extends GetQagDetailsRepositoryResponse {}

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

class QagFeedbackSuccessResponse extends QagFeedbackRepositoryResponse {}

class QagFeedbackFailedResponse extends QagFeedbackRepositoryResponse {}
