import 'package:agora/bloc/consultation/consultation_view_model.dart';
import 'package:agora/common/strings/consultation_strings.dart';
import 'package:agora/common/strings/semantics_strings.dart';
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: _buildOngoingConsultations(context),
    );
  }

  List<Widget> _buildOngoingConsultations(BuildContext context) {
    final List<Widget> ongoingConsultationsWidgets = List.empty(growable: true);
    ongoingConsultationsWidgets.add(
      Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AgoraSpacings.horizontalPadding,
          vertical: AgoraSpacings.base,
        ),
        child: AgoraRichText(
          items: [
            AgoraRichTextTextItem(
              text: "${ConsultationStrings.ongoingConsultationPart1}\n",
              style: AgoraRichTextItemStyle.regular,
            ),
            AgoraRichTextTextItem(
              text: ConsultationStrings.ongoingConsultationPart2,
              style: AgoraRichTextItemStyle.bold,
            ),
          ],
        ),
      ),
    );

    if (ongoingViewModels.isEmpty) {
      ongoingConsultationsWidgets.add(Container(width: double.infinity));
      ongoingConsultationsWidgets.add(
        Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AgoraSpacings.horizontalPadding,
              vertical: AgoraSpacings.x0_75,
            ),
            child: Text(
              ConsultationStrings.ongoingConsultationEmpty,
              semanticsLabel: SemanticsStrings.ongoingConsultationEmpty,
              style: AgoraTextStyles.medium14,
              textAlign: TextAlign.center,
            ),
          ),
        ),
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
          highlightLabel: ongoingViewModel.highlightLabel,
        ),
      );
      ongoingConsultationsWidgets.add(SizedBox(height: AgoraSpacings.base));
    }
    return ongoingConsultationsWidgets;
  }
}
