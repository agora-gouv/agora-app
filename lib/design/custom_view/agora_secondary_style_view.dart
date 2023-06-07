import 'package:agora/design/custom_view/agora_little_separator.dart';
import 'package:agora/design/custom_view/agora_rich_text.dart';
import 'package:agora/design/custom_view/agora_toolbar.dart';
import 'package:agora/design/style/agora_spacings.dart';
import 'package:flutter/material.dart';

class AgoraSecondaryStyleView extends StatelessWidget {
  final AgoraRichText title;
  final VoidCallback? onBackClick;
  final Widget child;

  const AgoraSecondaryStyleView({
    super.key,
    required this.title,
    this.onBackClick,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AgoraToolbar(onBackClick: onBackClick),
        SizedBox(height: AgoraSpacings.x0_5),
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AgoraSpacings.horizontalPadding,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(children: [Expanded(child: title)]),
              SizedBox(height: AgoraSpacings.x1_25),
              AgoraLittleSeparator(),
              SizedBox(height: AgoraSpacings.base),
            ],
          ),
        ),
        child,
      ],
    );
  }
}
