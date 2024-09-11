import 'package:agora/design/style/agora_colors.dart';
import 'package:agora/design/style/agora_spacings.dart';
import 'package:agora/design/style/agora_text_styles.dart';
import 'package:flutter/material.dart';

class AgoraBadge extends StatelessWidget {
  final String label;
  final Color color;

  const AgoraBadge({
    this.label = "ILE-DE-FRANCE",
    this.color = AgoraColors.badgeRegion,
  });

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(AgoraSpacings.x0_25),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: AgoraSpacings.x0_25),
        child: Text(
          label,
          style: AgoraTextStyles.medium12.copyWith(color: AgoraColors.badgeTexte),
        ),
      ),
    );
  }
}
