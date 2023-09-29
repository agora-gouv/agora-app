import 'package:agora/design/custom_view/agora_rounded_card.dart';
import 'package:agora/design/style/agora_colors.dart';
import 'package:agora/design/style/agora_spacings.dart';
import 'package:agora/design/style/agora_text_styles.dart';
import 'package:flutter/material.dart';

class AgoraHighLightCard extends StatelessWidget {
  final String label;

  const AgoraHighLightCard({
    super.key,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return AgoraRoundedCard(
      cardColor: AgoraColors.fluorescentRed,
      padding: const EdgeInsets.symmetric(horizontal: AgoraSpacings.x0_5, vertical: AgoraSpacings.x0_25),
      child: Text(label, style: AgoraTextStyles.medium14.copyWith(color: AgoraColors.white)),
    );
  }
}
