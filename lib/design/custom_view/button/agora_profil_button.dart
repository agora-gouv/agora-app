import 'package:agora/design/agora_colors.dart';
import 'package:agora/design/agora_corners.dart';
import 'package:agora/design/agora_spacings.dart';
import 'package:agora/design/agora_text_styles.dart';
import 'package:agora/design/custom_view/agora_rounded_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AgoraProfilButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AgoraRoundedCard(
      borderColor: AgoraColors.orochimaru,
      cornerRadius: AgoraCorners.rounded50,
      padding: EdgeInsets.symmetric(vertical: AgoraSpacings.x0_5, horizontal: AgoraSpacings.x0_75),
      cardColor: AgoraColors.cascadingWhite,
      child: Row(
        children: [
          SvgPicture.asset("assets/ic_profil.svg"),
          SizedBox(width: AgoraSpacings.x0_5),
          Text("Profil", style: AgoraTextStyles.medium14),
        ],
      ),
      onTap: () {
        // TODO
      },
    );
  }
}
