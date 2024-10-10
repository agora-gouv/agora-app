import 'package:agora/territorialisation/departement.dart';
import 'package:agora/territorialisation/region.dart';
import 'package:agora/territorialisation/repository/referentiel_repository.dart';
import 'package:agora/territorialisation/territoire.dart';

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
