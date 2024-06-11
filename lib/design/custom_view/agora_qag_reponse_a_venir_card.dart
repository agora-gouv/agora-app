import 'dart:math';

import 'package:agora/bloc/thematique/thematique_view_model.dart';
import 'package:agora/common/helper/thematique_helper.dart';
import 'package:agora/common/strings/reponse_strings.dart';
import 'package:agora/design/custom_view/agora_like_view.dart';
import 'package:agora/design/custom_view/agora_rounded_card.dart';
import 'package:agora/design/style/agora_colors.dart';
import 'package:agora/design/style/agora_spacings.dart';
import 'package:agora/design/style/agora_text_styles.dart';
import 'package:flutter/material.dart';

class AgoraQagResponseAVenirCard extends StatelessWidget {
  final String title;
  final ThematiqueViewModel thematique;
  final int supportCount;
  final bool isSupported;
  final VoidCallback onClick;
  final int index;
  final int maxIndex;
  final String semaineGagnanteLabel;

  AgoraQagResponseAVenirCard({
    required this.thematique,
    required this.title,
    required this.supportCount,
    required this.isSupported,
    required this.onClick,
    required this.index,
    required this.maxIndex,
    required this.semaineGagnanteLabel,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: max(MediaQuery.of(context).size.width * 0.65, AgoraSpacings.carrouselMinWidth),
      child: Semantics(
        tooltip: "Élément $index sur $maxIndex",
        button: true,
        child: AgoraRoundedCard(
          borderColor: AgoraColors.primaryBlue,
          cardColor: AgoraColors.white,
          padding: EdgeInsets.symmetric(vertical: 1, horizontal: 1),
          onTap: () => onClick(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _CardContent(thematique: thematique, isSupported: isSupported, supportCount: supportCount, title: title),
              SizedBox(height: AgoraSpacings.x0_25),
              Spacer(),
              _BandeauCard(semaineGagnanteLabel),
            ],
          ),
        ),
      ),
    );
  }
}

class _CardContent extends StatelessWidget {
  const _CardContent({
    required this.thematique,
    required this.isSupported,
    required this.supportCount,
    required this.title,
  });

  final ThematiqueViewModel thematique;
  final bool isSupported;
  final int supportCount;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: AgoraSpacings.x0_5, horizontal: AgoraSpacings.x0_75),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(child: ThematiqueHelper.buildCard(context, thematique)),
              SizedBox(width: AgoraSpacings.x0_75),
              AgoraLikeView(
                isSupported: isSupported,
                supportCount: supportCount,
                style: AgoraLikeStyle.police12,
                shouldHaveHorizontalPadding: false,
              ),
            ],
          ),
          SizedBox(height: AgoraSpacings.x0_25),
          Text(title, style: AgoraTextStyles.regular16),
          SizedBox(height: AgoraSpacings.x0_25),
        ],
      ),
    );
  }
}

class _BandeauCard extends StatelessWidget {
  final String semaineGagnanteLabel;

  const _BandeauCard(this.semaineGagnanteLabel);

  @override
  Widget build(BuildContext context) {
    return AgoraRoundedCard(
      cardColor: AgoraColors.doctor,
      padding: EdgeInsets.symmetric(
        vertical: AgoraSpacings.x0_5,
        horizontal: AgoraSpacings.x0_75,
      ),
      roundedCorner: AgoraRoundedCorner.bottomRounded,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text('🏆', style: AgoraTextStyles.regular12.copyWith(fontSize: 20)),
          SizedBox(width: AgoraSpacings.x0_5),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  ReponseStrings.qagPopulaire,
                  style: AgoraTextStyles.regular12.copyWith(fontWeight: FontWeight.w800),
                ),
                Text(semaineGagnanteLabel, style: AgoraTextStyles.regular12),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
