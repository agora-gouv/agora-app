import 'package:agora/common/strings/semantics_strings.dart';
import 'package:agora/design/custom_view/button/agora_button.dart';
import 'package:agora/design/style/agora_colors.dart';
import 'package:agora/design/style/agora_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AgoraInformationBottomSheet extends StatelessWidget {
  final String title;
  final Widget description;

  const AgoraInformationBottomSheet({
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) => AgoraBottomSheet(
        content: [
          Text(
            title,
            style: AgoraTextStyles.medium22,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          description,
          const SizedBox(height: 36),
          Row(
            children: [
              Expanded(
                child: AgoraButton.withLabel(
                  label: 'J’ai compris',
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ),
            ],
          ),
        ],
      );
}

class AgoraBottomSheet extends StatelessWidget {
  final List<Widget> content;
  final EdgeInsetsGeometry contentPadding;
  final bool stretch;
  final bool withInsetsBottom;
  final void Function()? closeButtonHandler;
  final bool showCloseButton;

  const AgoraBottomSheet({
    super.key,
    required this.content,
    this.stretch = false,
    this.withInsetsBottom = false,
    this.closeButtonHandler,
    this.contentPadding = const EdgeInsets.only(left: 24, right: 24, bottom: 24),
    this.showCloseButton = true,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: ClipRRect(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(40)),
        child: Material(
          color: AgoraColors.white,
          child: Container(
            constraints: BoxConstraints(
              maxHeight: 9 * MediaQuery.of(context).size.height / 10,
            ),
            child: SafeArea(
              child: Padding(
                padding: withInsetsBottom
                    ? EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom)
                    : EdgeInsets.zero,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    if (showCloseButton)
                      Container(
                        margin: EdgeInsets.only(top: 16, right: 16),
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: CrossButton(
                            onTap: () {
                              Navigator.pop(context);
                              closeButtonHandler?.call();
                            },
                            highlightColor: AgoraColors.neutral300,
                            splashColor: AgoraColors.neutral300,
                          ),
                        ),
                      ),
                    Flexible(
                      child: SingleChildScrollView(
                        padding: contentPadding,
                        child: Column(
                          crossAxisAlignment: stretch ? CrossAxisAlignment.stretch : CrossAxisAlignment.center,
                          children: content,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class CrossButton extends StatelessWidget {
  final String accessibilityLabel;
  final Color? splashColor;
  final Color? highlightColor;
  final double size;

  final void Function()? onTap;

  const CrossButton({
    this.accessibilityLabel = SemanticsStrings.close,
    this.onTap,
    this.splashColor,
    this.highlightColor,
    this.size = 12,
  });

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: accessibilityLabel,
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(40),
        child: InkWell(
          splashColor: splashColor,
          highlightColor: highlightColor,
          borderRadius: BorderRadius.circular(40),
          onTap: onTap,
          child: SizedBox(
            width: 48,
            height: 48,
            child: Center(
              child: SvgPicture.asset(
                'assets/ic_close.svg',
                excludeFromSemantics: true,
                alignment: Alignment.centerRight,
                height: size,
                width: size,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
