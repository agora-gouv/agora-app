import 'package:agora/bloc/thematique/thematique_action.dart';
import 'package:agora/bloc/thematique/thematique_bloc.dart';
import 'package:agora/bloc/thematique/thematique_state.dart';
import 'package:agora/common/client/repository_manager.dart';
import 'package:agora/design/custom_view/agora_error_view.dart';
import 'package:agora/design/custom_view/agora_scaffold.dart';
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
        child: BlocConsumer<ThematiqueBloc, ThematiqueState>(
          listener: (context, state) {
            if (state is ThematiqueSuccessState) {
              Navigator.pushNamed(
                context,
                ConsultationDetailsPage.routeName,
                arguments: BlocProvider.of<ThematiqueBloc>(context),
              );
            }
          },
          builder: (context, state) {
            if (state is ThematiqueInitialState) {
              return Center(child: CircularProgressIndicator());
            } else if (state is ThematiqueErrorState) {
              return Center(child: AgoraErrorView());
            } else {
              return Container();
            }
          },
        ),
      ),
    );
  }
}
