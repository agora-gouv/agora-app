import 'package:agora/domain/qag/qag.dart';
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
          qagId: "889b41ad-321b-4338-8596-df745c546919",
          thematique: Thematique(picto: "🚊", label: "Transports", color: "#FFFCF7CF"),
          title:
              "Pour la retraite : comment est-ce qu’on aboutit au chiffre de 65 ans ? titres très loooooooooooooooooooooooooooooooooog",
          author: "Stormtrooper",
          authorPortraitUrl: "https://betagouv.github.io/agora-content/QaG-Stormtrooper-Response.png",
          responseDate: DateTime(2024, 1, 23),
        ),
        QagResponse(
          qagId: "889b41ad-321b-4338-8596-df745c546919",
          thematique: Thematique(picto: "🚊", label: "Transports", color: "#FFFCF7CF"),
          title: "Pour la retraite : comment est-ce qu’on aboutit au chiffre de 65 ans ?",
          author: "Stormtrooper",
          authorPortraitUrl: "https://betagouv.github.io/agora-content/QaG-Stormtrooper-Response.png",
          responseDate: DateTime(2024, 1, 23),
        ),
      ],
      qagPopular: [
        Qag(
          id: "f29c5d6f-9838-4c57-a7ec-0612145bb0c8",
          thematique: Thematique(picto: "🚊", label: "Transports", color: "#FFFCF7CF"),
          title: "Pour la retraite : comment est-ce qu’on aboutit au chiffre de 65 ans ?",
          username: "Harry P.",
          date: DateTime(2024, 1, 23),
          supportCount: 7,
          isSupported: false,
        ),
        Qag(
          id: "f29c5d6f-9838-4c57-a7ec-0612145bb0c8",
          thematique: Thematique(picto: "🚊", label: "Transports", color: "#FFFCF7CF"),
          title: "Pour la retraite : comment est-ce qu’on aboutit au chiffre de 65 ans ?",
          username: "Harry P.",
          date: DateTime(2024, 1, 23),
          supportCount: 7,
          isSupported: false,
        ),
      ],
      qagLatest: [],
      qagSupporting: [],
    );
  }
}
