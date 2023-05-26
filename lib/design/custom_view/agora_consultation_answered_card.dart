import 'package:agora/bloc/thematique/thematique_view_model.dart';
import 'package:agora/common/analytics/analytics_event_names.dart';
import 'package:agora/common/analytics/analytics_screen_names.dart';
import 'package:agora/common/helper/thematique_helper.dart';
import 'package:agora/common/helper/tracker_helper.dart';
import 'package:agora/common/strings/consultation_strings.dart';
import 'package:agora/design/custom_view/agora_rounded_card.dart';
import 'package:agora/design/custom_view/agora_rounded_image.dart';
import 'package:agora/design/custom_view/agora_step_circle.dart';
import 'package:agora/design/style/agora_colors.dart';
import 'package:agora/design/style/agora_spacings.dart';
import 'package:agora/design/style/agora_text_styles.dart';
import 'package:agora/pages/consultation/details/consultation_details_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AgoraConsultationAnsweredCard extends StatelessWidget {
  final String id;
  final String title;
  final String imageUrl;
  final ThematiqueViewModel thematique;
  final int step;

  AgoraConsultationAnsweredCard({
    required this.id,
    required this.title,
    required this.imageUrl,
    required this.thematique,
    required this.step,
  });

  @override
  Widget build(BuildContext context) {
    return _buildFinishedConsultationCard(context);
  }

  Widget _buildFinishedConsultationCard(BuildContext context) {
    return AgoraRoundedCard(
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
          ConsultationDetailsPage.routeName,
          arguments: ConsultationDetailsArguments(consultationId: id),
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
          AgoraRoundedCard(
            cardColor: AgoraColors.doctor,
            padding: EdgeInsets.symmetric(vertical: AgoraSpacings.x0_5, horizontal: AgoraSpacings.x0_75),
            roundedCorner: AgoraRoundedCorner.bottomRounded,
            child: Row(
              children: [
                SvgPicture.asset(_getIcon()),
                SizedBox(width: AgoraSpacings.x0_25),
                Expanded(child: Text(_getStepString(), style: AgoraTextStyles.regular12)),
                SizedBox(width: AgoraSpacings.x0_25),
                AgoraStepCircle(currentStep: step),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _getIcon() {
    switch (step) {
      case 1:
        return "assets/ic_consultation_step1_ongoing.svg";
      case 2:
        return "assets/ic_consultation_step2_finished.svg";
      case 3:
        return "assets/ic_consultation_step3_answered.svg";
      default:
        return "";
    }
  }

  String _getStepString() {
    switch (step) {
      case 1:
        return ConsultationStrings.inProgress;
      case 2:
        return ConsultationStrings.engagement;
      case 3:
        return ConsultationStrings.implementation;
      default:
        return "";
    }
  }
}
