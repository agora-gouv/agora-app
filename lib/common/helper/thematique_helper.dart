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
    required Function(String) onThematiqueIdSelected,
    bool needHorizontalSpacing = true,
  }) {
    List<Widget> thematiqueWidgets = thematiques
        .map(
          (thematique) => Column(
            children: [
              AgoraToggleButton(
                isSelected: thematique.id == selectedThematiqueId,
                text: thematique.picto,
                onClicked: () => onThematiqueIdSelected(thematique.id),
              ),
              SizedBox(height: AgoraSpacings.x0_5),
              SizedBox(
                width: 80,
                child: Text(
                  thematique.label,
                  style: AgoraTextStyles.medium12,
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        )
        .toList();

    if (needHorizontalSpacing) {
      final List<Widget> spacingSizedBox = [SizedBox(width: AgoraSpacings.base)];
      thematiqueWidgets = spacingSizedBox + thematiqueWidgets + spacingSizedBox;
    }
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: thematiqueWidgets,
    );
  }
}
