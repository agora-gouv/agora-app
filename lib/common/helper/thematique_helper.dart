import 'package:agora/bloc/thematique/thematique_bloc.dart';
import 'package:agora/bloc/thematique/thematique_state.dart';
import 'package:agora/design/custom_view/agora_thematique_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ThematiqueHelper {
  static Widget buildCard(BuildContext context, String thematiqueId) {
    final thematiqueState = context.read<ThematiqueBloc>().state;
    if (thematiqueState is ThematiqueSuccessState) {
      try {
        final thematique = thematiqueState.viewModel.firstWhere((thematique) => thematique.id == thematiqueId);
        return AgoraThematiqueCard(picto: thematique.picto, label: thematique.label, color: thematique.color);
      } catch (e) {
        return Container();
      }
    } else {
      return Container();
    }
  }
}
