import 'dart:io';

import 'package:agora/common/log/sentry_wrapper.dart';
import 'package:agora/referentiel/departement.dart';
import 'package:agora/referentiel/pays.dart';
import 'package:agora/referentiel/region.dart';
import 'package:agora/referentiel/repository/referentiel_repository.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../utils/dio_utils.dart';

void main() {
  final dioAdapter = DioUtils.dioAdapter();
  final httpClient = DioUtils.agoraDioHttpClient();
  final sentryWrapper = SentryWrapper();

  group("Get Referentiel", () {
    test("quand succès, renvois la listes des régions avec leurs départements", () async {
      // Given
      dioAdapter.onGet(
        '/referentiels/regions-et-departements',
        (request) => request.reply(HttpStatus.ok, {
          "regions": [
            {
              "region": "Auvergne-Rhône-Alpes",
              "departements": [
                {
                  "codePostal": "01",
                  "label": "Ain",
                },
              ],
            },
            {
              "region": "Bourgogne-Franche-Comté",
              "departements": [
                {
                  "codePostal": "21",
                  "label": "Côte-d’Or",
                },
              ],
            },
            {
              "region": "Bretagne",
              "departements": [
                {
                  "codePostal": "22",
                  "label": "Côtes-d’Armor",
                },
              ],
            },
            {
              "region": "Centre-Val de Loire",
              "departements": [
                {
                  "codePostal": "18",
                  "label": "Cher",
                },
              ],
            },
          ],
          "pays": [
            "National",
            "Français de l'étranger",
          ],
        }),
        headers: {
          "accept": "application/json",
          "Authorization": "Bearer jwtToken",
        },
      );

      // When
      final repository = ReferentielDioRepository(httpClient: httpClient, sentryWrapper: sentryWrapper);
      final response = await repository.fetchReferentielRegionsEtDepartements();

      // Then
      expect(response, [
        Region(
          label: "Auvergne-Rhône-Alpes",
          departements: [
            Departement(label: "Ain", codePostal: "01"),
          ],
        ),
        Region(
          label: "Bourgogne-Franche-Comté",
          departements: [
            Departement(label: "Côte-d’Or", codePostal: "21"),
          ],
        ),
        Region(
          label: "Bretagne",
          departements: [
            Departement(label: "Côtes-d’Armor", codePostal: "22"),
          ],
        ),
        Region(
          label: "Centre-Val de Loire",
          departements: [
            Departement(label: "Cher", codePostal: "18"),
          ],
        ),
        Pays(label: "National"),
        Pays(label: "Français de l'étranger"),
      ]);
    });
  });
}
