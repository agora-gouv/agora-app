import 'dart:math';

import 'package:agora/bloc/thematique/thematique_view_model.dart';
import 'package:agora/common/helper/thematique_helper.dart';
import 'package:agora/design/custom_view/agora_rounded_card.dart';
import 'package:agora/design/style/agora_colors.dart';
import 'package:agora/design/style/agora_spacings.dart';
import 'package:agora/design/style/agora_text_styles.dart';
import 'package:flutter/material.dart';

enum AgoraConsultationFinishedStyle { carrousel, column, grid }

class AgoraConsultationFinishedCard extends StatelessWidget {
  final String id;
  final String title;
  final String imageUrl;
  final ThematiqueViewModel thematique;
  final String? label;
  final AgoraConsultationFinishedStyle style;
  final VoidCallback onClick;
  final int index;
  final int maxIndex;

  AgoraConsultationFinishedCard({
    required this.id,
    required this.title,
    required this.imageUrl,
    required this.thematique,
    required this.label,
    required this.style,
    required this.onClick,
    required this.index,
    required this.maxIndex,
  });

  @override
  Widget build(BuildContext context) {
    double carrouselWidth;
    switch (style) {
      case AgoraConsultationFinishedStyle.carrousel:
        carrouselWidth = max(MediaQuery.of(context).size.width * 0.5, AgoraSpacings.carrouselMinWidth);
        break;
      case AgoraConsultationFinishedStyle.column:
        carrouselWidth = MediaQuery.of(context).size.width;
        break;
      case AgoraConsultationFinishedStyle.grid:
        carrouselWidth = MediaQuery.of(context).size.width * 0.5;
        break;
    }

    Widget currentChild = _buildFinishedConsultationCard(context, carrouselWidth, true);
    if (style == AgoraConsultationFinishedStyle.carrousel) {
      currentChild = SizedBox(width: carrouselWidth, child: currentChild);
    }
    return currentChild;
  }

  Widget _buildFinishedConsultationCard(
    BuildContext context,
    double carrouselWidth,
    bool isButton,
  ) {
    final image = _buildImage(context, carrouselWidth);
    return Semantics(
      tooltip: "Élément ${index + 1} sur $maxIndex",
      button: isButton,
      child: AgoraRoundedCard(
        borderColor: AgoraColors.border,
        cardColor: AgoraColors.white,
        padding: EdgeInsets.symmetric(vertical: 1, horizontal: 1),
        onTap: () => onClick(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            style == AgoraConsultationFinishedStyle.carrousel
                ? Column(children: [image, SizedBox(height: AgoraSpacings.x0_5)])
                : Padding(padding: const EdgeInsets.all(AgoraSpacings.base), child: image),
            _buildPadding(child: ThematiqueHelper.buildCard(context, thematique)),
            style == AgoraConsultationFinishedStyle.column
                ? _buildPadding(child: Text(title, style: AgoraTextStyles.medium18))
                : Expanded(child: _buildPadding(child: Text(title, style: AgoraTextStyles.medium18))),
            SizedBox(height: AgoraSpacings.x0_5),
            if (label != null)
              AgoraRoundedCard(
                cardColor: AgoraColors.consultationLabelRed,
                padding: EdgeInsets.symmetric(vertical: AgoraSpacings.x0_5, horizontal: AgoraSpacings.x0_5),
                roundedCorner: AgoraRoundedCorner.bottomRounded,
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    ExcludeSemantics(child: Text('🔥', style: AgoraTextStyles.regular16)),
                    SizedBox(width: AgoraSpacings.x0_25),
                    Expanded(child: Text(label!, style: AgoraTextStyles.regular12)),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildPadding({required Widget child}) {
    return Padding(
      padding: style == AgoraConsultationFinishedStyle.carrousel
          ? EdgeInsets.only(left: AgoraSpacings.x0_75, right: AgoraSpacings.x0_75, bottom: AgoraSpacings.x0_5)
          : EdgeInsets.only(left: AgoraSpacings.base, right: AgoraSpacings.base, bottom: AgoraSpacings.x0_5),
      child: child,
    );
  }

  Image _buildImage(BuildContext context, double carrouselWidth) {
    return Image.network(
      imageUrl,
      fit: BoxFit.fitWidth,
      width: carrouselWidth,
      height: carrouselWidth * 0.55,
      excludeFromSemantics: true,
      loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
        return Center(
          child: loadingProgress == null
              ? child
              : SizedBox(
                  width: carrouselWidth,
                  height: carrouselWidth * 0.55,
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
    );
  }
}
