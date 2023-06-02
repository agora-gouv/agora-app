import 'package:agora/bloc/consultation/consultation_view_model.dart';
import 'package:agora/common/analytics/analytics_event_names.dart';
import 'package:agora/common/analytics/analytics_screen_names.dart';
import 'package:agora/common/helper/tracker_helper.dart';
import 'package:agora/common/strings/consultation_strings.dart';
import 'package:agora/design/custom_view/agora_consultation_ongoing_card.dart';
import 'package:agora/design/custom_view/agora_rich_text.dart';
import 'package:agora/design/style/agora_spacings.dart';
import 'package:agora/pages/consultation/details/consultation_details_page.dart';
import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';

class ConsultationsOngoingSection extends StatelessWidget {
  final List<ConsultationOngoingViewModel> ongoingViewModels;

  const ConsultationsOngoingSection({super.key, required this.ongoingViewModels});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: AgoraSpacings.horizontalPadding,
        top: AgoraSpacings.base,
        right: AgoraSpacings.horizontalPadding,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: _buildOngoingConsultations(context),
      ),
    );
  }

  List<Widget> _buildOngoingConsultations(BuildContext context) {
    final List<Widget> ongoingConsultationsWidgets = List.empty(growable: true);
    ongoingConsultationsWidgets.add(
      AgoraRichText(
        items: [
          AgoraRichTextTextItem(
            text: "${ConsultationStrings.ongoingConsultationPart1}\n",
            style: AgoraRichTextItemStyle.regular,
          ),
          AgoraRichTextTextItem(text: ConsultationStrings.ongoingConsultationPart2, style: AgoraRichTextItemStyle.bold),
        ],
      ),
    );
    ongoingConsultationsWidgets.add(SizedBox(height: AgoraSpacings.base));

    if (ongoingViewModels.isEmpty) {
      ongoingConsultationsWidgets.add(Container(width: double.infinity));
      ongoingConsultationsWidgets.add(Center(child: Text(ConsultationStrings.consultationEmpty)));
      ongoingConsultationsWidgets.add(SizedBox(height: AgoraSpacings.base));
    }
    for (final ongoingViewModel in ongoingViewModels) {
      ongoingConsultationsWidgets.add(
        AgoraConsultationOngoingCard(
          imageUrl: ongoingViewModel.coverUrl,
          thematique: ongoingViewModel.thematique,
          title: ongoingViewModel.title,
          endDate: ongoingViewModel.endDate,
          onParticipationClick: () {
            TrackerHelper.trackClick(
              clickName: "${AnalyticsEventNames.participateConsultation} ${ongoingViewModel.id}",
              widgetName: AnalyticsScreenNames.consultationsPage,
            );
            Navigator.pushNamed(
              context,
              ConsultationDetailsPage.routeName,
              arguments: ConsultationDetailsArguments(consultationId: ongoingViewModel.id),
            );
          },
          onShareClick: () {
            TrackerHelper.trackClick(
              clickName: "${AnalyticsEventNames.shareConsultation} ${ongoingViewModel.id}",
              widgetName: AnalyticsScreenNames.consultationsPage,
            );
            Share.share(
              'Consultation : ${ongoingViewModel.title}\nagora://consultation.gouv.fr/${ongoingViewModel.id}',
            );
          },
        ),
      );
      ongoingConsultationsWidgets.add(SizedBox(height: AgoraSpacings.base));
    }
    return ongoingConsultationsWidgets;
  }
}
