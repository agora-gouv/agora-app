import 'package:agora/design/custom_view/card/agora_rounded_card.dart';
import 'package:agora/design/style/agora_colors.dart';
import 'package:agora/design/style/agora_spacings.dart';
import 'package:agora/design/style/agora_text_styles.dart';
import 'package:flutter/material.dart';

enum AgoraThematiqueSize { medium, large }

class AgoraThematiqueLabel extends StatelessWidget {
  final String picto;
  final String label;
  final AgoraThematiqueSize size;

  AgoraThematiqueLabel({
    required this.picto,
    required this.label,
    required this.size,
  });

  @override
  Widget build(BuildContext context) {
    return AgoraRoundedCard(
      cardColor: AgoraColors.transparent,
      padding: EdgeInsets.zero,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (size == AgoraThematiqueSize.large) ...[
            ExcludeSemantics(child: Text(picto, style: AgoraTextStyles.medium23)),
            SizedBox(width: AgoraSpacings.x0_25),
            Flexible(
                child: Text(
              label,
              style: AgoraTextStyles.light18.copyWith(color: AgoraColors.potBlack),
              semanticsLabel: "Thématique : $label",
            )),
          ] else if (size == AgoraThematiqueSize.medium) ...[
            ExcludeSemantics(child: Text(picto, style: AgoraTextStyles.light12)),
            SizedBox(width: AgoraSpacings.x0_25),
            Flexible(
                child: Text(
              label,
              style: AgoraTextStyles.light14.copyWith(color: AgoraColors.potBlack),
              semanticsLabel: "Thématique : $label",
            )),
          ],
        ],
      ),
    );
  }
}
