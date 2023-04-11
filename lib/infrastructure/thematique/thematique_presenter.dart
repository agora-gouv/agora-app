import 'package:agora/bloc/thematique/thematique_view_model.dart';
import 'package:agora/common/extension/string_extension.dart';
import 'package:agora/domain/thematique/thematique.dart';

class ThematiquePresenter {
  static List<ThematiqueViewModel> present(List<Thematique> thematiques) {
    return thematiques
        .map(
          (thematique) => ThematiqueViewModel(
            id: thematique.id,
            picto: thematique.picto,
            label: thematique.label,
            color: thematique.color.toColorInt(),
          ),
        )
        .toList();
  }
}
