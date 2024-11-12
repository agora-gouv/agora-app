import 'package:agora/referentiel/departement.dart';
import 'package:agora/referentiel/region.dart';
import 'package:agora/referentiel/repository/referentiel_cache_repository.dart';
import 'package:agora/referentiel/repository/referentiel_repository.dart';
import 'package:agora/referentiel/territoire.dart';

class FakesReferentielRepository extends ReferentielRepository {
  @override
  Future<List<Region<Territoire>>> fetchReferentielRegionsEtDepartements() {
    return Future.value([
      Region(
        label: 'Ile-de-France',
        departements: [
          Departement(label: 'Paris', codePostal: "75"),
        ],
      ),
      Region(
        label: 'Normandie',
        departements: [
          Departement(label: 'Calvados', codePostal: "14"),
          Departement(label: 'Eure', codePostal: "27"),
        ],
      ),
    ]);
  }
}

class FakesReferentielCacheRepository extends ReferentielCacheRepository {
  FakesReferentielCacheRepository({required super.referentielRepository});

  @override
  bool get isCacheSuccess => false;
}
