import 'package:agora/design/custom_view/agora_rounded_card.dart';
import 'package:agora/design/style/agora_colors.dart';
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
      cardColor: AgoraColors.transparent,
      padding: null,
      child: Text("$picto $label", style: AgoraTextStyles.medium14.copyWith(color: AgoraColors.primaryGreen)),
    );
  }
}
