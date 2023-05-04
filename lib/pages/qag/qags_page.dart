import 'package:agora/bloc/qag/qag_bloc.dart';
import 'package:agora/bloc/qag/qag_event.dart';
import 'package:agora/bloc/qag/qag_state.dart';
import 'package:agora/bloc/thematique/thematique_bloc.dart';
import 'package:agora/bloc/thematique/thematique_event.dart';
import 'package:agora/common/manager/helper_manager.dart';
import 'package:agora/common/manager/repository_manager.dart';
import 'package:agora/common/strings/qag_strings.dart';
import 'package:agora/design/custom_view/agora_error_view.dart';
import 'package:agora/design/custom_view/agora_main_toolbar.dart';
import 'package:agora/design/custom_view/agora_scaffold.dart';
import 'package:agora/design/style/agora_colors.dart';
import 'package:agora/design/style/agora_spacings.dart';
import 'package:agora/design/style/agora_text_styles.dart';
import 'package:agora/pages/qag/qags_ask_question_section.dart';
import 'package:agora/pages/qag/qags_response_section.dart';
import 'package:agora/pages/qag/qags_section.dart';
import 'package:agora/pages/qag/qags_thematique_section.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class QagsPage extends StatelessWidget {
  static const routeName = "/qagsPage";

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (BuildContext context) {
            return QagBloc(
              qagRepository: RepositoryManager.getQagRepository(),
              deviceInfoHelper: HelperManager.getDeviceInfoHelper(),
            )..add(FetchQagsEvent());
          },
        ),
        BlocProvider(
          create: (context) => ThematiqueBloc(
            repository: RepositoryManager.getThematiqueRepository(),
          )..add(FetchThematiqueEvent()),
        ),
      ],
      child: AgoraScaffold(
        backgroundColor: AgoraColors.background,
        child: BlocBuilder<QagBloc, QagState>(
          builder: (context, state) {
            return SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  AgoraMainToolbar(
                    title: RichText(
                      text: TextSpan(
                        style: AgoraTextStyles.light24.copyWith(height: 1.2),
                        children: [
                          TextSpan(
                            text: "${QagStrings.toolbarPart1}\n",
                            style: AgoraTextStyles.bold24.copyWith(height: 1.2),
                          ),
                          TextSpan(text: QagStrings.toolbarPart2),
                        ],
                      ),
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: _handleQagState(context, state),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  List<Widget> _handleQagState(BuildContext context, QagState state) {
    if (state is QagFetchedState) {
      return [
        QagsResponseSection(qagResponseViewModels: state.qagResponseViewModels),
        QagsAskQuestionSectionPage(),
        QagsThematiqueSection(),
        QagsSection(
          defaultSelected: QagTab.popular,
          popularViewModels: state.popularViewModels,
          latestViewModels: state.latestViewModels,
          supportingViewModels: state.supportingViewModels,
        ),
      ];
    } else if (state is QagInitialLoadingState) {
      return [
        SizedBox(height: AgoraSpacings.base),
        Center(child: CircularProgressIndicator()),
        SizedBox(height: AgoraSpacings.x2),
      ];
    } else if (state is QagErrorState) {
      return [
        SizedBox(height: AgoraSpacings.base),
        Center(child: AgoraErrorView()),
        SizedBox(height: AgoraSpacings.x2),
      ];
    }
    return [];
  }
}
