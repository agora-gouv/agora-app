import 'package:agora/design/custom_view/agora_rounded_card.dart';
import 'package:agora/design/style/agora_colors.dart';
import 'package:agora/design/style/agora_spacings.dart';
import 'package:agora/design/style/agora_text_styles.dart';
import 'package:flutter/material.dart';

class OnboardingThematiqueCard extends StatelessWidget {
  final String picto;
  final String label;

  OnboardingThematiqueCard({
    required this.picto,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return AgoraRoundedCard(
      cardColor: AgoraColors.doctor,
      borderColor: AgoraColors.stoicWhite,
      padding: const EdgeInsets.all(AgoraSpacings.base),
      child: Column(
        children: [
          ExcludeSemantics(child: Text(picto, style: AgoraTextStyles.medium32)),
          SizedBox(height: AgoraSpacings.x0_5),
          Text(label, style: AgoraTextStyles.regular12, textAlign: TextAlign.center),
        ],
      ),
    );
  }
}
