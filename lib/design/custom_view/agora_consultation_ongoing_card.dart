import 'package:agora/bloc/thematique/thematique_view_model.dart';
import 'package:agora/common/analytics/analytics_event_names.dart';
import 'package:agora/common/analytics/analytics_screen_names.dart';
import 'package:agora/common/extension/string_extension.dart';
import 'package:agora/common/helper/thematique_helper.dart';
import 'package:agora/common/helper/tracker_helper.dart';
import 'package:agora/common/strings/consultation_strings.dart';
import 'package:agora/design/custom_view/agora_rounded_card.dart';
import 'package:agora/design/custom_view/agora_thematique_card.dart';
import 'package:agora/design/custom_view/button/agora_button.dart';
import 'package:agora/design/custom_view/button/agora_icon_button.dart';
import 'package:agora/design/style/agora_button_style.dart';
import 'package:agora/design/style/agora_colors.dart';
import 'package:agora/design/style/agora_spacings.dart';
import 'package:agora/design/style/agora_text_styles.dart';
import 'package:agora/pages/consultation/details/consultation_details_page.dart';
import 'package:agora/pages/consultation/summary/consultation_summary_page.dart';
import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';

class AgoraConsultationOngoingCard extends StatelessWidget {
  final String consultationId;
  final String imageUrl;
  final ThematiqueViewModel thematique;
  final String title;
  final String endDate;
  final bool hasAnswered;

  AgoraConsultationOngoingCard({
    required this.consultationId,
    required this.imageUrl,
    required this.thematique,
    required this.title,
    required this.endDate,
    required this.hasAnswered,
  });

  @override
  Widget build(BuildContext context) {
    return AgoraRoundedCard(
      borderColor: AgoraColors.border,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.network(imageUrl, height: 200),
          SizedBox(height: AgoraSpacings.base),
          ThematiqueHelper.buildCard(context, thematique, size: AgoraThematiqueSize.large),
          SizedBox(height: AgoraSpacings.x0_25),
          Text(title, style: AgoraTextStyles.medium22),
          SizedBox(height: AgoraSpacings.x0_5),
          Text(
            ConsultationStrings.endDate.format(endDate),
            style: AgoraTextStyles.medium12.copyWith(color: AgoraColors.rhineCastle),
          ),
          SizedBox(height: AgoraSpacings.x1_25),
          Row(
            children: [
              AgoraButton(
                label: hasAnswered ? ConsultationStrings.seeResults : ConsultationStrings.participate,
                icon: "ic_bubble.svg",
                style: AgoraButtonStyle.blueBorderButtonStyle,
                onPressed: () {
                  TrackerHelper.trackClick(
                    clickName: "${AnalyticsEventNames.participateConsultation} $consultationId",
                    widgetName: AnalyticsScreenNames.consultationsPage,
                  );
                  if (hasAnswered) {
                    Navigator.pushNamed(
                      context,
                      ConsultationSummaryPage.routeName,
                      arguments: ConsultationSummaryArguments(
                        consultationId: consultationId,
                        shouldReloadConsultationsWhenPop: false,
                      ),
                    );
                  } else {
                    Navigator.pushNamed(
                      context,
                      ConsultationDetailsPage.routeName,
                      arguments: ConsultationDetailsArguments(consultationId: consultationId),
                    );
                  }
                },
              ),
              Spacer(),
              AgoraIconButton(
                icon: "ic_share.svg",
                onClick: () {
                  TrackerHelper.trackClick(
                    clickName: "${AnalyticsEventNames.shareConsultation} $consultationId",
                    widgetName: AnalyticsScreenNames.consultationsPage,
                  );
                  Share.share(
                    'Consultation : $title\nagora://consultation.gouv.fr/$consultationId',
                  );
                },
              ),
            ],
          )
        ],
      ),
    );
  }
}
