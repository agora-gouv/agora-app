import 'package:agora/bloc/thematique/thematique_bloc.dart';
import 'package:agora/bloc/thematique/thematique_event.dart';
import 'package:agora/bloc/thematique/thematique_state.dart';
import 'package:agora/bloc/thematique/thematique_view_model.dart';
import 'package:agora/common/client/repository_manager.dart';
import 'package:agora/design/agora_button.dart';
import 'package:agora/design/agora_button_style.dart';
import 'package:agora/design/agora_spacings.dart';
import 'package:agora/design/custom_view/agora_error_view.dart';
import 'package:agora/design/custom_view/agora_scaffold.dart';
import 'package:agora/design/custom_view/agora_thematique_card.dart';
import 'package:agora/pages/consultation/consultation_details_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoadingPage extends StatelessWidget {
  static const routeName = "/";

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ThematiqueBloc(
        repository: RepositoryManager.getThematiqueRepository(),
      )..add(FetchThematiqueEvent()),
      child: AgoraScaffold(
        child: BlocBuilder<ThematiqueBloc, ThematiqueState>(
          builder: (context, state) {
            if (state is ThematiqueInitialLoadingState) {
              return Center(child: CircularProgressIndicator());
            } else if (state is ThematiqueErrorState) {
              return Center(child: AgoraErrorView());
            } else if (state is ThematiqueSuccessState) {
              return SizedBox(
                width: MediaQuery.of(context).size.width,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: _buildThematiques(state.viewModel) +
                      [
                        SizedBox(height: AgoraSpacings.x2),
                        AgoraButton(
                          label: "Détails d'une consultation",
                          style: AgoraButtonStyle.primaryButtonStyle,
                          onPressed: () {
                            Navigator.pushNamed(
                              context,
                              ConsultationDetailsPage.routeName,
                              arguments: BlocProvider.of<ThematiqueBloc>(context),
                            );
                          },
                        ),
                        SizedBox(height: AgoraSpacings.x3),
                      ],
                ),
              );
            } else {
              return Container();
            }
          },
        ),
      ),
    );
  }

  List<Widget> _buildThematiques(List<ThematiqueViewModel> thematiqueViewModels) {
    final List<Widget> widgets = [];
    for (var thematiqueViewModel in thematiqueViewModels) {
      widgets.add(
        AgoraThematiqueCard(
          picto: thematiqueViewModel.picto,
          label: thematiqueViewModel.label,
          color: thematiqueViewModel.color,
        ),
      );
      widgets.add(SizedBox(height: AgoraSpacings.base));
    }
    return widgets;
  }
}
