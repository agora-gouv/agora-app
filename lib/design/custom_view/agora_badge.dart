import 'package:agora/design/style/agora_colors.dart';
import 'package:agora/design/style/agora_spacings.dart';
import 'package:agora/design/style/agora_text_styles.dart';
import 'package:flutter/material.dart';

class AgoraBadge extends StatelessWidget {
  final String label;
  final Color backgroundColor;
  final Color textColor;

  const AgoraBadge({
    this.label = "PARIS",
    this.backgroundColor = AgoraColors.badgeDepartemental,
    this.textColor = AgoraColors.badgeDepartementalTexte,
  });

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(AgoraSpacings.x0_25),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: AgoraSpacings.x0_25),
        child: Text(
          label,
          style: AgoraTextStyles.medium12.copyWith(color: textColor),
        ),
      ),
    );
  }
}
