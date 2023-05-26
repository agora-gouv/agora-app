import 'package:agora/design/custom_view/agora_rounded_card.dart';
import 'package:agora/design/style/agora_colors.dart';
import 'package:agora/design/style/agora_corners.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AgoraNextButton extends StatelessWidget {
  final String icon;
  final VoidCallback onPressed;

  const AgoraNextButton({
    super.key,
    required this.icon,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return AgoraRoundedCard(
      cornerRadius: AgoraCorners.round,
      cardColor: AgoraColors.primaryBlue,
      child: SvgPicture.asset("assets/$icon"),
      onTap: () => onPressed(),
    );
  }
}
