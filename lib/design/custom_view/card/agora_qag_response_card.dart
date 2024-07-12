import 'dart:math';

import 'package:agora/thematique/bloc/thematique_view_model.dart';
import 'package:agora/common/helper/thematique_helper.dart';
import 'package:agora/design/custom_view/card/agora_rounded_card.dart';
import 'package:agora/design/custom_view/agora_rounded_image.dart';
import 'package:agora/design/style/agora_colors.dart';
import 'package:agora/design/style/agora_spacings.dart';
import 'package:agora/design/style/agora_text_styles.dart';
import 'package:flutter/material.dart';

enum AgoraQagResponseStyle { small, large }

class AgoraQagResponseCard extends StatelessWidget {
  final ThematiqueViewModel thematique;
  final String titre;
  final String auteurImageUrl;
  final String auteur;
  final String date;
  final AgoraQagResponseStyle style;
  final void Function() onClick;
  final int index;
  final int maxIndex;

  AgoraQagResponseCard({
    required this.thematique,
    required this.titre,
    required this.auteurImageUrl,
    required this.auteur,
    required this.date,
    required this.style,
    required this.onClick,
    required this.index,
    required this.maxIndex,
  });

  @override
  Widget build(BuildContext context) {
    Widget currentChild = Semantics(
      tooltip: "Élément ${index + 1} sur $maxIndex",
      button: true,
      child: AgoraRoundedCard(
        borderColor: AgoraColors.border,
        cardColor: AgoraColors.white,
        padding: EdgeInsets.symmetric(vertical: 1, horizontal: 1),
        onTap: () => onClick(),
        child: Column(
          children: [
            Padding(
              padding: style == AgoraQagResponseStyle.small
                  ? EdgeInsets.only(
                      top: AgoraSpacings.x0_5,
                      bottom: AgoraSpacings.base,
                      left: AgoraSpacings.x0_75,
                      right: AgoraSpacings.x0_75,
                    )
                  : EdgeInsets.all(AgoraSpacings.base),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(width: double.infinity),
                  ThematiqueHelper.buildCard(context, thematique),
                  SizedBox(height: AgoraSpacings.x0_25),
                  Text(titre, style: AgoraTextStyles.regular16),
                ],
              ),
            ),
            if (style == AgoraQagResponseStyle.small) Spacer(),
            AgoraRoundedCard(
              cardColor: AgoraColors.doctor,
              padding: EdgeInsets.symmetric(vertical: AgoraSpacings.x0_5, horizontal: AgoraSpacings.x0_75),
              roundedCorner: AgoraRoundedCorner.bottomRounded,
              child: Row(
                children: [
                  AgoraRoundedImage(imageUrl: auteurImageUrl, size: 27),
                  SizedBox(width: AgoraSpacings.x0_5),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(auteur, style: AgoraTextStyles.medium12),
                        Text(date, style: AgoraTextStyles.medium12.copyWith(color: AgoraColors.blue525)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
    if (style == AgoraQagResponseStyle.small) {
      currentChild = SizedBox(
        width: max(MediaQuery.of(context).size.width * 0.65, AgoraSpacings.carrouselMinWidth),
        child: currentChild,
      );
    }
    return currentChild;
  }
}
