import 'package:agora/bloc/thematique/thematique_view_model.dart';
import 'package:agora/common/extension/color_extension.dart';
import 'package:agora/domain/thematique/thematique.dart';

extension ThematiqueExtension on Thematique {
  ThematiqueViewModel toThematiqueViewModel() {
    return ThematiqueViewModel(picto: picto, label: label, color: color.toColorInt());
  }
}
