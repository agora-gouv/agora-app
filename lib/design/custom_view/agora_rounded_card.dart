import 'package:agora/design/style/agora_colors.dart';
import 'package:agora/design/style/agora_corners.dart';
import 'package:agora/design/style/agora_spacings.dart';
import 'package:flutter/material.dart';

enum AgoraRoundedCorner { topRounded, bottomRounded, allRounded }

class AgoraRoundedCard extends StatelessWidget {
  final Color cardColor;
  final Color? borderColor;
  final VoidCallback? onTap;
  final Radius cornerRadius;
  final AgoraRoundedCorner roundedCorner;
  final EdgeInsetsGeometry? padding;
  final Widget child;

  AgoraRoundedCard({
    this.cardColor = AgoraColors.white,
    this.borderColor,
    this.onTap,
    this.cornerRadius = AgoraCorners.rounded,
    this.roundedCorner = AgoraRoundedCorner.allRounded,
    this.padding = const EdgeInsets.all(AgoraSpacings.base),
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    Widget currentChild = child;
    if (padding != null) {
      currentChild = Padding(
        padding: padding!,
        child: currentChild,
      );
    }
    if (borderColor != null) {
      currentChild = DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: _getBorderRadius(),
          border: Border.fromBorderSide(
            BorderSide(
              color: borderColor!,
              width: 1.0,
              style: BorderStyle.solid,
            ),
          ),
        ),
        child: currentChild,
      );
    }
    if (onTap != null) {
      currentChild = InkWell(
        onTap: () {
          onTap!();
        },
        child: currentChild,
      );
    }
    return ClipRRect(
      borderRadius: _getBorderRadius(),
      child: Material(
        color: cardColor,
        child: currentChild,
      ),
    );
  }

  BorderRadius _getBorderRadius() {
    switch (roundedCorner) {
      case AgoraRoundedCorner.allRounded:
        return BorderRadius.all(cornerRadius);
      case AgoraRoundedCorner.topRounded:
        return BorderRadius.vertical(top: cornerRadius);
      case AgoraRoundedCorner.bottomRounded:
        return BorderRadius.vertical(bottom: cornerRadius);
    }
  }
}
