import 'package:agora/bloc/consultation/consultation_view_model.dart';
import 'package:agora/common/strings/consultation_strings.dart';
import 'package:agora/design/custom_view/agora_consultation_ongoing_card.dart';
import 'package:agora/design/custom_view/agora_title_rich_text.dart';
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
        children: _buildOngoingConsultations(context, ongoingViewModels),
      ),
    );
  }

  List<Widget> _buildOngoingConsultations(
    BuildContext context,
    List<ConsultationOngoingViewModel> ongoingConsultations,
  ) {
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
