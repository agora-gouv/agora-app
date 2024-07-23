import 'package:agora/design/custom_view/agora_little_separator.dart';
import 'package:agora/design/custom_view/agora_toolbar.dart';
import 'package:agora/design/custom_view/button/agora_button.dart';
import 'package:agora/design/custom_view/scroll/agora_single_scroll_view.dart';
import 'package:agora/design/style/agora_spacings.dart';
import 'package:flutter/material.dart';

enum AgoraSecondaryScrollType { generic, custom }

class AgoraSecondaryStyleViewButton {
  final String? icon;
  final String title;
  final String? accessibilityLabel;
  final VoidCallback onClick;

  AgoraSecondaryStyleViewButton({
    required this.icon,
    required this.title,
    required this.onClick,
    this.accessibilityLabel,
  });
}

class AgoraSecondaryStyleView extends StatelessWidget {
  final Widget child;
  final Widget title;
  final String pageLabel;
  final AgoraSecondaryScrollType scrollType;
  final String? buttonLabel;
  final String? buttonIcon;
  final String? buttonSemanticLabel;
  final void Function()? onTapButton;
  final VoidCallback? onBackClick;

  const AgoraSecondaryStyleView({
    required this.child,
    required this.title,
    required this.pageLabel,
    this.scrollType = AgoraSecondaryScrollType.generic,
    this.buttonLabel,
    this.buttonIcon,
    this.buttonSemanticLabel,
    this.onTapButton,
    this.onBackClick,
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
              Row(
                children: [
                  Expanded(
                    child: Semantics(
                      excludeSemantics: true,
                      child: title,
                    ),
                  ),
                  if (buttonLabel != null) ...[
                    SizedBox(width: AgoraSpacings.x0_75),
                    AgoraButton(
                      label: buttonLabel!,
                      isRounded: true,
                      prefixIcon: buttonIcon,
                      semanticLabel: buttonSemanticLabel,
                      style: AgoraButtonStyle.transparentWithBorder,
                      onTap: onTapButton!,
                    ),
                  ],
                ],
              ),
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
        AgoraToolbar(onBackClick: onBackClick, pageLabel: pageLabel),
        Expanded(child: currentChild),
      ],
    );
  }
}
