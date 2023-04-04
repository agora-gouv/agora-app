import 'package:agora/bloc/thematique/thematique_action.dart';
import 'package:agora/bloc/thematique/thematique_bloc.dart';
import 'package:agora/bloc/thematique/thematique_state.dart';
import 'package:agora/common/singleton_manager.dart';
import 'package:agora/design/custom_view/agora_scaffold.dart';
import 'package:agora/pages/consultation/consultation_details_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoadingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ThematiqueBloc(
        repository: SingletonManager.getThematiqueRepository(),
      )..add(FetchThematiqueEvent()),
      child: AgoraScaffold(
        child: BlocConsumer<ThematiqueBloc, ThematiqueState>(
          listener: (context, state) {
            if (state is ThematiqueSuccessState) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => BlocProvider.value(
                    value: BlocProvider.of<ThematiqueBloc>(context),
                    child: ConsultationDetailsPage(),
                  ),
                ),
              );
            }
          },
          builder: (context, state) {
            if (state is ThematiqueInitialState) {
              return Center(child: CircularProgressIndicator());
            } else if (state is ThematiqueErrorState) {
              return Center(child: Text("An error occured"));
            } else {
              return Container();
            }
          },
        ),
      ),
    );
  }
}
