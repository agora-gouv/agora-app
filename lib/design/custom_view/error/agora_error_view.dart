import 'package:agora/common/strings/generic_strings.dart';
import 'package:agora/design/custom_view/error/agora_error_text.dart';
import 'package:agora/design/custom_view/button/agora_rounded_button.dart';
import 'package:agora/design/style/agora_spacings.dart';
import 'package:flutter/material.dart';

class AgoraErrorView extends StatelessWidget {
  final String errorMessage;
  final TextAlign textAlign;
  final void Function()? onReload;

  const AgoraErrorView({
    this.errorMessage = GenericStrings.errorMessage,
    this.textAlign = TextAlign.start,
    this.onReload,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AgoraErrorText(errorMessage: errorMessage, textAlign: textAlign),
        SizedBox(height: AgoraSpacings.base),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AgoraRoundedButton(
              label: GenericStrings.retry,
              style: AgoraRoundedButtonStyle.primaryButtonStyle,
              onPressed: () => onReload?.call(),
            ),
          ],
        ),
      ],
    );
  }
}
