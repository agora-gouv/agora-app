import 'package:agora/common/client/agora_http_client.dart';
import 'package:agora/common/extension/date_extension.dart';
import 'package:agora/common/log/log.dart';
import 'package:agora/domain/qag/details/qag_details.dart';
import 'package:equatable/equatable.dart';

abstract class QagRepository {
  Future<GetQagDetailsRepositoryResponse> fetchQagDetails({required String qagId});
}

class QagDioRepository extends QagRepository {
  final AgoraDioHttpClient httpClient;

  QagDioRepository({required this.httpClient});

  @override
  Future<GetQagDetailsRepositoryResponse> fetchQagDetails({
    required String qagId,
  }) async {
    try {
      final response = await httpClient.get("/qags/$qagId");
      return GetQagDetailsSucceedResponse(
        qagDetails: QagDetails(
          id: response.data["id"] as String,
          thematiqueId: response.data["thematiqueId"] as String,
          title: response.data["title"] as String,
          description: response.data["description"] as String,
          date: (response.data["date"] as String).parseToDateTime(),
          username: response.data["username"] as String,
          supportCount: response.data["supportCount"] as int,
        ),
      );
    } catch (e) {
      Log.e("fetchQagDetails failed", e);
      return GetQagDetailsFailedResponse();
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
