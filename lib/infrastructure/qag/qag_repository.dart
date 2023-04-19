import 'package:agora/common/client/agora_http_client.dart';
import 'package:agora/common/extension/date_extension.dart';
import 'package:agora/common/log/log.dart';
import 'package:agora/domain/qag/details/qag_details.dart';
import 'package:equatable/equatable.dart';

abstract class QagRepository {
  Future<GetQagDetailsRepositoryResponse> fetchQagDetails({required String qagId, required String deviceId});

  Future<SupportQagRepositoryResponse> supportQag({required String qagId, required String deviceId});

  Future<DeleteSupportQagRepositoryResponse> deleteSupportQag({required String qagId, required String deviceId});
}

class QagDioRepository extends QagRepository {
  final AgoraDioHttpClient httpClient;

  QagDioRepository({required this.httpClient});

  @override
  Future<GetQagDetailsRepositoryResponse> fetchQagDetails({
    required String qagId,
    required String deviceId,
  }) async {
    try {
      final response = await httpClient.get(
        "/qags/$qagId",
        headers: {"deviceId": deviceId},
      );
      final qagDetailsSupport = response.data["support"] as Map?;
      return GetQagDetailsSucceedResponse(
        qagDetails: QagDetails(
          id: response.data["id"] as String,
          thematiqueId: response.data["thematiqueId"] as String,
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
    required String deviceId,
  }) async {
    try {
      await httpClient.post(
        "/qags/$qagId/support",
        headers: {"deviceId": deviceId},
      );
      return SupportQagSucceedResponse();
    } catch (e) {
      Log.e("supportQag failed", e);
      return SupportQagFailedResponse();
    }
  }

  @override
  Future<DeleteSupportQagRepositoryResponse> deleteSupportQag({required String qagId, required String deviceId}) async {
    try {
      await httpClient.delete(
        "/qags/$qagId/support",
        headers: {"deviceId": deviceId},
      );
      return DeleteSupportQagSucceedResponse();
    } catch (e) {
      Log.e("deleteSupportQag failed", e);
      return DeleteSupportQagFailedResponse();
    }
  }
}

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
