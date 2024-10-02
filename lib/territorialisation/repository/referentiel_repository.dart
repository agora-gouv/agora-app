import 'package:agora/common/client/agora_http_client.dart';
import 'package:agora/common/log/sentry_wrapper.dart';
import 'package:agora/territorialisation/departement.dart';
import 'package:agora/territorialisation/region.dart';

abstract class ReferentielRepository {
  Future<List<Region>> fetchReferentielRegionsEtDepartements();
}

class ReferentielDioRepository extends ReferentielRepository {
  final AgoraDioHttpClient httpClient;
  final SentryWrapper sentryWrapper;

  ReferentielDioRepository({required this.httpClient, required this.sentryWrapper});

  @override
  Future<List<Region>> fetchReferentielRegionsEtDepartements() async {
    const uri = '/referentiels/regions-et-departements';
    try {
      final response = await httpClient.get(uri);
      final data = response.data as List<dynamic>;
      return data
          .map(
            (item) => Region(
              label: item['region'] as String,
              departements: (item['departements'] as List<dynamic>)
                  .map(
                    (departementLabel) => Departement(
                      label: departementLabel as String,
                    ),
                  )
                  .toList(),
            ),
          )
          .toList();
    } catch (exception, stackTrace) {
      sentryWrapper.captureException(exception, stackTrace, message: "Erreur lors de l'appel : $uri");
      return [];
    }
  }
}
