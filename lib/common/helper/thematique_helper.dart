import 'package:agora/bloc/thematique/thematique_view_model.dart';
import 'package:agora/bloc/thematique/thematique_with_id_view_model.dart';
import 'package:agora/design/custom_view/agora_thematique_card.dart';
import 'package:agora/design/custom_view/agora_thematique_toggle_button.dart';
import 'package:agora/design/style/agora_spacings.dart';
import 'package:agora/design/style/agora_text_styles.dart';
import 'package:flutter/material.dart';

class ThematiqueHelper {
  static Widget buildCard(
    BuildContext context,
    ThematiqueViewModel thematique, {
    AgoraThematiqueSize size = AgoraThematiqueSize.medium,
  }) {
    return AgoraThematiqueCard(picto: thematique.picto, label: thematique.label, size: size);
  }

  static Widget buildThematiques({
    required List<ThematiqueWithIdViewModel> thematiques,
    required String? selectedThematiqueId,
    required Function(String?) onThematiqueIdSelected,
    bool needHorizontalSpacing = true,
  }) {
    List<Widget> thematiqueWidgets = thematiques
        .map(
          (thematique) => Semantics(
            toggled: thematique.id == selectedThematiqueId,
            label: thematique.label,
            tooltip: 'élément ${thematiques.indexOf(thematique) + 1} sur ${thematiques.length}',
            child: ExcludeSemantics(
              child: Column(
                children: [
                  AgoraToggleButton(
                    isSelected: thematique.id == selectedThematiqueId,
                    text: thematique.picto,
                    onClicked: () => onThematiqueIdSelected(thematique.id),
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
                ],
              ),
            ),
          ),
        )
        .toList();

    if (needHorizontalSpacing) {
      final List<Widget> spacingSizedBox = [SizedBox(width: AgoraSpacings.base)];
      thematiqueWidgets = spacingSizedBox + thematiqueWidgets + spacingSizedBox;
    }
    return Semantics(
      label: 'Liste des thématiques',
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: thematiqueWidgets,
      ),
    );
  }
}
