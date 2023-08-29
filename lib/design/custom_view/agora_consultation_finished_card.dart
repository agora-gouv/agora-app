import 'dart:math';

import 'package:agora/bloc/thematique/thematique_view_model.dart';
import 'package:agora/common/helper/thematique_helper.dart';
import 'package:agora/common/strings/consultation_strings.dart';
import 'package:agora/design/custom_view/agora_rounded_card.dart';
import 'package:agora/design/custom_view/agora_step_circle.dart';
import 'package:agora/design/style/agora_colors.dart';
import 'package:agora/design/style/agora_spacings.dart';
import 'package:agora/design/style/agora_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

enum AgoraConsultationFinishedStyle { small, large }

class AgoraConsultationFinishedCard extends StatelessWidget {
  final String id;
  final String title;
  final String imageUrl;
  final ThematiqueViewModel thematique;
  final int step;
  final AgoraConsultationFinishedStyle style;
  final VoidCallback onClick;

  AgoraConsultationFinishedCard({
    required this.id,
    required this.title,
    required this.imageUrl,
    required this.thematique,
    required this.step,
    required this.style,
    required this.onClick,
  });

  @override
  Widget build(BuildContext context) {
    double carrouselWidth;
    if (style == AgoraConsultationFinishedStyle.small) {
      carrouselWidth = max(MediaQuery.of(context).size.width * 0.5, AgoraSpacings.carrouselMinWidth);
    } else {
      carrouselWidth = MediaQuery.of(context).size.width;
    }

    Widget currentChild = step != 1
        ? _buildFinishedConsultationCard(context, carrouselWidth)
        : InkWell(
            onTap: () {
              // Do nothing
              // use InkWell to regroup all elements of stack for voice over of accessibility
            },
            excludeFromSemantics: true, // exclude from tap voice over
            child: Stack(
              children: [
                _buildFinishedConsultationCard(context, carrouselWidth),
                Positioned.fill(
                  child: AgoraRoundedCard(
                    cardColor: AgoraColors.whiteOpacity90,
                    child: Container(),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal:
                        style == AgoraConsultationFinishedStyle.small ? AgoraSpacings.x0_75 : AgoraSpacings.base,
                    vertical: style == AgoraConsultationFinishedStyle.small ? AgoraSpacings.x0_5 : AgoraSpacings.base,
                  ),
                  child: AgoraRoundedCard(
                    cardColor: AgoraColors.lightBrun,
                    padding: const EdgeInsets.only(
                      top: AgoraSpacings.x0_25,
                      left: AgoraSpacings.x0_5,
                      right: AgoraSpacings.x0_5,
                      bottom: AgoraSpacings.x0_25 - 2.5,
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SvgPicture.asset("assets/ic_timer_brun.svg", excludeFromSemantics: true),
                        SizedBox(width: AgoraSpacings.x0_25),
                        Flexible(
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 2.5),
                            child: Text(
                              ConsultationStrings.shortly,
                              style: AgoraTextStyles.medium12.copyWith(color: AgoraColors.brun),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
    if (style == AgoraConsultationFinishedStyle.small) {
      currentChild = SizedBox(width: carrouselWidth, child: currentChild);
    }
    return currentChild;
  }

  Widget _buildFinishedConsultationCard(BuildContext context, double carrouselWidth) {
    final image = _buildImage(context, carrouselWidth);
    return Semantics(
      button: true,
      child: AgoraRoundedCard(
        borderColor: AgoraColors.border,
        cardColor: AgoraColors.white,
        padding: EdgeInsets.symmetric(vertical: 1, horizontal: 1),
        onTap: step != 1 ? () => onClick() : null,
        child: Column(
          children: [
            style == AgoraConsultationFinishedStyle.small
                ? image
                : Padding(padding: const EdgeInsets.all(AgoraSpacings.base), child: image),
            Padding(
              padding: style == AgoraConsultationFinishedStyle.small
                  ? EdgeInsets.symmetric(vertical: AgoraSpacings.x0_5, horizontal: AgoraSpacings.x0_75)
                  : EdgeInsets.only(left: AgoraSpacings.base, right: AgoraSpacings.base, bottom: AgoraSpacings.base),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(width: double.infinity),
                  ThematiqueHelper.buildCard(context, thematique),
                  Text(title, style: AgoraTextStyles.medium18),
                ],
              ),
            ),
            if (style == AgoraConsultationFinishedStyle.small) Spacer(),
            AgoraRoundedCard(
              cardColor: AgoraColors.doctor,
              padding: EdgeInsets.symmetric(vertical: AgoraSpacings.x0_5, horizontal: AgoraSpacings.x0_75),
              roundedCorner: AgoraRoundedCorner.bottomRounded,
              child: Row(
                children: [
                  SvgPicture.asset(_getIcon(), excludeFromSemantics: true),
                  SizedBox(width: AgoraSpacings.x0_25),
                  Expanded(child: Text(_getStepString(), style: AgoraTextStyles.regular12)),
                  SizedBox(width: AgoraSpacings.x0_25),
                  AgoraStepCircle(currentStep: step),
                ],
              ),
            ),
          ],
        ),
      ),
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
}
