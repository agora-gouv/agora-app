import 'package:agora/design/style/agora_colors.dart';
import 'package:agora/design/style/agora_spacings.dart';
import 'package:agora/design/style/agora_text_styles.dart';
import 'package:flutter/material.dart';

class AgoraTextField extends StatelessWidget {
  final int maxLength;
  final String hintText;
  final Function(String) onChanged;

  const AgoraTextField({
    super.key,
    required this.maxLength,
    this.hintText = "",
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      minLines: 1,
      maxLines: 20,
      scrollPadding: const EdgeInsets.only(bottom: AgoraSpacings.x3),
      maxLength: maxLength,
      keyboardType: TextInputType.multiline,
      style: AgoraTextStyles.light14,
      decoration: InputDecoration(
        isDense: true,
        contentPadding: EdgeInsets.all(AgoraSpacings.base),
        filled: true,
        fillColor: AgoraColors.white,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(4)),
          borderSide: BorderSide(width: 1, color: AgoraColors.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(width: 1, color: AgoraColors.primaryGreen),
        ),
        hintText: hintText,
        hintStyle: AgoraTextStyles.light14.copyWith(color: AgoraColors.orochimaru),
      ),
      onChanged: (input) {
        onChanged(input);
      },
    );
  }
}
