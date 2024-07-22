import 'package:agora/design/style/agora_colors.dart';
import 'package:agora/design/style/agora_corners.dart';
import 'package:agora/design/style/agora_spacings.dart';
import 'package:flutter/material.dart';

enum AgoraRoundedCorner { topRounded, bottomRounded, allRounded }

class AgoraRoundedCard extends StatelessWidget {
  final Color cardColor;
  final Color focusColor;
  final Color borderColor;
  final double borderWidth;
  final void Function()? onTap;
  final Radius cornerRadius;
  final AgoraRoundedCorner roundedCorner;
  final EdgeInsetsGeometry padding;
  final Widget child;

  AgoraRoundedCard({
    this.cardColor = AgoraColors.white,
    this.focusColor = AgoraColors.neutral200,
    this.borderColor = AgoraColors.transparent,
    this.onTap,
    this.borderWidth = 1.0,
    this.cornerRadius = AgoraCorners.rounded,
    this.roundedCorner = AgoraRoundedCorner.allRounded,
    this.padding = const EdgeInsets.all(AgoraSpacings.base),
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: _getBorderRadius(),
      child: Material(
        color: cardColor,
        child: InkWell(
          borderRadius: _getBorderRadius(),
          focusColor: onTap != null ? focusColor : null,
          onTap: onTap,
          child: DecoratedBox(
            decoration: BoxDecoration(
              borderRadius: _getBorderRadius(),
              border: Border.fromBorderSide(
                BorderSide(
                  color: borderColor,
                  width: borderWidth,
                  style: BorderStyle.solid,
                ),
              ),
            ),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: 48,
                minWidth: 48,
              ),
              child: Padding(padding: padding, child: child),
            ),
          ),
        ),
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
