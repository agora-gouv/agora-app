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
  final String? icon;
  final AgoraButtonStyle buttonStyle;
  final bool expanded;
  final bool isDisabled;
  final void Function()? onPressed;

  AgoraButton({
    this.isLoading = false,
    required this.label,
    this.semanticLabel,
    this.icon,
    this.buttonStyle = AgoraButtonStyle.primary,
    this.expanded = false,
    this.isDisabled = false,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final borderShape =
        RoundedRectangleBorder(borderRadius: BorderRadius.all(AgoraCorners.rounded), side: _getBorder(buttonStyle));
    Widget child;
    if (isLoading) {
      child = Center(child: CircularProgressIndicator());
    } else {
      child = _buildSemantic(
        child: Material(
          elevation: 0,
          child: InkWell(
            onTap: onPressed,
            focusColor: AgoraColors.neutral400,
            customBorder: borderShape,
            child: Ink(
              padding: EdgeInsets.symmetric(vertical: AgoraSpacings.x0_5, horizontal: AgoraSpacings.x0_75),
              decoration: isDisabled
                  ? ShapeDecoration(
                      shape: borderShape,
                      color: AgoraColors.gravelFint,
                    )
                  : ShapeDecoration(
                      shape: borderShape,
                      color: _getBackgroundColor(buttonStyle, isDisabled),
                    ),
              child: icon != null
                  ? Wrap(
                      crossAxisAlignment: WrapCrossAlignment.center,
                      alignment: WrapAlignment.center,
                      children: [
                        SvgPicture.asset(
                          "assets/${icon!}",
                          excludeFromSemantics: true,
                        ),
                        const SizedBox(width: 8),
                        Text(label, textAlign: TextAlign.center, style: _getTextStyle(buttonStyle)),
                      ],
                    )
                  : Text(label, textAlign: TextAlign.center, style: _getTextStyle(buttonStyle)),
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
      AgoraButtonStyle.blueBorder || AgoraButtonStyle.redBorder => AgoraColors.transparent,
      AgoraButtonStyle.grey || AgoraButtonStyle.lightGreyWithBorder => AgoraColors.steam,
      AgoraButtonStyle.lightGrey => AgoraColors.cascadingWhite,
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
    AgoraButtonStyle.lightGreyWithBorder =>
      AgoraTextStyles.lightGreyButton,
  };
}

BorderSide _getBorder(AgoraButtonStyle style) {
  return switch (style) {
    AgoraButtonStyle.primary || AgoraButtonStyle.grey || AgoraButtonStyle.lightGrey => BorderSide.none,
    AgoraButtonStyle.blueBorder => BorderSide(color: AgoraColors.primaryBlue, width: 1.0, style: BorderStyle.solid),
    AgoraButtonStyle.redBorder => BorderSide(color: AgoraColors.red, width: 1.0, style: BorderStyle.solid),
    AgoraButtonStyle.lightGreyWithBorder => BorderSide(color: AgoraColors.border, width: 1, style: BorderStyle.solid),
  };
}

enum AgoraButtonStyle {
  primary,
  blueBorder,
  redBorder,
  grey,
  lightGrey,
  lightGreyWithBorder,
}
