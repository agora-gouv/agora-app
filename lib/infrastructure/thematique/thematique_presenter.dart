import 'package:agora/bloc/thematique/thematique_with_id_view_model.dart';
import 'package:agora/domain/thematique/thematique_with_id.dart';

class ThematiquePresenter {
  static List<ThematiqueWithIdViewModel> presentFilterThematique(List<ThematiqueWithId> thematiques) {
    return [
      ThematiqueWithIdViewModel(
        id: null,
        picto: "\ud83d\udca1",
        label: "Toutes",
      ),
      ..._buildThematiques(thematiques),
    ];
  }

  static List<ThematiqueWithIdViewModel> presentAskQaGThematique(List<ThematiqueWithId> thematiques) {
    final currentThematiques = _buildThematiques(thematiques);
    final findOtherThematique = currentThematiques.firstWhere((element) => element.label == "Autre");
    currentThematiques.remove(findOtherThematique);

    final newOtherThematique = ThematiqueWithIdViewModel(
      id: findOtherThematique.id,
      picto: findOtherThematique.picto,
      label: "Autre / Je ne sais pas",
    );
    currentThematiques.insert(0, newOtherThematique);
    return currentThematiques;
  }

  static List<ThematiqueWithIdViewModel> _buildThematiques(List<ThematiqueWithId> thematiques) {
    return thematiques
        .map(
          (thematique) => ThematiqueWithIdViewModel(
            id: thematique.id,
            picto: thematique.picto,
            label: thematique.label,
          ),
        )
        .toList();
  }
}
