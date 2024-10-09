import 'package:agora/common/helper/responsive_helper.dart';
import 'package:agora/design/style/agora_colors.dart';
import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_framework.dart';

class AgoraResponsiveView extends StatelessWidget {
  final Widget child;

  const AgoraResponsiveView({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return MaxWidthBox(
      maxWidth: ResponsiveHelper.maxScreenSize,
      backgroundColor: AgoraColors.background,
      child: ResponsiveScaledBox(
        width: ResponsiveValue<double?>(
          context,
          conditionalValues: [],
        ).value,
        child: BouncingScrollWrapper.builder(context, child, dragWithMouse: true),
      ),
    );
  }
}
