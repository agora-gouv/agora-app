import 'package:agora/bloc/thematique/thematique_with_id_view_model.dart';
import 'package:agora/domain/thematique/thematique_with_id.dart';

class ThematiquePresenter {
  static List<ThematiqueWithIdViewModel> present(List<ThematiqueWithId> thematiques) {
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
