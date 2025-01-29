import 'package:agora/common/analytics/analytics_event_names.dart';
import 'package:agora/common/analytics/analytics_screen_names.dart';
import 'package:agora/common/helper/feature_flipping_helper.dart';
import 'package:agora/common/helper/tracker_helper.dart';
import 'package:agora/consultation/dynamic/pages/dynamic_consultation_page.dart';
import 'package:agora/design/custom_view/agora_badge.dart';
import 'package:agora/design/custom_view/agora_rounded_image.dart';
import 'package:agora/design/custom_view/card/agora_rounded_card.dart';
import 'package:agora/design/custom_view/card/agora_thematique_card.dart';
import 'package:agora/design/style/agora_colors.dart';
import 'package:agora/design/style/agora_spacings.dart';
import 'package:agora/design/style/agora_text_styles.dart';
import 'package:agora/thematique/bloc/thematique_view_model.dart';
import 'package:flutter/material.dart';

class AgoraConsultationAnsweredCard extends StatelessWidget {
  final String id;
  final String titre;
  final String imageUrl;
  final ThematiqueViewModel thematique;
  final String? flammeLabel;
  final String badgeLabel;
  final Color badgeColor;
  final Color badgeTextColor;

  AgoraConsultationAnsweredCard({
    required this.id,
    required this.titre,
    required this.imageUrl,
    required this.thematique,
    required this.flammeLabel,
    required this.badgeLabel,
    required this.badgeColor,
    required this.badgeTextColor,
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
              consultationTitle: titre,
              shouldReloadConsultationsWhenPop: false,
            ),
          );
        },
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.all(AgoraSpacings.base),
              child: Row(
                children: [
                  AgoraRoundedImage(imageUrl: imageUrl, size: 70),
                  SizedBox(width: AgoraSpacings.base),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (isTerritorialisationEnabled() && badgeLabel.isNotEmpty) ...[
                          AgoraBadge(label: badgeLabel, backgroundColor: badgeColor, textColor: badgeTextColor),
                          SizedBox(height: AgoraSpacings.x0_25),
                        ],
                        AgoraThematiqueLabel(
                          picto: thematique.picto,
                          label: thematique.label,
                          size: AgoraThematiqueSize.medium,
                        ),
                        SizedBox(height: AgoraSpacings.x0_25),
                        Text(titre, style: AgoraTextStyles.regular16),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            if (flammeLabel != null)
              AgoraRoundedCard(
                cardColor: AgoraColors.consultationLabelRed,
                padding: EdgeInsets.symmetric(vertical: AgoraSpacings.x0_5, horizontal: AgoraSpacings.x0_75),
                roundedCorner: AgoraRoundedCorner.bottomRounded,
                child: Row(
                  children: [
                    ExcludeSemantics(child: Text('🔥', style: AgoraTextStyles.regular16)),
                    SizedBox(width: AgoraSpacings.x0_5),
                    Expanded(child: Text(flammeLabel!, style: AgoraTextStyles.regular12)),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
