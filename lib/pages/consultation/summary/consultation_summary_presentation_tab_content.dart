import 'package:agora/design/custom_view/agora_html.dart';
import 'package:agora/design/custom_view/agora_rounded_card.dart';
import 'package:agora/design/style/agora_colors.dart';
import 'package:agora/design/style/agora_spacings.dart';
import 'package:agora/design/style/agora_text_styles.dart';
import 'package:flutter/material.dart';

class ConsultationSummaryPresentationTabContent extends StatelessWidget {
  final String rangeDate;
  final String description;
  final String tipDescription;

  const ConsultationSummaryPresentationTabContent({
    super.key,
    required this.rangeDate,
    required this.description,
    required this.tipDescription,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: BouncingScrollPhysics(),
      child: ConstrainedBox(
        constraints: BoxConstraints(minHeight: MediaQuery.of(context).size.height),
        child: Container(
          color: AgoraColors.background,
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AgoraSpacings.horizontalPadding,
              vertical: AgoraSpacings.x1_5,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  rangeDate,
                  style: AgoraTextStyles.light14,
                ),
                AgoraHtml(data: description),
                SizedBox(height: AgoraSpacings.base),
                AgoraRoundedCard(
                  cardColor: AgoraColors.white,
                  padding: const EdgeInsets.all(AgoraSpacings.base),
                  child: AgoraHtml(data: tipDescription),
                ),
                SizedBox(height: AgoraSpacings.base),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
