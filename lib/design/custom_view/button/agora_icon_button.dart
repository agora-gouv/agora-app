import 'package:agora/common/strings/semantics_strings.dart';
import 'package:agora/design/custom_view/agora_rounded_card.dart';
import 'package:agora/design/style/agora_colors.dart';
import 'package:agora/design/style/agora_spacings.dart';
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
    return Semantics(
      button: true,
      label: SemanticsStrings.share,
      child: AgoraRoundedCard(
        padding: EdgeInsets.symmetric(vertical: AgoraSpacings.x0_75, horizontal: AgoraSpacings.x0_75),
        borderColor: AgoraColors.steam,
        cardColor: AgoraColors.transparent,
        child: SvgPicture.asset("assets/$icon"),
        onTap: () {
          onClick();
        },
      ),
    );
  }
}
