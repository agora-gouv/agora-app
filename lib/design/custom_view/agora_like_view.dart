import 'package:agora/design/style/agora_spacings.dart';
import 'package:agora/design/style/agora_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

enum AgoraLikeStyle {
  police12,
  police14,
}

class AgoraLikeView extends StatelessWidget {
  final bool isSupported;
  final int supportCount;
  final bool addEndSpacing;
  final AgoraLikeStyle style;

  const AgoraLikeView({
    super.key,
    required this.isSupported,
    required this.supportCount,
    this.addEndSpacing = true,
    this.style = AgoraLikeStyle.police14,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        SvgPicture.asset(_getIcon(), width: _buildIconSize()),
        SizedBox(width: AgoraSpacings.x0_25),
        Text(supportCount.toString(), style: _buildTextStyle()),
        if (addEndSpacing) SizedBox(width: AgoraSpacings.x0_5),
      ],
    );
  }

  double _buildIconSize() {
    switch (style) {
      case AgoraLikeStyle.police12:
        return 14;
      case AgoraLikeStyle.police14:
        return 18;
    }
  }

  TextStyle _buildTextStyle() {
    switch (style) {
      case AgoraLikeStyle.police12:
        return AgoraTextStyles.medium12;
      case AgoraLikeStyle.police14:
        return AgoraTextStyles.medium14;
    }
  }

  String _getIcon() {
    if (isSupported) {
      return "assets/ic_heart_full.svg";
    } else {
      return "assets/ic_heart.svg";
    }
  }
}
