import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AgoraButton extends StatelessWidget {
  final bool isLoading;
  final String label;
  final String? semanticLabel;
  final String? icon;
  final ButtonStyle style;
  final bool expanded;
  final VoidCallback? onPressed;

  AgoraButton({
    this.isLoading = false,
    required this.label,
    this.semanticLabel,
    this.icon,
    required this.style,
    this.expanded = false,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    Widget child;
    if (isLoading) {
      child = Center(child: CircularProgressIndicator());
    } else {
      final buttonLabel = Text(label, textAlign: TextAlign.center);
      if (icon != null) {
        child = _buildSemantic(
          child: ElevatedButton.icon(
            style: style,
            onPressed: onPressed,
            icon: SvgPicture.asset("assets/$icon", excludeFromSemantics: true),
            label: buttonLabel,
          ),
        );
      } else {
        child = _buildSemantic(
          child: ElevatedButton(
            style: style,
            onPressed: onPressed,
            child: buttonLabel,
          ),
        );
      }
    }
    if (expanded) {
      child = SizedBox(width: double.infinity, child: child);
    }
    return child;
  }

  Widget _buildSemantic({required Widget child}) {
    if (semanticLabel != null) {
      return Semantics(
        label: semanticLabel,
        button: true,
        enabled: onPressed != null,
        child: ExcludeSemantics(child: child),
      );
    } else {
      return child;
    }
  }
}
