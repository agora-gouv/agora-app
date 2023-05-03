import 'package:agora/design/agora_colors.dart';
import 'package:agora/design/agora_spacings.dart';
import 'package:agora/design/custom_view/agora_rounded_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AgoraIconButton extends StatelessWidget {
  final String icon;
  final VoidCallback onClick;

  AgoraIconButton({
    required this.icon,
    required this.onClick,
  });

  @override
  Widget build(BuildContext context) {
    return AgoraRoundedCard(
      padding: EdgeInsets.symmetric(vertical: AgoraSpacings.x0_75, horizontal: AgoraSpacings.x0_75),
      cardColor: AgoraColors.cascadingWhite,
      child: SvgPicture.asset("assets/$icon"),
      onTap: () {
        onClick();
      },
    );
  }
}
