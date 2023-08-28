import 'package:agora/common/strings/generic_strings.dart';
import 'package:agora/design/style/agora_colors.dart';
import 'package:agora/design/style/agora_spacings.dart';
import 'package:agora/design/style/agora_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

enum AgoraToolbarStyle { back, close }

class AgoraToolbar extends StatelessWidget {
  final VoidCallback? onBackClick;
  final AgoraToolbarStyle style;

  const AgoraToolbar({super.key, this.onBackClick, this.style = AgoraToolbarStyle.back});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AgoraSpacings.horizontalPadding, vertical: AgoraSpacings.x0_5),
      child: GestureDetector(
        onTap: () {
          if (onBackClick != null) {
            onBackClick!();
          } else {
            Navigator.pop(context);
          }
        },
        child: style == AgoraToolbarStyle.back ? _buildBack() : _buildClose(),
      ),
    );
  }

  Widget _buildBack() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Material(
          color: AgoraColors.transparent,
          child: Padding(
            padding: const EdgeInsets.only(
              top: AgoraSpacings.x0_5,
              bottom: AgoraSpacings.x0_5,
              right: AgoraSpacings.x0_75,
            ),
            child: SvgPicture.asset("assets/ic_back.svg", excludeFromSemantics: true),
          ),
        ),
        Flexible(
          child: Padding(
            padding: const EdgeInsets.only(bottom: AgoraSpacings.x0_25),
            child: Text(GenericStrings.back, style: AgoraTextStyles.medium16),
          ),
        ),
      ],
    );
  }

  Widget _buildClose() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(GenericStrings.close, style: AgoraTextStyles.medium16),
        SizedBox(width: AgoraSpacings.x0_75),
        Material(
          color: AgoraColors.transparent,
          child: Padding(
            padding: const EdgeInsets.only(
              top: AgoraSpacings.x0_5,
              bottom: AgoraSpacings.x0_5,
              right: AgoraSpacings.x0_75,
            ),
            child: SvgPicture.asset("assets/ic_close.svg", excludeFromSemantics: true),
          ),
        ),
      ],
    );
  }
}
