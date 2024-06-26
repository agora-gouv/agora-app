import 'package:agora/common/strings/generic_strings.dart';
import 'package:agora/design/style/agora_colors.dart';
import 'package:agora/design/style/agora_text_styles.dart';
import 'package:flutter/material.dart';

class AgoraErrorText extends StatelessWidget {
  final String errorMessage;
  final TextAlign textAlign;
  final void Function()? onReload;

  const AgoraErrorText({
    this.errorMessage = GenericStrings.errorMessage,
    this.textAlign = TextAlign.start,
    this.onReload,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      errorMessage,
      style: AgoraTextStyles.light14.copyWith(color: AgoraColors.red),
      textAlign: textAlign,
    );
  }
}
