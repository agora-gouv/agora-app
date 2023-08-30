import 'package:agora/common/extension/string_extension.dart';
import 'package:agora/common/strings/semantics_strings.dart';
import 'package:agora/design/style/agora_colors.dart';
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
  final bool shouldHaveHorizontalPadding;
  final bool shouldHaveVerticalPadding;
  final AgoraLikeStyle style;
  final Function(bool support)? onSupportClick;

  const AgoraLikeView({
    super.key,
    required this.isSupported,
    required this.supportCount,
    this.shouldHaveHorizontalPadding = true,
    this.shouldHaveVerticalPadding = false,
    this.style = AgoraLikeStyle.police14,
    this.onSupportClick,
  });

  @override
  Widget build(BuildContext context) {
    Widget currentChild = Container(
      color: AgoraColors.transparent,
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: shouldHaveHorizontalPadding ? AgoraSpacings.x0_75 : 0,
          vertical: shouldHaveVerticalPadding ? 2 : 0,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SvgPicture.asset(_getIcon(), width: _buildIconSize(), excludeFromSemantics: true),
            SizedBox(width: AgoraSpacings.x0_25),
            Padding(
              padding: const EdgeInsets.only(bottom: AgoraSpacings.x0_25),
              child: Text(
                supportCount.toString(),
                style: _buildTextStyle(),
                semanticsLabel:
                    "${isSupported ? SemanticsStrings.support : SemanticsStrings.notSupport}\n${SemanticsStrings.supportNumber.format(supportCount.toString())}",
              ),
            ),
          ],
        ),
      ),
    );

    if (onSupportClick != null) {
      currentChild = Semantics(
        button: true,
        child: GestureDetector(
          onTap: () => onSupportClick!(!isSupported),
          child: currentChild,
        ),
      );
    } else {
      currentChild = Semantics(button: false, child: currentChild);
    }
    return currentChild;
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
