import 'package:agora/design/agora_colors.dart';
import 'package:agora/design/agora_spacings.dart';
import 'package:agora/design/agora_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class AgoraToolbar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AgoraSpacings.base, vertical: AgoraSpacings.x0_5),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Material(
                  color: AgoraColors.transparent,
                  child: Padding(
                    padding: const EdgeInsets.only(
                      top: AgoraSpacings.x0_5,
                      bottom: AgoraSpacings.x0_5,
                      right: AgoraSpacings.x0_5,
                    ),
                    child: SvgPicture.asset("assets/ic_retour.svg"),
                  ),
                ),
                Text("Retour", style: AgoraTextStyles.medium16),
              ],
            ),
          ),
          Expanded(child: Container()),
        ],
      ),
    );
  }
}
