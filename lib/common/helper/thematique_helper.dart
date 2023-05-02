import 'package:agora/bloc/thematique/thematique_view_model.dart';
import 'package:agora/design/custom_view/agora_thematique_card.dart';
import 'package:flutter/material.dart';

class ThematiqueHelper {
  static Widget buildCard(BuildContext context, ThematiqueViewModel thematique) {
    return AgoraThematiqueCard(picto: thematique.picto, label: thematique.label, color: thematique.color);
  }
}
