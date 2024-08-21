import 'package:agora/thematique/bloc/thematique_bloc.dart';
import 'package:agora/thematique/bloc/thematique_event.dart';
import 'package:agora/thematique/bloc/thematique_state.dart';
import 'package:agora/common/helper/thematique_helper.dart';
import 'package:agora/design/custom_view/error/agora_error_view.dart';
import 'package:agora/design/style/agora_colors.dart';
import 'package:agora/design/style/agora_spacings.dart';
import 'package:agora/qag/widgets/qags_thematique_loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class QagsThematiqueSection extends StatelessWidget {
  final String? currentThematiqueId;
  final Function(String?, String?) onThematiqueIdSelected;

  const QagsThematiqueSection({
    super.key,
    required this.currentThematiqueId,
    required this.onThematiqueIdSelected,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThematiqueBloc, ThematiqueState>(
      builder: (context, state) {
        if (state is ThematiqueSuccessState) {
          return Scrollbar(
            child: SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              scrollDirection: Axis.horizontal,
              child: Container(
                color: AgoraColors.doctor,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: AgoraSpacings.x0_75),
                  child: ThematiqueHelper.buildThematiques(
                    thematiques: state.thematiqueViewModels,
                    selectedThematiqueId: currentThematiqueId,
                    onThematiqueIdSelected: onThematiqueIdSelected,
                  ),
                ),
              ),
            ),
          );
        } else if (state is ThematiqueInitialLoadingState) {
          return Center(child: QagsThematiqueLoading());
        } else {
          return Center(
            child: AgoraErrorView(
              onReload: () => context.read<ThematiqueBloc>().add(FetchFilterThematiqueEvent()),
            ),
          );
        }
      },
    );
  }
}
