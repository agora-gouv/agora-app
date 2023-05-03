import 'package:agora/design/custom_view/agora_rounded_card.dart';
import 'package:agora/design/style/agora_spacings.dart';
import 'package:agora/design/style/agora_text_styles.dart';
import 'package:flutter/material.dart';

class AgoraThematiqueCard extends StatelessWidget {
  final String picto;
  final String label;
  final int color;

  AgoraThematiqueCard({
    required this.picto,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return AgoraRoundedCard(
      cardColor: Color(color),
      padding: EdgeInsets.symmetric(vertical: AgoraSpacings.x0_25, horizontal: AgoraSpacings.x0_5),
      child: Text("$picto $label", style: AgoraTextStyles.medium14),
    );
  }
}
