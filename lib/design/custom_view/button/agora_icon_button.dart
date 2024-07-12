import 'package:agora/design/custom_view/card/agora_rounded_card.dart';
import 'package:agora/design/style/agora_colors.dart';
import 'package:agora/design/style/agora_corners.dart';
import 'package:agora/design/style/agora_spacings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AgoraIconButton extends StatelessWidget {
  final String icon;
  final VoidCallback onClick;
  final String semanticLabel;
  final bool round;
  final double? iconSize;
  final Color? iconColor;
  final Color? borderColor;
  final Color? backgroundColor;
  final double padding;
  final Color focusColor;

  AgoraIconButton({
    required this.icon,
    required this.onClick,
    required this.semanticLabel,
    this.round = false,
    this.iconSize,
    this.iconColor,
    this.borderColor,
    this.backgroundColor,
    this.padding = AgoraSpacings.x0_75,
    this.focusColor = AgoraColors.neutral200,
  });

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: semanticLabel,
      child: AgoraRoundedCard(
        padding: EdgeInsets.symmetric(vertical: padding, horizontal: padding),
        focusColor: focusColor,
        borderColor: borderColor ?? AgoraColors.steam,
        cardColor: backgroundColor ?? AgoraColors.transparent,
        borderWidth: 1,
        cornerRadius: round ? AgoraCorners.round : AgoraCorners.rounded,
        onTap: onClick,
        child: SizedBox(
          width: iconSize,
          height: iconSize,
          child: SvgPicture.asset(
            "assets/$icon",
            excludeFromSemantics: true,
            width: iconSize,
            height: iconSize,
            colorFilter: iconColor == null ? null : ColorFilter.mode(iconColor!, BlendMode.srcIn),
          ),
        ),
      ),
    );
  }
}
