import 'package:agora/bloc/thematique/thematique_bloc.dart';
import 'package:agora/bloc/thematique/thematique_state.dart';
import 'package:agora/bloc/thematique/thematique_with_id_view_model.dart';
import 'package:agora/design/custom_view/agora_error_view.dart';
import 'package:agora/design/custom_view/agora_thematique_toggle_button.dart';
import 'package:agora/design/style/agora_colors.dart';
import 'package:agora/design/style/agora_spacings.dart';
import 'package:agora/design/style/agora_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class QagsThematiqueSection extends StatelessWidget {
  final String? currentThematiqueId;
  final Function(String) onThematiqueIdSelected;

  const QagsThematiqueSection({
    super.key,
    required this.currentThematiqueId,
    required this.onThematiqueIdSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: AgoraSpacings.x1_25),
        Container(
          color: AgoraColors.doctor,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: AgoraSpacings.x1_25),
            child: BlocBuilder<ThematiqueBloc, ThematiqueState>(
              builder: (context, state) {
                if (state is ThematiqueSuccessState) {
                  return SingleChildScrollView(
                    physics: BouncingScrollPhysics(),
                    scrollDirection: Axis.horizontal,
                    child: _buildThematiques(state.thematiqueViewModels),
                  );
                } else if (state is ThematiqueInitialLoadingState) {
                  return Center(child: CircularProgressIndicator());
                } else {
                  return Center(child: AgoraErrorView());
                }
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildThematiques(List<ThematiqueWithIdViewModel> thematiques) {
    final Iterable<Widget> thematiqueWidgets = thematiques.map(
      (thematique) => Column(
        children: [
          AgoraToggleButton(
            isSelected: thematique.id == currentThematiqueId,
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
    );

    final List<Widget> spacingSizedBox = [SizedBox(width: AgoraSpacings.base)];
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: spacingSizedBox + thematiqueWidgets.toList() + spacingSizedBox,
    );
  }
}
