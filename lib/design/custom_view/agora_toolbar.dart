import 'package:agora/common/strings/generic_strings.dart';
import 'package:agora/design/style/agora_colors.dart';
import 'package:agora/design/style/agora_spacings.dart';
import 'package:agora/design/style/agora_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class AgoraToolbar extends StatelessWidget {
  final VoidCallback? onBackClick;

  const AgoraToolbar({super.key, this.onBackClick});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AgoraSpacings.horizontalPadding, vertical: AgoraSpacings.x0_5),
      child: Row(
        children: [
          GestureDetector(
            onTap: () {
              if (onBackClick != null) {
                onBackClick!();
              } else {
                Navigator.pop(context);
              }
            },
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Material(
                  color: AgoraColors.transparent,
                  child: Padding(
                    padding: const EdgeInsets.only(
                      top: AgoraSpacings.x0_5,
                      bottom: AgoraSpacings.x0_5,
                      right: AgoraSpacings.x0_75,
                    ),
                    child: SvgPicture.asset("assets/ic_back.svg"),
                  ),
                ),
                Text(GenericStrings.back, style: AgoraTextStyles.medium16),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
