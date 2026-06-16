import 'package:agora/design/style/agora_colors.dart';
import 'package:agora/design/style/agora_spacings.dart';
import 'package:flutter/material.dart';

enum AgoraRoundedCorner { topRounded, bottomRounded, allRounded }

class AgoraRoundedCard extends StatelessWidget {
  final Color cardColor;
  final Color focusColor;
  final Color borderColor;
  final double borderWidth;
  final void Function()? onTap;
  final AgoraRoundedCorner roundedCorner;
  final EdgeInsetsGeometry padding;
  final Widget child;

  AgoraRoundedCard({
    this.cardColor = AgoraColors.white,
    this.focusColor = AgoraColors.neutral200,
    this.borderColor = AgoraColors.transparent,
    this.onTap,
    this.borderWidth = 1.0,
    this.roundedCorner = AgoraRoundedCorner.allRounded,
    this.padding = const EdgeInsets.all(AgoraSpacings.base),
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      child: Material(
        color: cardColor,
        child: InkWell(
          focusColor: onTap != null ? focusColor : null,
          onTap: onTap,
          child: DecoratedBox(
            decoration: BoxDecoration(
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
                minHeight: onTap != null ? 48 : 0,
                minWidth: onTap != null ? 48 : 0,
              ),
              child: Padding(padding: padding, child: child),
            ),
          ),
        ),
      ),
    );
  }
}
