import 'package:agora/domain/qag/qag_response.dart';
import 'package:agora/domain/thematique/thematique.dart';
import 'package:agora/infrastructure/qag/qag_repository.dart';

class MockQagSuccessRepository extends QagDioRepository {
  MockQagSuccessRepository({required super.httpClient});

  @override
  Future<GetQagsRepositoryResponse> fetchQags({
    required String deviceId,
  }) async {
    return GetQagsSucceedResponse(
      qagResponses: [
        QagResponse(
          qagId: "qagId",
          thematique: Thematique(picto: "🚊", label: "Transports", color: "#FFFCF7CF"),
          title: "Pour la retraite : comment est-ce qu’on aboutit au chiffre de 65 ans ?",
          author: "author",
          authorPortraitUrl: "authorPortraitUrl",
          responseDate: DateTime(2024, 1, 23),
        ),
      ],
    );
  }
}
