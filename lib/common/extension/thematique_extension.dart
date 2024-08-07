import 'package:agora/thematique/bloc/thematique_view_model.dart';
import 'package:agora/thematique/domain/thematique.dart';

extension ThematiqueExtension on Thematique {
  ThematiqueViewModel toThematiqueViewModel() {
    return ThematiqueViewModel(picto: picto, label: label);
  }
}

extension ConvertMapToThematiqueExtension on Map<dynamic, dynamic> {
  Thematique toThematique() {
    return Thematique(
      picto: this["picto"] as String,
      label: this["label"] as String,
    );
  }
}
