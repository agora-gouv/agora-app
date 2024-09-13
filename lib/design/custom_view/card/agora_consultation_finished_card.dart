import 'dart:math';

import 'package:agora/common/helper/feature_flipping_helper.dart';
import 'package:agora/design/custom_view/agora_badge.dart';
import 'package:agora/design/custom_view/card/agora_rounded_card.dart';
import 'package:agora/design/custom_view/card/agora_thematique_card.dart';
import 'package:agora/design/style/agora_colors.dart';
import 'package:agora/design/style/agora_corners.dart';
import 'package:agora/design/style/agora_spacings.dart';
import 'package:agora/design/style/agora_text_styles.dart';
import 'package:agora/thematique/bloc/thematique_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

enum AgoraConsultationFinishedStyle { carrousel, column, grid }

class AgoraConsultationFinishedCard extends StatelessWidget {
  final String id;
  final String titre;
  final String imageUrl;
  final ThematiqueViewModel thematique;
  final String? flammeLabel;
  final AgoraConsultationFinishedStyle style;
  final bool isExternalLink;
  final int index;
  final int maxIndex;
  final bool fixedSize;
  final String badgeLabel;
  final Color badgeColor;
  final Color badgeTextColor;
  final void Function() onTap;

  AgoraConsultationFinishedCard({
    super.key,
    required this.id,
    required this.titre,
    required this.imageUrl,
    required this.thematique,
    required this.flammeLabel,
    required this.style,
    this.isExternalLink = false,
    required this.index,
    required this.maxIndex,
    this.fixedSize = true,
    required this.badgeLabel,
    required this.badgeColor,
    required this.badgeTextColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    double cardWidth;
    double cardHeight;
    switch (style) {
      case AgoraConsultationFinishedStyle.carrousel:
        cardWidth = max(MediaQuery.of(context).size.width * 0.5, AgoraSpacings.carrouselMinWidth);
        cardHeight = cardWidth * 0.55;
        break;
      case AgoraConsultationFinishedStyle.column:
        cardWidth = MediaQuery.of(context).size.width;
        cardHeight = cardWidth * 0.4;
        break;
      case AgoraConsultationFinishedStyle.grid:
        cardWidth = MediaQuery.of(context).size.width * 0.5;
        cardHeight = cardWidth * 0.55;
        break;
    }

    Widget currentChild = _buildFinishedConsultationCard(context, cardWidth, cardHeight, true);
    if (style == AgoraConsultationFinishedStyle.carrousel) {
      currentChild = SizedBox(width: cardWidth, child: currentChild);
    }
    return currentChild;
  }

  Widget _buildFinishedConsultationCard(
    BuildContext context,
    double cardWidth,
    double cardHeight,
    bool isButton,
  ) {
    final padding = style == AgoraConsultationFinishedStyle.carrousel
        ? EdgeInsets.only(left: AgoraSpacings.x0_75, right: AgoraSpacings.x0_75, bottom: AgoraSpacings.x0_5)
        : EdgeInsets.only(left: AgoraSpacings.base, right: AgoraSpacings.base, bottom: AgoraSpacings.x0_5);
    return Semantics(
      tooltip: "Élément $index sur $maxIndex",
      button: isButton,
      child: AgoraRoundedCard(
        borderColor: AgoraColors.border,
        cardColor: AgoraColors.white,
        padding: EdgeInsets.all(1),
        onTap: () => onTap(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: fixedSize ? MainAxisSize.max : MainAxisSize.min,
          children: [
            Padding(
              padding: style == AgoraConsultationFinishedStyle.carrousel
                  ? const EdgeInsets.only(bottom: AgoraSpacings.x0_5)
                  : const EdgeInsets.all(AgoraSpacings.base),
              child: _Image(
                imageUrl: imageUrl,
                cardWidth: cardWidth,
                cardHeight: cardHeight,
              ),
            ),
            if (isTerritorialisationEnabled())
              Padding(
                padding: padding,
                child: AgoraBadge(label: badgeLabel, backgroundColor: badgeColor, textColor: badgeTextColor),
              ),
            Padding(
              padding: padding,
              child: AgoraThematiqueLabel(
                picto: thematique.picto,
                label: thematique.label,
                size: AgoraThematiqueSize.medium,
              ),
            ),
            Padding(
              padding: padding,
              child: _Titre(title: titre, isExternalLink: isExternalLink),
            ),
            if (flammeLabel != null) ...[
              if (fixedSize) Spacer(),
              AgoraRoundedCard(
                cardColor: AgoraColors.consultationLabelRed,
                padding: EdgeInsets.symmetric(vertical: AgoraSpacings.x0_5, horizontal: AgoraSpacings.x0_5),
                roundedCorner: AgoraRoundedCorner.bottomRounded,
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    ExcludeSemantics(child: Text('🔥', style: AgoraTextStyles.regular16)),
                    SizedBox(width: AgoraSpacings.x0_25),
                    Expanded(child: Text(flammeLabel!, style: AgoraTextStyles.regular12)),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _Image extends StatelessWidget {
  final String imageUrl;
  final double cardWidth;
  final double cardHeight;

  const _Image({
    required this.imageUrl,
    required this.cardWidth,
    required this.cardHeight,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.only(
        topLeft: AgoraCorners.rounded,
        topRight: AgoraCorners.rounded,
      ),
      child: Image.network(
        imageUrl,
        fit: BoxFit.fitWidth,
        width: cardWidth,
        height: cardHeight,
        excludeFromSemantics: true,
        loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
          return Center(
            child: loadingProgress == null
                ? child
                : SizedBox(
                    width: cardWidth,
                    height: cardHeight,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Spacer(),
                        CircularProgressIndicator(
                          value: loadingProgress.expectedTotalBytes != null
                              ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!
                              : null,
                        ),
                        Spacer(),
                      ],
                    ),
                  ),
          );
        },
      ),
    );
  }
}

class _Titre extends StatelessWidget {
  final String title;
  final bool isExternalLink;

  const _Titre({required this.title, this.isExternalLink = false});

  @override
  Widget build(BuildContext context) {
    if (isExternalLink) {
      return Semantics(
        label: "Lien externe vers la consultation $title",
        child: RichText(
          textScaler: MediaQuery.textScalerOf(context),
          text: TextSpan(
            children: [
              TextSpan(text: title, style: AgoraTextStyles.medium18),
              WidgetSpan(
                child: Padding(
                  padding: const EdgeInsets.only(right: 2, left: 4),
                  child: SvgPicture.asset(
                    'assets/ic_external_link.svg',
                    excludeFromSemantics: true,
                    height: 20,
                    width: 20,
                    colorFilter: const ColorFilter.mode(AgoraColors.primaryGrey, BlendMode.srcIn),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    } else {
      return Text(title, style: AgoraTextStyles.medium18);
    }
  }
}
