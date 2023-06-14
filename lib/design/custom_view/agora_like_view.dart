import 'package:agora/design/style/agora_spacings.dart';
import 'package:agora/design/style/agora_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AgoraLikeView extends StatelessWidget {
  final bool isSupported;
  final int supportCount;

  const AgoraLikeView({
    super.key,
    required this.isSupported,
    required this.supportCount,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        SvgPicture.asset(_getIcon()),
        SizedBox(width: AgoraSpacings.x0_25),
        Text(supportCount.toString(), style: AgoraTextStyles.medium14),
        SizedBox(width: AgoraSpacings.x0_5),
      ],
    );
  }

  String _getIcon() {
    if (isSupported) {
      return "assets/ic_heart_full.svg";
    } else {
      return "assets/ic_heart.svg";
    }
  }
}
