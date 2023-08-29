import 'package:agora/design/style/agora_colors.dart';
import 'package:agora/design/style/agora_corners.dart';
import 'package:agora/design/style/agora_spacings.dart';
import 'package:agora/design/style/agora_text_styles.dart';
import 'package:flutter/material.dart';

class AgoraToggleButton extends StatelessWidget {
  final bool isSelected;
  final String text;
  final VoidCallback? onClicked;

  const AgoraToggleButton({
    super.key,
    required this.isSelected,
    required this.text,
    this.onClicked,
  });

  @override
  Widget build(BuildContext context) {
    return ToggleButtons(
      isSelected: [isSelected],
      onPressed: (_) => onClicked?.call(),
      color: AgoraColors.white,
      borderColor: AgoraColors.border,
      selectedBorderColor: AgoraColors.primaryBlue,
      borderRadius: BorderRadius.all(AgoraCorners.rounded),
      children: [
        Ink(
          padding: EdgeInsets.symmetric(
            horizontal: AgoraSpacings.base,
            vertical: AgoraSpacings.base,
          ),
          child: Text(
            text,
            style: AgoraTextStyles.medium30.copyWith(height: 0),
          ),
        ),
      ],
    );
  }
}
