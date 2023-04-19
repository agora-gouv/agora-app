import 'package:agora/domain/qag/details/qag_details.dart';
import 'package:agora/infrastructure/qag/qag_repository.dart';

class FakeQagSuccessRepository extends QagRepository {
  @override
  Future<GetQagDetailsRepositoryResponse> fetchQagDetails({
    required String qagId,
    required String deviceId,
  }) async {
    return GetQagDetailsSucceedResponse(
      qagDetails: QagDetails(
        id: qagId,
        thematiqueId: "1f3dbdc6-cff7-4d6a-88b5-c5ec84c55d15",
        title: "Pour la retraite : comment est-ce qu’on aboutit au chiffre de 65 ans ?",
        description: "Le conseil d’orientation des retraites indique que les comptes sont à l’équilibre.",
        date: DateTime(2024, 1, 23),
        username: "CollectifSauvonsLaRetraite",
        support: QagDetailsSupport(
          count: 112,
          isSupported: true,
        ),
      ),
    );
  }

  @override
  Future<SupportQagRepositoryResponse> supportQag({required String qagId, required String deviceId}) async {
    return SupportQagSucceedResponse();
  }

  @override
  Future<DeleteSupportQagRepositoryResponse> deleteSupportQag({required String qagId, required String deviceId}) async {
    return DeleteSupportQagSucceedResponse();
  }
}

class FakeQagSuccessWithSupportNullRepository extends FakeQagSuccessRepository {
  @override
  Future<GetQagDetailsRepositoryResponse> fetchQagDetails({
    required String qagId,
    required String deviceId,
  }) async {
    return GetQagDetailsSucceedResponse(
      qagDetails: QagDetails(
        id: qagId,
        thematiqueId: "1f3dbdc6-cff7-4d6a-88b5-c5ec84c55d15",
        title: "Pour la retraite : comment est-ce qu’on aboutit au chiffre de 65 ans ?",
        description: "Le conseil d’orientation des retraites indique que les comptes sont à l’équilibre.",
        date: DateTime(2024, 1, 23),
        username: "CollectifSauvonsLaRetraite",
        support: null,
      ),
    );
  }

  @override
  Future<SupportQagRepositoryResponse> supportQag({required String qagId, required String deviceId}) async {
    return SupportQagSucceedResponse();
  }

  @override
  Future<DeleteSupportQagRepositoryResponse> deleteSupportQag({required String qagId, required String deviceId}) async {
    return DeleteSupportQagSucceedResponse();
  }
}

class FakeQagFailureRepository extends QagRepository {
  @override
  Future<GetQagDetailsRepositoryResponse> fetchQagDetails({
    required String qagId,
    required String deviceId,
  }) async {
    return GetQagDetailsFailedResponse();
  }

  @override
  Future<SupportQagRepositoryResponse> supportQag({required String qagId, required String deviceId}) async {
    return SupportQagFailedResponse();
  }

  @override
  Future<DeleteSupportQagRepositoryResponse> deleteSupportQag({required String qagId, required String deviceId}) async {
    return DeleteSupportQagFailedResponse();
  }
}
