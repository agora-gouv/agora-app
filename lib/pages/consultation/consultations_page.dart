import 'package:agora/bloc/consultation/consultation_bloc.dart';
import 'package:agora/bloc/consultation/consultation_event.dart';
import 'package:agora/bloc/consultation/consultation_state.dart';
import 'package:agora/bloc/consultation/consultation_view_model.dart';
import 'package:agora/common/manager/helper_manager.dart';
import 'package:agora/common/manager/repository_manager.dart';
import 'package:agora/common/strings/consultation_strings.dart';
import 'package:agora/design/custom_view/agora_consultation_card.dart';
import 'package:agora/design/custom_view/agora_error_view.dart';
import 'package:agora/design/custom_view/agora_main_toolbar.dart';
import 'package:agora/design/custom_view/agora_scaffold.dart';
import 'package:agora/design/style/agora_colors.dart';
import 'package:agora/design/style/agora_spacings.dart';
import 'package:agora/design/style/agora_text_styles.dart';
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
                  AgoraMainToolbar(
                    title: RichText(
                      text: TextSpan(
                        style: AgoraTextStyles.light24.copyWith(height: 1.2),
                        children: [
                          TextSpan(text: "${ConsultationStrings.toolbarPart1}\n"),
                          TextSpan(
                            text: ConsultationStrings.toolbarPart2,
                            style: AgoraTextStyles.bold24.copyWith(height: 1.2),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                      left: AgoraSpacings.horizontalPadding,
                      top: AgoraSpacings.base,
                      right: AgoraSpacings.horizontalPadding,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: _handleConsultationsState(context, state),
                    ),
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
        Center(child: Text(ConsultationStrings.consultationEmpty)),
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

  List<Widget> _buildConsultations(BuildContext context, List<ConsultationViewModel> consultations) {
    final List<Widget> consultationsWidget = List.empty(growable: true);
    var firstTimeAddOngoingConsultation = true;
    for (var consultation in consultations) {
      if (consultation is ConsultationOngoingViewModel) {
        if (firstTimeAddOngoingConsultation) {
          consultationsWidget.add(
            RichText(
              text: TextSpan(
                style: AgoraTextStyles.light18.copyWith(height: 1.2),
                children: [
                  TextSpan(text: "${ConsultationStrings.ongoingConsultationPart1}\n"),
                  TextSpan(
                    text: ConsultationStrings.ongoingConsultationPart2,
                    style: AgoraTextStyles.bold18.copyWith(height: 1.2),
                  ),
                ],
              ),
            ),
          );
          consultationsWidget.add(SizedBox(height: AgoraSpacings.base));
          firstTimeAddOngoingConsultation = false;
        }
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
