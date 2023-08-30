import 'package:agora/bloc/consultation/consultation_view_model.dart';
import 'package:agora/common/strings/consultation_strings.dart';
import 'package:agora/design/custom_view/agora_consultation_answered_card.dart';
import 'package:agora/design/custom_view/agora_rich_text.dart';
import 'package:agora/design/style/agora_spacings.dart';
import 'package:agora/design/style/agora_text_styles.dart';
import 'package:flutter/material.dart';

class ConsultationsAnsweredSection extends StatelessWidget {
  final List<ConsultationAnsweredViewModel> answeredViewModels;

  const ConsultationsAnsweredSection({super.key, required this.answeredViewModels});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        left: AgoraSpacings.horizontalPadding,
        right: AgoraSpacings.horizontalPadding,
        top: AgoraSpacings.x1_5,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: _buildAnsweredConsultations(context),
      ),
    );
  }

  List<Widget> _buildAnsweredConsultations(BuildContext context) {
    final List<Widget> answeredConsultationsWidgets = List.empty(growable: true);
    answeredConsultationsWidgets.add(
      AgoraRichText(
        items: [
          AgoraRichTextItem(
            text: ConsultationStrings.answeredConsultationPart1,
            style: AgoraRichTextItemStyle.regular,
          ),
          AgoraRichTextItem(
            text: ConsultationStrings.answeredConsultationPart2,
            style: AgoraRichTextItemStyle.bold,
          ),
        ],
      ),
    );
    answeredConsultationsWidgets.add(SizedBox(height: AgoraSpacings.base));

    if (answeredViewModels.isEmpty) {
      answeredConsultationsWidgets.add(Container(width: double.infinity));
      answeredConsultationsWidgets.add(SizedBox(height: AgoraSpacings.base));
      answeredConsultationsWidgets.add(
        Center(
          child: Text(
            ConsultationStrings.answeredConsultationEmptyList,
            style: AgoraTextStyles.medium14,
            textAlign: TextAlign.center,
          ),
        ),
      );
      answeredConsultationsWidgets.add(SizedBox(height: AgoraSpacings.x2));
    }
    for (final answeredViewModel in answeredViewModels) {
      answeredConsultationsWidgets.add(
        AgoraConsultationAnsweredCard(
          id: answeredViewModel.id,
          title: answeredViewModel.title,
          thematique: answeredViewModel.thematique,
          imageUrl: answeredViewModel.coverUrl,
          step: answeredViewModel.step,
        ),
      );
      answeredConsultationsWidgets.add(SizedBox(height: AgoraSpacings.base));
    }
    return answeredConsultationsWidgets;
  }
}
