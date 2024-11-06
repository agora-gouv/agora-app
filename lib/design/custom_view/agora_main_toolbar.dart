import 'package:agora/design/custom_view/agora_little_separator.dart';
import 'package:agora/design/style/agora_spacings.dart';
import 'package:flutter/material.dart';

class AgoraMainToolbar extends StatelessWidget {
  final Widget title;

  const AgoraMainToolbar({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: AgoraSpacings.horizontalPadding,
        top: AgoraSpacings.base,
        right: AgoraSpacings.horizontalPadding,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          title,
          SizedBox(height: AgoraSpacings.x1_25),
          AgoraLittleSeparator(),
        ],
      ),
    );
  }
}
