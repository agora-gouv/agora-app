import 'package:agora/design/custom_view/agora_rounded_card.dart';
import 'package:agora/design/style/agora_colors.dart';
import 'package:agora/design/style/agora_corners.dart';
import 'package:agora/design/style/agora_spacings.dart';
import 'package:agora/design/style/agora_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

enum AgoraRoundedButtonStyle { primaryButtonStyle, greenBorderButtonStyle, greyBorderButtonStyle }

enum AgoraRoundedButtonPadding { normal, short }

class AgoraRoundedButton extends StatelessWidget {
  final String? icon;
  final String label;
  final AgoraRoundedButtonStyle style;
  final AgoraRoundedButtonPadding padding;
  final bool isLoading;
  final CrossAxisAlignment contentAlignment;
  final VoidCallback onPressed;

  const AgoraRoundedButton({
    super.key,
    this.icon,
    required this.label,
    this.isLoading = false,
    this.contentAlignment = CrossAxisAlignment.center,
    this.style = AgoraRoundedButtonStyle.primaryButtonStyle,
    this.padding = AgoraRoundedButtonPadding.normal,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Center(child: CircularProgressIndicator());
    } else {
      return AgoraRoundedCard(
        borderColor: _buildBorderColor(),
        cornerRadius: AgoraCorners.rounded50,
        padding: _buildPadding(),
        cardColor: _buildCardColor(),
        child: Row(
          crossAxisAlignment: contentAlignment,
          children: [
            if (icon != null) ...[
              SvgPicture.asset("assets/$icon"),
              SizedBox(width: AgoraSpacings.x0_5),
            ],
            Text(label, style: _buildTextStyle()),
          ],
        ),
        onTap: () => onPressed(),
      );
    }
  }

  Color? _buildBorderColor() {
    switch (style) {
      case AgoraRoundedButtonStyle.primaryButtonStyle:
        return null;
      case AgoraRoundedButtonStyle.greenBorderButtonStyle:
        return AgoraColors.primaryGreen;
      case AgoraRoundedButtonStyle.greyBorderButtonStyle:
        return AgoraColors.orochimaru;
    }
  }

  Color _buildCardColor() {
    switch (style) {
      case AgoraRoundedButtonStyle.primaryButtonStyle:
        return AgoraColors.primaryGreen;
      case AgoraRoundedButtonStyle.greenBorderButtonStyle:
        return AgoraColors.transparent;
      case AgoraRoundedButtonStyle.greyBorderButtonStyle:
        return AgoraColors.transparent;
    }
  }

  TextStyle _buildTextStyle() {
    switch (style) {
      case AgoraRoundedButtonStyle.primaryButtonStyle:
        return AgoraTextStyles.medium14.copyWith(color: AgoraColors.white);
      case AgoraRoundedButtonStyle.greenBorderButtonStyle:
        return AgoraTextStyles.medium14.copyWith(color: AgoraColors.primaryGreen);
      case AgoraRoundedButtonStyle.greyBorderButtonStyle:
        return AgoraTextStyles.medium14;
    }
  }

  EdgeInsetsGeometry _buildPadding() {
    switch (padding) {
      case AgoraRoundedButtonPadding.normal:
        return EdgeInsets.symmetric(vertical: AgoraSpacings.x0_5, horizontal: AgoraSpacings.base);
      case AgoraRoundedButtonPadding.short:
        return EdgeInsets.symmetric(vertical: AgoraSpacings.x0_5, horizontal: AgoraSpacings.x0_75);
    }
  }
}
