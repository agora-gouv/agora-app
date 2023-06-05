import 'package:agora/bloc/consultation/consultation_view_model.dart';
import 'package:agora/common/strings/consultation_strings.dart';
import 'package:agora/design/custom_view/agora_consultation_ongoing_card.dart';
import 'package:agora/design/custom_view/agora_rich_text.dart';
import 'package:agora/design/style/agora_spacings.dart';
import 'package:agora/design/style/agora_text_styles.dart';
import 'package:flutter/material.dart';

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
      ongoingConsultationsWidgets.add(
        Center(child: Text(ConsultationStrings.consultationEmpty, style: AgoraTextStyles.light14)),
      );
      ongoingConsultationsWidgets.add(SizedBox(height: AgoraSpacings.base));
    }
    for (final ongoingViewModel in ongoingViewModels) {
      ongoingConsultationsWidgets.add(
        AgoraConsultationOngoingCard(
          consultationId: ongoingViewModel.id,
          imageUrl: ongoingViewModel.coverUrl,
          thematique: ongoingViewModel.thematique,
          title: ongoingViewModel.title,
          endDate: ongoingViewModel.endDate,
          hasAnswered: ongoingViewModel.hasAnswered,
        ),
      );
      ongoingConsultationsWidgets.add(SizedBox(height: AgoraSpacings.base));
    }
    return ongoingConsultationsWidgets;
  }
}
