import 'package:agora/design/agora_spacings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AgoraButton extends StatelessWidget {
  final bool isLoading;
  final String label;
  final String? icon;
  final ButtonStyle style;
  final VoidCallback? onPressed;

  AgoraButton({
    this.isLoading = false,
    required this.label,
    this.icon,
    required this.style,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Center(child: CircularProgressIndicator());
    } else {
      Widget child = Text(label, textAlign: TextAlign.center);
      if (icon != null) {
        child = Row(
          children: [
            SvgPicture.asset("assets/$icon"),
            SizedBox(width: AgoraSpacings.x0_5),
            child,
          ],
        );
      }
      return ElevatedButton(
        style: style,
        onPressed: onPressed,
        child: child,
      );
    }
  }
}
