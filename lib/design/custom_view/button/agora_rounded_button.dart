import 'package:agora/design/custom_view/card/agora_rounded_card.dart';
import 'package:agora/design/style/agora_colors.dart';
import 'package:agora/design/style/agora_corners.dart';
import 'package:agora/design/style/agora_spacings.dart';
import 'package:agora/design/style/agora_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

enum AgoraRoundedButtonStyle { primaryButtonStyle, blueBorderButtonStyle, greyBorderButtonStyle }

enum AgoraRoundedButtonPadding { normal, short }

class AgoraRoundedButton extends StatelessWidget {
  final String? icon;
  final String label;
  final String? semanticLabel;
  final bool isLoading;
  final AgoraRoundedButtonStyle style;
  final AgoraRoundedButtonPadding contentPadding;
  final EdgeInsetsGeometry? textPadding;
  final VoidCallback onPressed;

  const AgoraRoundedButton({
    super.key,
    this.icon,
    required this.label,
    this.semanticLabel,
    this.isLoading = false,
    this.style = AgoraRoundedButtonStyle.primaryButtonStyle,
    this.contentPadding = AgoraRoundedButtonPadding.normal,
    this.textPadding,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Center(child: CircularProgressIndicator());
    } else {
      return Semantics(
        button: true,
        child: AgoraRoundedCard(
          focusColor: _buildFocusColor(),
          borderColor: _buildBorderColor() ?? AgoraColors.transparent,
          cornerRadius: AgoraCorners.rounded50,
          padding: _buildPadding(),
          cardColor: _buildCardColor(),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              if (icon != null) ...[
                SvgPicture.asset("assets/$icon", excludeFromSemantics: true),
                SizedBox(width: AgoraSpacings.x0_5),
              ],
              Flexible(
                child: Padding(
                  padding: textPadding ?? EdgeInsets.zero,
                  child: Text(
                    label,
                    semanticsLabel: semanticLabel,
                    style: _buildTextStyle(),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ],
          ),
          onTap: () => onPressed(),
        ),
      );
    }
  }

  Color? _buildBorderColor() {
    switch (style) {
      case AgoraRoundedButtonStyle.primaryButtonStyle:
        return null;
      case AgoraRoundedButtonStyle.blueBorderButtonStyle:
        return AgoraColors.primaryBlue;
      case AgoraRoundedButtonStyle.greyBorderButtonStyle:
        return AgoraColors.orochimaru;
    }
  }

  Color _buildFocusColor() {
    switch (style) {
      case AgoraRoundedButtonStyle.primaryButtonStyle:
        return AgoraColors.neutral400;
      case AgoraRoundedButtonStyle.blueBorderButtonStyle:
        return AgoraColors.neutral200;
      case AgoraRoundedButtonStyle.greyBorderButtonStyle:
        return AgoraColors.neutral200;
    }
  }

  Color _buildCardColor() {
    switch (style) {
      case AgoraRoundedButtonStyle.primaryButtonStyle:
        return AgoraColors.primaryBlue;
      case AgoraRoundedButtonStyle.blueBorderButtonStyle:
        return AgoraColors.transparent;
      case AgoraRoundedButtonStyle.greyBorderButtonStyle:
        return AgoraColors.transparent;
    }
  }

  TextStyle _buildTextStyle() {
    switch (style) {
      case AgoraRoundedButtonStyle.primaryButtonStyle:
        return AgoraTextStyles.medium14.copyWith(color: AgoraColors.white);
      case AgoraRoundedButtonStyle.blueBorderButtonStyle:
        return AgoraTextStyles.medium14.copyWith(color: AgoraColors.primaryBlue);
      case AgoraRoundedButtonStyle.greyBorderButtonStyle:
        return AgoraTextStyles.medium14;
    }
  }

  EdgeInsetsGeometry _buildPadding() {
    switch (contentPadding) {
      case AgoraRoundedButtonPadding.normal:
        return EdgeInsets.symmetric(vertical: AgoraSpacings.x0_5, horizontal: AgoraSpacings.base);
      case AgoraRoundedButtonPadding.short:
        return EdgeInsets.symmetric(vertical: AgoraSpacings.x0_5, horizontal: AgoraSpacings.x0_75);
    }
  }
}
