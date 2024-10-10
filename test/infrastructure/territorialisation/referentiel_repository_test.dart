import 'dart:io';

import 'package:agora/common/log/sentry_wrapper.dart';
import 'package:agora/territorialisation/departement.dart';
import 'package:agora/territorialisation/pays.dart';
import 'package:agora/territorialisation/region.dart';
import 'package:agora/territorialisation/repository/referentiel_repository.dart';
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
            Departement(label: "Allier", codePostal: "03"),
            Departement(label: "Ardèche", codePostal: "07"),
            Departement(label: "Cantal", codePostal: "15"),
            Departement(label: "Drôme", codePostal: "26"),
            Departement(label: "Isère", codePostal: "38"),
            Departement(label: "Loire", codePostal: "42"),
            Departement(label: "Haute-Loire", codePostal: "43"),
            Departement(label: "Puy-de-Dôme", codePostal: "63"),
            Departement(label: "Rhône", codePostal: "69"),
            Departement(label: "Savoie", codePostal: "73"),
            Departement(label: "Haute-Savoie", codePostal: "74"),
          ],
        ),
        Region(
          label: "Bourgogne-Franche-Comté",
          departements: [
            Departement(label: "Côte-d’Or", codePostal: "21"),
            Departement(label: "Doubs", codePostal: "25"),
            Departement(label: "Jura", codePostal: "39"),
            Departement(label: "Nièvre", codePostal: "58"),
            Departement(label: "Haute-Saône", codePostal: "70"),
            Departement(label: "Saône-et-Loire", codePostal: "71"),
            Departement(label: "Yonne", codePostal: "89"),
            Departement(label: "Territoire de Belfort", codePostal: "90"),
          ],
        ),
        Region(
          label: "Bretagne",
          departements: [
            Departement(label: "Côtes-d’Armor", codePostal: "22"),
            Departement(label: "Finistère", codePostal: "29"),
            Departement(label: "Ille-et-Vilaine", codePostal: "35"),
            Departement(label: "Morbihan", codePostal: "56"),
          ],
        ),
        Region(
          label: "Centre-Val de Loire",
          departements: [
            Departement(label: "Cher", codePostal: "18"),
            Departement(label: "Eure-et-Loir", codePostal: "28"),
            Departement(label: "Indre", codePostal: "36"),
            Departement(label: "Indre-et-Loire", codePostal: "37"),
            Departement(label: "Loir-et-Cher", codePostal: "41"),
            Departement(label: "Loiret", codePostal: "45"),
          ],
        ),
        Pays(label: "National"),
        Pays(label: "Français de l'étranger"),
      ]);
    });
  });
}
