import 'package:agora/bloc/thematique/thematique_view_model.dart';
import 'package:agora/common/helper/thematique_helper.dart';
import 'package:agora/common/strings/consultation_strings.dart';
import 'package:agora/design/custom_view/agora_rounded_card.dart';
import 'package:agora/design/custom_view/button/agora_button.dart';
import 'package:agora/design/custom_view/button/agora_icon_button.dart';
import 'package:agora/design/style/agora_button_style.dart';
import 'package:agora/design/style/agora_colors.dart';
import 'package:agora/design/style/agora_spacings.dart';
import 'package:agora/design/style/agora_text_styles.dart';
import 'package:flutter/material.dart';

class AgoraConsultationOngoingCard extends StatelessWidget {
  final String imageUrl;
  final ThematiqueViewModel thematique;
  final String title;
  final String endDate;
  final VoidCallback onParticipationClick;
  final VoidCallback onShareClick;

  AgoraConsultationOngoingCard({
    required this.imageUrl,
    required this.thematique,
    required this.title,
    required this.endDate,
    required this.onParticipationClick,
    required this.onShareClick,
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
          ThematiqueHelper.buildCard(context, thematique),
          SizedBox(height: AgoraSpacings.x0_25),
          Text(title, style: AgoraTextStyles.medium22),
          SizedBox(height: AgoraSpacings.x0_5),
          RichText(
            text: TextSpan(
              style: AgoraTextStyles.regular13.copyWith(color: AgoraColors.primaryGrey),
              children: [
                TextSpan(text: ConsultationStrings.endDateVariation),
                WidgetSpan(child: SizedBox(width: AgoraSpacings.x0_25)),
                TextSpan(
                  text: endDate,
                  style: AgoraTextStyles.regular13.copyWith(color: AgoraColors.primaryGreen),
                ),
              ],
            ),
          ),
          SizedBox(height: AgoraSpacings.x2),
          Row(
            children: [
              AgoraButton(
                label: ConsultationStrings.participate,
                style: AgoraButtonStyle.primaryButtonStyle,
                onPressed: () {
                  onParticipationClick();
                },
              ),
              Spacer(),
              AgoraIconButton(
                icon: "ic_share.svg",
                onClick: () {
                  onShareClick();
                },
              ),
            ],
          )
        ],
      ),
    );
  }
}
