import 'package:agora/bloc/consultation/consultation_bloc.dart';
import 'package:agora/bloc/consultation/consultation_event.dart';
import 'package:agora/bloc/consultation/consultation_state.dart';
import 'package:agora/bloc/consultation/consultation_view_model.dart';
import 'package:agora/common/manager/helper_manager.dart';
import 'package:agora/common/manager/repository_manager.dart';
import 'package:agora/common/strings/consultation_strings.dart';
import 'package:agora/design/custom_view/agora_consultation_ongoing_card.dart';
import 'package:agora/design/custom_view/agora_error_view.dart';
import 'package:agora/design/custom_view/agora_main_toolbar.dart';
import 'package:agora/design/custom_view/agora_scaffold.dart';
import 'package:agora/design/custom_view/agora_title_rich_text.dart';
import 'package:agora/design/style/agora_colors.dart';
import 'package:agora/design/style/agora_spacings.dart';
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
        child: BlocBuilder<ConsultationBloc, ConsultationState>(
          builder: (context, state) {
            return SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  AgoraMainToolbar(
                    title: AgoraRichText(
                      policeStyle: AgoraRichTextPoliceStyle.toolbar,
                      items: [
                        AgoraRichTextItem(
                          text: "${ConsultationStrings.toolbarPart1}\n",
                          style: AgoraRichTextItemStyle.regular,
                        ),
                        AgoraRichTextItem(text: ConsultationStrings.toolbarPart2, style: AgoraRichTextItemStyle.bold),
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: _handleConsultationsState(context, state),
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
      return [
        Padding(
          padding: EdgeInsets.only(
            left: AgoraSpacings.horizontalPadding,
            top: AgoraSpacings.base,
            right: AgoraSpacings.horizontalPadding,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: _buildConsultations(context, state.ongoingViewModels),
          ),
        ),
        Column(
          children: [
            SizedBox(height: AgoraSpacings.x1_25),
            Container(
              color: AgoraColors.whiteEdgar,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AgoraSpacings.base,
                  vertical: AgoraSpacings.x1_25,
                ),
                child: Container(),
              ),
            ),
          ],
        ),
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

  List<Widget> _buildConsultations(BuildContext context, List<ConsultationOngoingViewModel> ongoingConsultations) {
    final List<Widget> ongoingConsultationsWidgets = List.empty(growable: true);
    ongoingConsultationsWidgets.add(
      AgoraRichText(
        items: [
          AgoraRichTextItem(
            text: "${ConsultationStrings.ongoingConsultationPart1}\n",
            style: AgoraRichTextItemStyle.regular,
          ),
          AgoraRichTextItem(text: ConsultationStrings.ongoingConsultationPart2, style: AgoraRichTextItemStyle.bold),
        ],
      ),
    );
    ongoingConsultationsWidgets.add(SizedBox(height: AgoraSpacings.base));

    if (ongoingConsultations.isEmpty) {
      ongoingConsultationsWidgets.add(Text(ConsultationStrings.consultationEmpty));
      ongoingConsultationsWidgets.add(SizedBox(height: AgoraSpacings.base));
    }
    for (final ongoingConsultation in ongoingConsultations) {
      ongoingConsultationsWidgets.add(
        AgoraConsultationOngoingCard(
          imageUrl: ongoingConsultation.coverUrl,
          thematique: ongoingConsultation.thematique,
          title: ongoingConsultation.title,
          endDate: ongoingConsultation.endDate,
          onParticipationClick: () {
            Navigator.pushNamed(
              context,
              ConsultationDetailsPage.routeName,
              arguments: ConsultationDetailsArguments(consultationId: ongoingConsultation.id),
            );
          },
          onShareClick: () {
            Share.share(
              'Consultation : ${ongoingConsultation.title}\nagora://consultation.gouv.fr/${ongoingConsultation.id}',
            );
          },
        ),
      );
      ongoingConsultationsWidgets.add(SizedBox(height: AgoraSpacings.base));
    }
    return ongoingConsultationsWidgets;
  }
}
