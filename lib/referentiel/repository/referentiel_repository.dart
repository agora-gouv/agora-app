import 'package:agora/common/client/agora_http_client.dart';
import 'package:agora/common/log/sentry_wrapper.dart';
import 'package:agora/referentiel/departement.dart';
import 'package:agora/referentiel/pays.dart';
import 'package:agora/referentiel/region.dart';
import 'package:agora/referentiel/territoire.dart';

abstract class ReferentielRepository {
  Future<List<Territoire>> fetchReferentielRegionsEtDepartements();
}

class ReferentielDioRepository extends ReferentielRepository {
  final AgoraDioHttpClient httpClient;
  final SentryWrapper sentryWrapper;

  ReferentielDioRepository({required this.httpClient, required this.sentryWrapper});

  @override
  Future<List<Territoire>> fetchReferentielRegionsEtDepartements() async {
    const uri = '/referentiels/regions-et-departements';
    try {
      final response = await httpClient.get(uri);
      final data = response.data as Map<String, dynamic>;

      final regionsJson = data['regions'] as List<dynamic>;
      final paysJson = data['pays'] as List<dynamic>;

      final List<Territoire> territoires = [];

      for (var item in regionsJson) {
        territoires.add(
          Region(
            label: item['region'] as String,
            departements: (item['departements'] as List<dynamic>)
                .map(
                  (departement) => Departement(
                    codePostal: departement["codePostal"] as String,
                    label: departement["label"] as String,
                  ),
                )
                .toList(),
          ),
        );
      }
      for (var item in paysJson) {
        territoires.add(Pays(label: item as String));
      }
      return territoires;
    } catch (exception, stackTrace) {
      sentryWrapper.captureException(exception, stackTrace, message: "Erreur lors de l'appel : $uri");
      return [];
    }
  }
}
