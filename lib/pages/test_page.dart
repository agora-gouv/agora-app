import 'package:agora/bloc/thematique/thematique_bloc.dart';
import 'package:agora/bloc/thematique/thematique_state.dart';
import 'package:agora/design/custom_view/agora_scaffold.dart';
import 'package:agora/design/custom_view/agora_thematique_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TestPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AgoraScaffold(
      child: BlocBuilder<ThematiqueBloc, ThematiqueState>(
        builder: (context, state) {
          if (state is ThematiqueSuccessState) {
            final pastilles = state.viewModel
                .map(
                  (thematiqueViewModel) => AgoraThematiqueCard(
                    id: thematiqueViewModel.id,
                    picto: thematiqueViewModel.picto,
                    label: thematiqueViewModel.label,
                    color: thematiqueViewModel.color,
                  ),
                )
                .toList();
            return Column(children: pastilles);
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
