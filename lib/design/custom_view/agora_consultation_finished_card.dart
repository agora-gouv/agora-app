import 'package:agora/bloc/thematique/thematique_view_model.dart';
import 'package:agora/common/helper/thematique_helper.dart';
import 'package:agora/common/strings/consultation_strings.dart';
import 'package:agora/design/custom_view/agora_rounded_card.dart';
import 'package:agora/design/style/agora_colors.dart';
import 'package:agora/design/style/agora_spacings.dart';
import 'package:agora/design/style/agora_text_styles.dart';
import 'package:agora/pages/consultation/details/consultation_details_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AgoraConsultationFinishedCard extends StatelessWidget {
  final String id;
  final String title;
  final String imageUrl;
  final ThematiqueViewModel thematique;
  final int step;

  AgoraConsultationFinishedCard({
    required this.id,
    required this.title,
    required this.imageUrl,
    required this.thematique,
    required this.step,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.5,
      child: step != 1
          ? _buildFinishedConsultationCard(context)
          : Stack(
              children: [
                _buildFinishedConsultationCard(context),
                AgoraRoundedCard(
                  cardColor: AgoraColors.primaryGreenOpacity90,
                  child: Container(),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AgoraSpacings.x0_75,
                    vertical: AgoraSpacings.x0_5,
                  ),
                  child: Text(
                    ConsultationStrings.shortly,
                    style: AgoraTextStyles.bold18.copyWith(color: AgoraColors.white),
                  ),
                ),
              ],
            ),
    );
  }

  Widget _buildFinishedConsultationCard(BuildContext context) {
    return AgoraRoundedCard(
      borderColor: AgoraColors.border,
      cardColor: AgoraColors.white,
      padding: EdgeInsets.symmetric(vertical: 1, horizontal: 1),
      onTap: () {
        Navigator.pushNamed(
          context,
          ConsultationDetailsPage.routeName,
          arguments: ConsultationDetailsArguments(consultationId: id),
        );
      },
      child: Column(
        children: [
          Image.network(imageUrl, height: 125),
          Padding(
            padding: EdgeInsets.symmetric(vertical: AgoraSpacings.x0_5, horizontal: AgoraSpacings.x0_75),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(width: double.infinity),
                ThematiqueHelper.buildCard(context, thematique),
                SizedBox(height: AgoraSpacings.x0_25),
                Text(title, style: AgoraTextStyles.medium18),
                SizedBox(height: AgoraSpacings.x0_25),
              ],
            ),
          ),
          SizedBox(height: AgoraSpacings.x0_25),
          Spacer(),
          AgoraRoundedCard(
            cardColor: AgoraColors.doctor,
            padding: EdgeInsets.symmetric(vertical: AgoraSpacings.x0_5, horizontal: AgoraSpacings.x0_75),
            roundedCorner: AgoraRoundedCorner.bottomRounded,
            child: Row(
              children: [
                SvgPicture.asset(_getIcon()),
                SizedBox(width: AgoraSpacings.x0_25),
                Expanded(
                  child: Text(
                    _getStepString(),
                    style: AgoraTextStyles.medium12.copyWith(color: AgoraColors.primaryGreen),
                  ),
                ),
                SizedBox(width: AgoraSpacings.x0_25),
                _buildStepCircle(),
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
        return "assets/ic_consultation_step2_finished.svg";
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
        return ConsultationStrings.coming;
      case 2:
        return ConsultationStrings.engagement;
      case 3:
        return ConsultationStrings.implementation;
      default:
        return "";
    }
  }

  Widget _buildStepCircle() {
    switch (step) {
      case 1:
        return Row(
          children: [
            _buildCircle(AgoraColors.primaryGreen),
            SizedBox(width: AgoraSpacings.x0_25),
            _buildCircle(AgoraColors.gravelFint),
            SizedBox(width: AgoraSpacings.x0_25),
            _buildCircle(AgoraColors.gravelFint),
          ],
        );
      case 2:
        return Row(
          children: [
            _buildCircle(AgoraColors.primaryGreen),
            SizedBox(width: AgoraSpacings.x0_25),
            _buildCircle(AgoraColors.primaryGreen),
            SizedBox(width: AgoraSpacings.x0_25),
            _buildCircle(AgoraColors.gravelFint),
          ],
        );
      case 3:
        return Row(
          children: [
            _buildCircle(AgoraColors.primaryGreen),
            SizedBox(width: AgoraSpacings.x0_25),
            _buildCircle(AgoraColors.primaryGreen),
            SizedBox(width: AgoraSpacings.x0_25),
            _buildCircle(AgoraColors.primaryGreen),
          ],
        );
      default:
        return Container();
    }
  }

  Widget _buildCircle(Color color) {
    return Container(
      width: 8.0,
      height: 8.0,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
    );
  }
}
