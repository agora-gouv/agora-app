import 'package:agora/design/style/agora_colors.dart';
import 'package:agora/design/style/agora_corners.dart';
import 'package:agora/design/style/agora_spacings.dart';
import 'package:agora/design/style/agora_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AgoraButton extends StatelessWidget {
  final String label;
  final void Function() onTap;
  final bool isLoading;
  final bool isExpanded;
  final bool isDisabled;
  final bool isRounded;
  final AgoraButtonStyle style;
  final EdgeInsets contentPadding;
  final String? semanticLabel;
  final String? prefixIcon;
  final EdgeInsets? prefixIconPadding;
  final ColorFilter? prefixIconColorFilter;
  final String? suffixIcon;
  final EdgeInsets? suffixIconPadding;
  final ColorFilter? suffixIconColorFilter;

  AgoraButton({
    required this.label,
    required this.onTap,
    this.isLoading = false,
    this.isExpanded = false,
    this.isDisabled = false,
    this.isRounded = false,
    this.style = AgoraButtonStyle.primary,
    this.contentPadding = const EdgeInsets.symmetric(vertical: AgoraSpacings.x0_5, horizontal: AgoraSpacings.x0_75),
    this.semanticLabel,
    this.prefixIcon,
    this.prefixIconPadding,
    this.prefixIconColorFilter,
    this.suffixIcon,
    this.suffixIconPadding,
    this.suffixIconColorFilter,
  });

  @override
  Widget build(BuildContext context) {
    final borderShape = RoundedRectangleBorder(
      borderRadius: BorderRadius.all(isRounded ? AgoraCorners.rounded50 : AgoraCorners.rounded),
      side: _getBorder(style),
    );
    Widget child;
    if (isLoading) {
      child = Center(child: CircularProgressIndicator());
    } else {
      child = _buildSemantic(
        child: Material(
          elevation: 0,
          color: _getBackgroundColor(style, isDisabled),
          shape: borderShape,
          child: InkWell(
            onTap: onTap,
            focusColor: AgoraColors.neutral400,
            customBorder: borderShape,
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: 48,
                minWidth: 48,
              ),
              child: Ink(
                padding: contentPadding,
                child: Wrap(
                  crossAxisAlignment: WrapCrossAlignment.center,
                  runAlignment: WrapAlignment.center,
                  alignment: WrapAlignment.center,
                  children: [
                    if (prefixIcon != null) ...[
                      Padding(
                        padding: prefixIconPadding ?? EdgeInsets.zero,
                        child: SvgPicture.asset(
                          "assets/${prefixIcon!}",
                          excludeFromSemantics: true,
                          colorFilter: prefixIconColorFilter,
                        ),
                      ),
                      const SizedBox(width: 8),
                    ],
                    Text(label, textAlign: TextAlign.center, style: _getTextStyle(style)),
                    if (suffixIcon != null) ...[
                      const SizedBox(width: 8),
                      Padding(
                        padding: suffixIconPadding ?? EdgeInsets.zero,
                        child: SvgPicture.asset(
                          "assets/${suffixIcon!}",
                          excludeFromSemantics: true,
                          colorFilter: suffixIconColorFilter,
                        ),
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
    if (isExpanded) {
      child = SizedBox(width: double.infinity, child: child);
    }
    return child;
  }

  Widget _buildSemantic({required Widget child}) {
    if (semanticLabel != null) {
      return Semantics(
        label: semanticLabel,
        button: true,
        enabled: !isDisabled,
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
      AgoraButtonStyle.blueBorder || AgoraButtonStyle.redBorder => AgoraColors.transparent,
      AgoraButtonStyle.grey || AgoraButtonStyle.lightGreyWithBorder => AgoraColors.steam,
      AgoraButtonStyle.lightGrey => AgoraColors.cascadingWhite,
      AgoraButtonStyle.transparentWithBorder => AgoraColors.transparent,
    };
  }
}

TextStyle _getTextStyle(AgoraButtonStyle style) {
  return switch (style) {
    AgoraButtonStyle.primary => AgoraTextStyles.primaryButton,
    AgoraButtonStyle.blueBorder => AgoraTextStyles.primaryBlueTextButton,
    AgoraButtonStyle.redBorder => AgoraTextStyles.redTextButton,
    AgoraButtonStyle.grey ||
    AgoraButtonStyle.lightGrey ||
    AgoraButtonStyle.lightGreyWithBorder ||
    AgoraButtonStyle.transparentWithBorder =>
      AgoraTextStyles.lightGreyButton,
  };
}

BorderSide _getBorder(AgoraButtonStyle style) {
  return switch (style) {
    AgoraButtonStyle.primary || AgoraButtonStyle.grey || AgoraButtonStyle.lightGrey => BorderSide.none,
    AgoraButtonStyle.blueBorder => BorderSide(color: AgoraColors.primaryBlue, width: 1.0, style: BorderStyle.solid),
    AgoraButtonStyle.redBorder => BorderSide(color: AgoraColors.red, width: 1.0, style: BorderStyle.solid),
    AgoraButtonStyle.lightGreyWithBorder => BorderSide(color: AgoraColors.border, width: 1, style: BorderStyle.solid),
    AgoraButtonStyle.transparentWithBorder =>
      BorderSide(color: AgoraColors.orochimaru, width: 1, style: BorderStyle.solid),
  };
}

enum AgoraButtonStyle {
  primary,
  blueBorder,
  redBorder,
  grey,
  lightGrey,
  lightGreyWithBorder,
  transparentWithBorder,
}
