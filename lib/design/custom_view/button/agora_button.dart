import 'package:agora/design/style/agora_colors.dart';
import 'package:agora/design/style/agora_corners.dart';
import 'package:agora/design/style/agora_spacings.dart';
import 'package:agora/design/style/agora_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AgoraButton extends StatelessWidget {
  final bool isLoading;
  final String label;
  final String? semanticLabel;
  final String? prefixIcon;
  final ColorFilter? prefixIconColorFilter;
  final String? suffixIcon;
  final ColorFilter? suffixIconColorFilter;
  final AgoraButtonStyle buttonStyle;
  final bool expanded;
  final bool isDisabled;
  final Widget? icon;
  final void Function()? onPressed;

  AgoraButton({
    super.key,
    this.isLoading = false,
    required this.label,
    this.semanticLabel,
    this.prefixIcon,
    this.prefixIconColorFilter,
    this.suffixIcon,
    this.suffixIconColorFilter,
    this.buttonStyle = AgoraButtonStyle.primary,
    this.expanded = false,
    this.isDisabled = false,
    this.icon,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final borderShape =
        RoundedRectangleBorder(borderRadius: BorderRadius.all(AgoraCorners.rounded12), side: _getBorder(buttonStyle));
    Widget child;
    if (isLoading) {
      child = Center(child: CircularProgressIndicator());
    } else {
      child = _buildSemantic(
        child: Material(
          elevation: 0,
          color: _getBackgroundColor(buttonStyle, isDisabled),
          shape: borderShape,
          child: InkWell(
            onTap: onPressed,
            focusColor: AgoraColors.neutral400,
            customBorder: borderShape,
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: 44,
                minWidth: 44,
              ),
              child: Ink(
                padding: EdgeInsets.symmetric(vertical: AgoraSpacings.x0_5, horizontal: AgoraSpacings.x0_75),
                child: Wrap(
                  crossAxisAlignment: WrapCrossAlignment.center,
                  runAlignment: WrapAlignment.center,
                  alignment: WrapAlignment.center,
                  children: [
                    if (icon != null) icon!,
                    if (prefixIcon != null) ...[
                      SvgPicture.asset(
                        "assets/${prefixIcon!}",
                        excludeFromSemantics: true,
                        colorFilter: prefixIconColorFilter,
                      ),
                      const SizedBox(width: 8),
                    ],
                    Text(label, textAlign: TextAlign.center, style: _getTextStyle(buttonStyle)),
                    if (suffixIcon != null) ...[
                      const SizedBox(width: 8),
                      SvgPicture.asset(
                        "assets/${suffixIcon!}",
                        excludeFromSemantics: true,
                        colorFilter: suffixIconColorFilter,
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
        ),
      );
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

Color _getBackgroundColor(AgoraButtonStyle style, bool isDisabled) {
  if (isDisabled) {
    return style == AgoraButtonStyle.primary ? AgoraColors.gravelFint : AgoraColors.stereotypicalDuck;
  } else {
    return switch (style) {
      AgoraButtonStyle.primary => AgoraColors.primaryBlue,
      AgoraButtonStyle.secondary || AgoraButtonStyle.redBorder => AgoraColors.transparent,
      AgoraButtonStyle.tertiary => AgoraColors.transparent,
    };
  }
}

TextStyle _getTextStyle(AgoraButtonStyle style) {
  return switch (style) {
    AgoraButtonStyle.primary => AgoraTextStyles.primaryButton,
    AgoraButtonStyle.secondary => AgoraTextStyles.secondaryButton,
    AgoraButtonStyle.tertiary => AgoraTextStyles.tertiaryButton,
    AgoraButtonStyle.redBorder => AgoraTextStyles.redTextButton,
  };
}

BorderSide _getBorder(AgoraButtonStyle style) {
  return switch (style) {
    AgoraButtonStyle.primary => BorderSide.none,
    AgoraButtonStyle.secondary => BorderSide(color: AgoraColors.primaryBlue, width: 1.0, style: BorderStyle.solid),
    AgoraButtonStyle.tertiary => BorderSide(color: AgoraColors.border, width: 1, style: BorderStyle.solid),
    AgoraButtonStyle.redBorder => BorderSide(color: AgoraColors.red, width: 1.0, style: BorderStyle.solid),
  };
}

enum AgoraButtonStyle {
  primary,
  secondary,
  tertiary,
  redBorder,
}
