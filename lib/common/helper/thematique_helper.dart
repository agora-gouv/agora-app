import 'package:agora/design/custom_view/button/agora_thematique_toggle_button.dart';
import 'package:agora/design/custom_view/card/agora_thematique_card.dart';
import 'package:agora/design/style/agora_spacings.dart';
import 'package:agora/design/style/agora_text_styles.dart';
import 'package:agora/thematique/bloc/thematique_view_model.dart';
import 'package:agora/thematique/bloc/thematique_with_id_view_model.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';

class ThematiqueHelper {
  static Widget buildCard(
    BuildContext context,
    ThematiqueViewModel thematique, {
    AgoraThematiqueSize size = AgoraThematiqueSize.medium,
  }) {
    return AgoraThematiqueLabel(picto: thematique.picto, label: thematique.label, size: size);
  }

  static Widget buildThematiques({
    required List<ThematiqueWithIdViewModel> thematiques,
    required String? selectedThematiqueId,
    required GlobalKey firstThematiqueKey,
    required Function(String?, String?) onThematiqueSelected,
    bool needHorizontalSpacing = true,
  }) {
    List<Widget> thematiqueWidgets = thematiques.mapIndexed(
      (index, thematique) {
        return Semantics(
          key: index == 0 ? firstThematiqueKey : null,
          toggled: thematique.id == selectedThematiqueId,
          label: thematique.label,
          tooltip: 'élément ${thematiques.indexOf(thematique) + 1} sur ${thematiques.length}',
          child: ExcludeSemantics(
            child: Column(
              children: [
                AgoraToggleButton(
                  isSelected: thematique.id == selectedThematiqueId,
                  text: thematique.picto,
                  onPressed: () => onThematiqueSelected(thematique.id, thematique.label),
                ),
                SizedBox(height: AgoraSpacings.x0_5),
                SizedBox(
                  width: 85,
                  child: Text(
                    thematique.label,
                    style: AgoraTextStyles.medium11,
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(height: AgoraSpacings.x0_5),
              ],
            ),
          ),
        );
      },
    ).toList();

    if (needHorizontalSpacing) {
      final List<Widget> spacingSizedBox = [SizedBox(width: AgoraSpacings.base)];
      thematiqueWidgets = spacingSizedBox + thematiqueWidgets + spacingSizedBox;
    }
    return Semantics(
      label: 'Liste des filtres par thématiques',
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: thematiqueWidgets,
      ),
    );
  }
}
