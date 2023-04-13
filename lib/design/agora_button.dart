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
    }

    final buttonLabel = Text(label, textAlign: TextAlign.center);
    if (icon != null) {
      return ElevatedButton.icon(
        style: style,
        onPressed: onPressed,
        icon: SvgPicture.asset("assets/$icon"),
        label: buttonLabel,
      );
    }
    return ElevatedButton(
      style: style,
      onPressed: onPressed,
      child: buttonLabel,
    );
  }
}
