import 'package:agora/common/helper/emoji_helper.dart';
import 'package:agora/common/strings/semantics_strings.dart';
import 'package:agora/design/style/agora_colors.dart';
import 'package:agora/design/style/agora_corners.dart';
import 'package:agora/design/style/agora_spacings.dart';
import 'package:agora/design/style/agora_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AgoraQagHeader extends StatelessWidget {
  final String titre;
  final String message;
  final void Function() onClose;

  const AgoraQagHeader({
    required this.titre,
    required this.message,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(AgoraSpacings.x1_25, 0, AgoraSpacings.x1_25, AgoraSpacings.base),
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.all(AgoraCorners.rounded),
              color: AgoraColors.blue525opacity06,
            ),
            padding: const EdgeInsets.all(AgoraSpacings.base),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  titre,
                  semanticsLabel: EmojiHelper.clean(titre),
                  textAlign: TextAlign.start,
                  style: AgoraTextStyles.medium14,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: AgoraSpacings.base),
                  child: Text(
                    message,
                    style: AgoraTextStyles.regular14,
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            top: 0,
            right: 0,
            child: InkWell(
              onTap: onClose,
              borderRadius: BorderRadius.all(AgoraCorners.rounded42),
              child: Semantics(
                button: true,
                label: SemanticsStrings.close,
                child: Material(
                  color: AgoraColors.transparent,
                  child: Padding(
                    padding: const EdgeInsets.all(AgoraSpacings.x0_75),
                    child: SvgPicture.asset("assets/ic_close.svg", excludeFromSemantics: true),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
