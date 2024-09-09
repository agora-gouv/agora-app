import 'package:agora/design/custom_view/skeletons.dart';
import 'package:agora/design/style/agora_colors.dart';
import 'package:agora/design/style/agora_spacings.dart';
import 'package:agora/design/style/agora_text_styles.dart';
import 'package:flutter/material.dart';

class AgoraLinkText extends StatelessWidget {
  final List<InlineSpan>? textItems;
  final String? label;
  final Function()? onTap;
  final String? semanticsHint;
  final TextStyle? textStyle;
  final Alignment alignment;
  final TextAlign? textAlign;
  final EdgeInsets textPadding;
  final bool isLoading;
  final Color splashColor;
  final Color highlightColor;

  const AgoraLinkText({
    this.textItems,
    this.label,
    this.onTap,
    this.semanticsHint,
    this.textStyle = AgoraTextStyles.light14UnderlineBlue,
    this.alignment = Alignment.centerLeft,
    this.textAlign,
    this.textPadding = const EdgeInsets.all(AgoraSpacings.base),
    this.isLoading = false,
    this.splashColor = AgoraColors.neutral200,
    this.highlightColor = AgoraColors.neutral200,
  }) : assert((textItems != null && textItems != const []) || label != null);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Semantics(
        link: true,
        hint: semanticsHint,
        child: isLoading
            ? const SkeletonBox(width: 22, height: 22)
            : InkWell(
                splashColor: splashColor,
                highlightColor: highlightColor,
                borderRadius: BorderRadius.circular(4),
                onTap: onTap,
                child: ConstrainedBox(
                  constraints: BoxConstraints(minHeight: 44, minWidth: 44),
                  child: _TextContent(
                    textItems: textItems,
                    label: label,
                    textStyle: textStyle,
                    alignment: alignment,
                    textAlign: textAlign,
                    textPadding: textPadding,
                  ),
                ),
              ),
      ),
    );
  }
}

class _TextContent extends StatelessWidget {
  final List<InlineSpan>? textItems;
  final String? label;
  final TextStyle? textStyle;
  final Alignment alignment;
  final TextAlign? textAlign;
  final EdgeInsets textPadding;

  const _TextContent({
    this.textItems,
    this.label,
    this.textStyle,
    required this.alignment,
    this.textAlign,
    required this.textPadding,
  });

  @override
  Widget build(BuildContext context) {
    if (label != null) {
      return Padding(
        padding: textPadding,
        child: Align(
          alignment: alignment,
          child: Text(
            label!,
            style: textStyle,
            textAlign: textAlign,
          ),
        ),
      );
    } else {
      return RichText(
        textScaler: MediaQuery.textScalerOf(context),
        text: TextSpan(
          children: textItems,
        ),
      );
    }
  }
}
