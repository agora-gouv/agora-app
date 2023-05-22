import 'package:agora/common/strings/generic_strings.dart';
import 'package:agora/design/style/agora_colors.dart';
import 'package:agora/design/style/agora_text_styles.dart';
import 'package:flutter/material.dart';

class AgoraErrorView extends StatelessWidget {
  final String errorMessage;

  const AgoraErrorView({super.key, this.errorMessage = GenericStrings.errorMessage});

  @override
  Widget build(BuildContext context) {
    return Text(
      errorMessage,
      style: AgoraTextStyles.light14.copyWith(color: AgoraColors.red),
    );
  }
}
