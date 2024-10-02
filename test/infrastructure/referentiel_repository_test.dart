import 'dart:io';

import 'package:agora/common/log/sentry_wrapper.dart';
import 'package:agora/territorialisation/departement.dart';
import 'package:agora/territorialisation/region.dart';
import 'package:agora/territorialisation/repository/referentiel_repository.dart';
import 'package:flutter_test/flutter_test.dart';

import '../utils/dio_utils.dart';

void main() {
  final dioAdapter = DioUtils.dioAdapter();
  final httpClient = DioUtils.agoraDioHttpClient();
  final sentryWrapper = SentryWrapper();

  group("Get Referentiel", () {
    test("quand succès, renvois la listes des régions avec leurs départements", () async {
      // Given
      dioAdapter.onGet(
        '/referentiels/regions-et-departements',
        (request) => request.reply(HttpStatus.ok, [
          {
            "region": "Auvergne-Rhône-Alpes",
            "departements": [
              "Ain",
              "Allier",
              "Ardèche",
              "Cantal",
              "Drôme",
              "Isère",
              "Loire",
              "Haute-Loire",
              "Puy-de-Dôme",
              "Rhône",
              "Savoie",
              "Haute-Savoie",
            ],
          },
          {
            "region": "Bourgogne-Franche-Comté",
            "departements": [
              "Côte-d’Or",
              "Doubs",
              "Jura",
              "Nièvre",
              "Haute-Saône",
              "Saône-et-Loire",
              "Yonne",
              "Territoire de Belfort",
            ],
          },
          {
            "region": "Bretagne",
            "departements": [
              "Côtes-d’Armor",
              "Finistère",
              "Ille-et-Vilaine",
              "Morbihan",
            ],
          },
          {
            "region": "Centre-Val de Loire",
            "departements": [
              "Cher",
              "Eure-et-Loir",
              "Indre",
              "Indre-et-Loire",
              "Loir-et-Cher",
              "Loiret",
            ],
          },
        ]),
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
            Departement(label: "Ain"),
            Departement(label: "Allier"),
            Departement(label: "Ardèche"),
            Departement(label: "Cantal"),
            Departement(label: "Drôme"),
            Departement(label: "Isère"),
            Departement(label: "Loire"),
            Departement(label: "Haute-Loire"),
            Departement(label: "Puy-de-Dôme"),
            Departement(label: "Rhône"),
            Departement(label: "Savoie"),
            Departement(label: "Haute-Savoie"),
          ],
        ),
        Region(
          label: "Bourgogne-Franche-Comté",
          departements: [
            Departement(label: "Côte-d’Or"),
            Departement(label: "Doubs"),
            Departement(label: "Jura"),
            Departement(label: "Nièvre"),
            Departement(label: "Haute-Saône"),
            Departement(label: "Saône-et-Loire"),
            Departement(label: "Yonne"),
            Departement(label: "Territoire de Belfort"),
          ],
        ),
        Region(
          label: "Bretagne",
          departements: [
            Departement(label: "Côtes-d’Armor"),
            Departement(label: "Finistère"),
            Departement(label: "Ille-et-Vilaine"),
            Departement(label: "Morbihan"),
          ],
        ),
        Region(
          label: "Centre-Val de Loire",
          departements: [
            Departement(label: "Cher"),
            Departement(label: "Eure-et-Loir"),
            Departement(label: "Indre"),
            Departement(label: "Indre-et-Loire"),
            Departement(label: "Loir-et-Cher"),
            Departement(label: "Loiret"),
          ],
        ),
      ]);
    });
  });
}
