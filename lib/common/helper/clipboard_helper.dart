import 'package:agora/design/style/agora_colors.dart';
import 'package:agora/design/style/agora_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ClipboardHelper {
  static void copy(BuildContext context, String text) {
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          "$text est copié.",
          style: AgoraTextStyles.light14.copyWith(color: AgoraColors.white),
        ),
      ),
    );
  }
}
