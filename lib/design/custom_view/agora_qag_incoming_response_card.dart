import 'dart:math';

import 'package:agora/bloc/thematique/thematique_view_model.dart';
import 'package:agora/common/helper/thematique_helper.dart';
import 'package:agora/common/strings/qag_strings.dart';
import 'package:agora/design/custom_view/agora_like_view.dart';
import 'package:agora/design/custom_view/agora_rounded_card.dart';
import 'package:agora/design/style/agora_colors.dart';
import 'package:agora/design/style/agora_corners.dart';
import 'package:agora/design/style/agora_spacings.dart';
import 'package:agora/design/style/agora_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AgoraQagIncomingResponseCard extends StatelessWidget {
  final String title;
  final ThematiqueViewModel thematique;
  final int supportCount;
  final bool isSupported;
  final VoidCallback onClick;

  AgoraQagIncomingResponseCard({
    required this.thematique,
    required this.title,
    required this.supportCount,
    required this.isSupported,
    required this.onClick,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: max(MediaQuery.of(context).size.width * 0.5, AgoraSpacings.carrouselMinWidth),
      child: AgoraRoundedCard(
        borderColor: AgoraColors.primaryBlue,
        cardColor: AgoraColors.white,
        padding: EdgeInsets.symmetric(vertical: 1, horizontal: 1),
        onTap: () => onClick(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(vertical: AgoraSpacings.x0_5, horizontal: AgoraSpacings.x0_75),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(width: double.infinity),
                  AgoraRoundedCard(
                    cardColor: AgoraColors.brilliantWhite,
                    cornerRadius: AgoraCorners.rounded12,
                    padding: const EdgeInsets.only(
                      top: AgoraSpacings.x0_25,
                      left: AgoraSpacings.x0_5,
                      right: AgoraSpacings.x0_5,
                      bottom: AgoraSpacings.x0_5,
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Flexible(child: Text(QagStrings.mostPopularQuestion, style: AgoraTextStyles.medium12)),
                      ],
                    ),
                  ),
                  SizedBox(height: AgoraSpacings.x0_25),
                  ThematiqueHelper.buildCard(context, thematique),
                  SizedBox(height: AgoraSpacings.x0_25),
                  Text(title, style: AgoraTextStyles.medium16),
                  SizedBox(height: AgoraSpacings.x0_25),
                ],
              ),
            ),
            SizedBox(height: AgoraSpacings.x0_25),
            Spacer(),
            AgoraRoundedCard(
              cardColor: AgoraColors.doctor,
              padding: EdgeInsets.symmetric(
                vertical: AgoraSpacings.base - 1,
                horizontal: AgoraSpacings.x0_75,
              ),
              roundedCorner: AgoraRoundedCorner.bottomRounded,
              child: Row(
                children: [
                  SvgPicture.asset("assets/ic_consultation_step2_finished.svg"),
                  SizedBox(width: AgoraSpacings.x0_25),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: AgoraSpacings.x0_25),
                      child: Text(
                        QagStrings.incomingResponse,
                        style: AgoraTextStyles.regular12.copyWith(color: AgoraColors.blue525),
                      ),
                    ),
                  ),
                  SizedBox(width: AgoraSpacings.x0_25),
                  AgoraLikeView(
                    isSupported: isSupported,
                    supportCount: supportCount,
                    style: AgoraLikeStyle.police12,
                    shouldHaveHorizontalPadding: false,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
