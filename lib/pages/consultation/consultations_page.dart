import 'package:agora/bloc/consultation/consultation_bloc.dart';
import 'package:agora/bloc/consultation/consultation_event.dart';
import 'package:agora/bloc/consultation/consultation_state.dart';
import 'package:agora/bloc/consultation/consultation_view_model.dart';
import 'package:agora/common/manager/helper_manager.dart';
import 'package:agora/common/manager/repository_manager.dart';
import 'package:agora/design/agora_colors.dart';
import 'package:agora/design/agora_spacings.dart';
import 'package:agora/design/custom_view/agora_consultation_card.dart';
import 'package:agora/design/custom_view/agora_error_view.dart';
import 'package:agora/design/custom_view/agora_scaffold.dart';
import 'package:agora/design/custom_view/agora_top_diagonal.dart';
import 'package:agora/pages/consultation/consultation_details_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:share_plus/share_plus.dart';

class ConsultationsPage extends StatelessWidget {
  static const routeName = "/consultationsPage";

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) {
        return ConsultationBloc(
          consultationRepository: RepositoryManager.getConsultationRepository(),
          deviceInfoHelper: HelperManager.getDeviceInfoHelper(),
        )..add(FetchConsultationsEvent());
      },
      child: AgoraScaffold(
        backgroundColor: AgoraColors.background,
        child: BlocBuilder<ConsultationBloc, ConsultationState>(
          builder: (context, state) {
            return SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  AgoraTopDiagonal(),
                  Padding(
                    padding: EdgeInsets.only(
                      left: AgoraSpacings.base,
                      top: AgoraSpacings.base,
                      right: AgoraSpacings.base,
                    ),
                    child: Column(children: _handleConsultationsState(context, state)),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  List<Widget> _handleConsultationsState(BuildContext context, ConsultationState state) {
    if (state is ConsultationsFetchedState) {
      return _buildConsultations(context, state.viewModels);
    } else if (state is ConsultationInitialLoadingState) {
      return [
        SizedBox(height: AgoraSpacings.base),
        Center(child: CircularProgressIndicator()),
        SizedBox(height: AgoraSpacings.x2),
      ];
    } else if (state is ConsultationEmptyState) {
      return [
        SizedBox(height: AgoraSpacings.base),
        Center(child: Text("Vous n'avez pas encore de consultations.")),
        SizedBox(height: AgoraSpacings.x2),
      ];
    } else if (state is ConsultationEmptyState) {
      return [
        SizedBox(height: AgoraSpacings.base),
        Center(child: AgoraErrorView()),
        SizedBox(height: AgoraSpacings.x2),
      ];
    }
    return [];
  }

  List<Widget> _buildConsultations(BuildContext context, List<ConsultationViewModel> consultations) {
    final List<Widget> consultationsWidget = List.empty(growable: true);
    for (var consultation in consultations) {
      if (consultation is ConsultationOngoingViewModel) {
        consultationsWidget.add(
          AgoraConsultationCard(
            imageUrl: consultation.coverUrl,
            thematique: consultation.thematique,
            title: consultation.title,
            endDate: consultation.endDate,
            onParticipationClick: () {
              Navigator.pushNamed(
                context,
                ConsultationDetailsPage.routeName,
                arguments: ConsultationDetailsArguments(consultationId: consultation.id),
              );
            },
            onShareClick: () {
              Share.share('Consultation : ${consultation.title}\nagora://consultation.gouv.fr/${consultation.id}');
            },
          ),
        );
      } else {
        throw Exception("Consultation view model doesn't exists $consultation");
      }
      consultationsWidget.add(SizedBox(height: AgoraSpacings.base));
    }
    return consultationsWidget;
  }
}
