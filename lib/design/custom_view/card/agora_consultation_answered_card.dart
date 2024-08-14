import 'package:agora/common/analytics/analytics_event_names.dart';
import 'package:agora/common/analytics/analytics_screen_names.dart';
import 'package:agora/common/helper/thematique_helper.dart';
import 'package:agora/common/helper/tracker_helper.dart';
import 'package:agora/consultation/dynamic/pages/dynamic_consultation_page.dart';
import 'package:agora/design/custom_view/agora_rounded_image.dart';
import 'package:agora/design/custom_view/card/agora_rounded_card.dart';
import 'package:agora/design/style/agora_colors.dart';
import 'package:agora/design/style/agora_spacings.dart';
import 'package:agora/design/style/agora_text_styles.dart';
import 'package:agora/thematique/bloc/thematique_view_model.dart';
import 'package:flutter/material.dart';

class AgoraConsultationAnsweredCard extends StatelessWidget {
  final String id;
  final String title;
  final String imageUrl;
  final ThematiqueViewModel thematique;
  final String? label;

  AgoraConsultationAnsweredCard({
    required this.id,
    required this.title,
    required this.imageUrl,
    required this.thematique,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      child: AgoraRoundedCard(
        borderColor: AgoraColors.border,
        cardColor: AgoraColors.white,
        padding: EdgeInsets.symmetric(vertical: 1, horizontal: 1),
        onTap: () {
          TrackerHelper.trackClick(
            clickName: "${AnalyticsEventNames.answeredConsultation} $id",
            widgetName: AnalyticsScreenNames.consultationsPage,
          );
          Navigator.pushNamed(
            context,
            DynamicConsultationPage.routeName,
            arguments: DynamicConsultationPageArguments(
              consultationIdOrSlug: id,
              consultationTitle: title,
              shouldReloadConsultationsWhenPop: false,
            ),
          );
        },
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(vertical: AgoraSpacings.x0_5, horizontal: AgoraSpacings.x0_75),
              child: Row(
                children: [
                  AgoraRoundedImage(imageUrl: imageUrl, size: 70),
                  SizedBox(width: AgoraSpacings.x0_75),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ThematiqueHelper.buildCard(context, thematique),
                        Text(title, style: AgoraTextStyles.regular16),
                        SizedBox(height: AgoraSpacings.x0_25),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: AgoraSpacings.x0_25),
            if (label != null)
              AgoraRoundedCard(
                cardColor: AgoraColors.consultationLabelRed,
                padding: EdgeInsets.symmetric(vertical: AgoraSpacings.x0_5, horizontal: AgoraSpacings.x0_75),
                roundedCorner: AgoraRoundedCorner.bottomRounded,
                child: Row(
                  children: [
                    ExcludeSemantics(child: Text('🔥', style: AgoraTextStyles.regular16)),
                    SizedBox(width: AgoraSpacings.x0_5),
                    Expanded(child: Text(label!, style: AgoraTextStyles.regular12)),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
