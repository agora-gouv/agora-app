import 'package:agora/design/style/agora_colors.dart';
import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_framework.dart';

class AgoraResponsiveView extends StatelessWidget {
  final Widget child;

  const AgoraResponsiveView({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return MaxWidthBox(
      maxWidth: 1024,
      background: Container(color: AgoraColors.background),
      child: ResponsiveScaledBox(
        width: ResponsiveValue<double>(
          context,
          conditionalValues: [
            // Condition.equals(name: MOBILE, value: 450),
            // Condition.between(start: 800, end: 1100, value: 800),
            // Condition.between(start: 1000, end: 1200, value: 1000),
            // There are no conditions for width over 1200
            // because the `maxWidth` is set to 1200 via the MaxWidthBox.
          ],
        ).value,
        child: BouncingScrollWrapper.builder(context, child, dragWithMouse: true),
      ),
    );
  }
}
