import 'package:agora/bloc/thematique/thematique_bloc.dart';
import 'package:agora/bloc/thematique/thematique_state.dart';
import 'package:agora/common/helper/thematique_helper.dart';
import 'package:agora/design/custom_view/agora_error_view.dart';
import 'package:agora/design/style/agora_colors.dart';
import 'package:agora/design/style/agora_spacings.dart';
import 'package:agora/pages/qag/qags_thematique_loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class QagsThematiqueSection extends StatelessWidget {
  final String? currentThematiqueId;
  final Function(String?) onThematiqueIdSelected;

  const QagsThematiqueSection({
    super.key,
    required this.currentThematiqueId,
    required this.onThematiqueIdSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          color: AgoraColors.doctor,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: AgoraSpacings.x0_75),
            child: BlocBuilder<ThematiqueBloc, ThematiqueState>(
              builder: (context, state) {
                if (state is ThematiqueSuccessState) {
                  return SingleChildScrollView(
                    physics: BouncingScrollPhysics(),
                    scrollDirection: Axis.horizontal,
                    child: ThematiqueHelper.buildThematiques(
                      thematiques: state.thematiqueViewModels,
                      selectedThematiqueId: currentThematiqueId,
                      onThematiqueIdSelected: onThematiqueIdSelected,
                    ),
                  );
                } else if (state is ThematiqueInitialLoadingState) {
                  return Center(child: QagsThematiqueLoading());
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
}
