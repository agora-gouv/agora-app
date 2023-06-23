import 'package:agora/design/custom_view/agora_little_separator.dart';
import 'package:agora/design/custom_view/agora_rich_text.dart';
import 'package:agora/design/custom_view/agora_single_scroll_view.dart';
import 'package:agora/design/custom_view/agora_toolbar.dart';
import 'package:agora/design/style/agora_spacings.dart';
import 'package:flutter/material.dart';

enum AgoraSecondaryScrollType { generic, custom }

class AgoraSecondaryStyleView extends StatelessWidget {
  final AgoraRichText title;
  final VoidCallback? onBackClick;
  final Widget child;
  final AgoraSecondaryScrollType scrollType;

  const AgoraSecondaryStyleView({
    super.key,
    required this.title,
    this.onBackClick,
    this.scrollType = AgoraSecondaryScrollType.generic,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    Widget currentChild = Column(
      children: [
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

    if (scrollType == AgoraSecondaryScrollType.generic) {
      currentChild = SingleChildScrollView(physics: BouncingScrollPhysics(), child: currentChild);
    } else {
      currentChild = AgoraSingleScrollView(physics: BouncingScrollPhysics(), child: currentChild);
    }

    return Column(
      children: [
        AgoraToolbar(onBackClick: onBackClick),
        Expanded(child: currentChild),
      ],
    );
  }
}
