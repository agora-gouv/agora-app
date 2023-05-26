import 'package:agora/bloc/consultation/consultation_bloc.dart';
import 'package:agora/bloc/consultation/consultation_event.dart';
import 'package:agora/bloc/consultation/consultation_state.dart';
import 'package:agora/common/manager/repository_manager.dart';
import 'package:agora/common/strings/consultation_strings.dart';
import 'package:agora/design/custom_view/agora_error_view.dart';
import 'package:agora/design/custom_view/agora_main_toolbar.dart';
import 'package:agora/design/custom_view/agora_title_rich_text.dart';
import 'package:agora/design/style/agora_spacings.dart';
import 'package:agora/pages/consultation/consultations_answered_section.dart';
import 'package:agora/pages/consultation/consultations_finished_section.dart';
import 'package:agora/pages/consultation/consultations_ongoing_section.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ConsultationsPage extends StatelessWidget {
  static const routeName = "/consultationsPage";

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) {
        return ConsultationBloc(
          consultationRepository: RepositoryManager.getConsultationRepository(),
        )..add(FetchConsultationsEvent());
      },
      child: BlocBuilder<ConsultationBloc, ConsultationState>(
        builder: (context, state) {
          return SingleChildScrollView(
            child: Column(
              children: <Widget>[
                AgoraMainToolbar(
                  title: AgoraRichText(
                    policeStyle: AgoraRichTextPoliceStyle.toolbar,
                    items: [
                      AgoraRichTextTextItem(
                        text: "${ConsultationStrings.toolbarPart1}\n",
                        style: AgoraRichTextItemStyle.regular,
                      ),
                      AgoraRichTextTextItem(
                        text: ConsultationStrings.toolbarPart2,
                        style: AgoraRichTextItemStyle.bold,
                      ),
                    ],
                  ),
                ),
                Column(children: _handleConsultationsState(context, state)),
              ],
            ),
          );
        },
      ),
    );
  }

  List<Widget> _handleConsultationsState(BuildContext context, ConsultationState state) {
    if (state is ConsultationsFetchedState) {
      return [
        ConsultationsOngoingSection(ongoingViewModels: state.ongoingViewModels),
        ConsultationsFinishedSection(finishedViewModels: state.finishedViewModels),
        ConsultationsAnsweredSection(answeredViewModels: state.answeredViewModels),
      ];
    } else if (state is ConsultationInitialLoadingState) {
      return [
        SizedBox(height: AgoraSpacings.base),
        Center(child: CircularProgressIndicator()),
        SizedBox(height: AgoraSpacings.x2),
      ];
    } else if (state is ConsultationErrorState) {
      return [
        SizedBox(height: AgoraSpacings.base),
        Center(child: AgoraErrorView()),
        SizedBox(height: AgoraSpacings.x2),
      ];
    }
    return [];
  }
}
