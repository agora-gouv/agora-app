import 'package:agora/domain/qag/details/qag_details.dart';
import 'package:agora/infrastructure/qag/qag_repository.dart';

// TODO suppress when debouncing is done
class MockQagSuccessRepository extends QagRepository {
  @override
  Future<GetQagDetailsRepositoryResponse> fetchQagDetails({
    required String qagId,
  }) async {
    return GetQagDetailsSucceedResponse(
      qagDetails: QagDetails(
        id: qagId,
        thematiqueId: "1f3dbdc6-cff7-4d6a-88b5-c5ec84c55d15",
        title: "Pour la retraite : comment est-ce qu’on aboutit au chiffre de 65 ans ?",
        description:
            "Le conseil d’orientation des retraites indique que les comptes sont à l’équilibre. A chaque nouveau président l’âge maximal change, qui choisit l’âge de 65 ans et pourquoi ? Je n’ai trouvé aucune justification concrète.",
        date: DateTime(2024, 1, 23),
        username: "CollectifSauvonsLaRetraite",
        supportCount: 112,
      ),
    );
  }
}
