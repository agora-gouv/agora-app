import 'package:agora/bloc/thematique/thematique_action.dart';
import 'package:agora/bloc/thematique/thematique_bloc.dart';
import 'package:agora/common/agora_http_client.dart';
import 'package:agora/design/agora_colors.dart';
import 'package:agora/infrastructure/thematique/mocks_thematique_repository.dart';
import 'package:agora/pages/test_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AgoraApp extends StatelessWidget {
  final AgoraDioHttpClient agoraDioHttpClient;

  const AgoraApp({
    super.key,
    required this.agoraDioHttpClient,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Agora",
      theme: ThemeData(
        colorScheme: ColorScheme.light(
          primary: AgoraColors.primaryGreen,
          secondary: AgoraColors.primaryGreen,
        ),
      ),
      home: RepositoryProvider(
        create: (context) =>
            MockThematiqueSuccessRepository(), //ThematiqueDioRepository(httpClient: agoraDioHttpClient),
        child: BlocProvider(
          create: (context) => ThematiqueBloc(
            repository: context.read<MockThematiqueSuccessRepository>(),
          )..add(FetchThematiqueEvent()),
          child: TestPage(),
        ),
      ),
    );
  }
}
