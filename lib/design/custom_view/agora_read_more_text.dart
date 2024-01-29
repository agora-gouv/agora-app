import 'dart:math';

import 'package:agora/common/strings/qag_strings.dart';
import 'package:agora/design/style/agora_colors.dart';
import 'package:agora/design/style/agora_spacings.dart';
import 'package:agora/design/style/agora_text_styles.dart';
import 'package:flutter/material.dart';

enum AgoraTrimMode {
  length,
  line,
}

class AgoraReadMoreText extends StatefulWidget {
  final String data;
  final String trimExpandedText;
  final String trimCollapsedText;
  final Color colorClickableText;
  final int trimLength;
  final int trimLines;
  final AgoraTrimMode trimMode;
  final TextStyle style;
  final TextStyle trimTextStyle;
  final TextAlign textAlign;
  final TextDirection textDirection;

  const AgoraReadMoreText(
    this.data, {
    super.key,
    this.trimExpandedText = QagStrings.readMore,
    this.trimCollapsedText = QagStrings.readLess,
    this.colorClickableText = AgoraColors.primaryBlue,
    this.trimLength = 240,
    this.trimLines = 12,
    this.trimMode = AgoraTrimMode.line,
    this.style = AgoraTextStyles.light14,
    this.trimTextStyle = AgoraTextStyles.light14Underline,
    this.textAlign = TextAlign.start,
    this.textDirection = TextDirection.ltr,
  }) : assert(
          (trimMode == AgoraTrimMode.line && trimLines > 0) || (trimMode == AgoraTrimMode.length && trimLength > 0),
        );

  @override
  AgoraReadMoreTextState createState() => AgoraReadMoreTextState();
}

class AgoraReadMoreTextState extends State<AgoraReadMoreText> {
  bool _readMore = true;

  void _onReadMoreLink() {
    setState(() => _readMore = !_readMore);
  }

  @override
  Widget build(BuildContext context) {
    final textAlign = widget.textAlign;
    final textDirection = widget.textDirection;
    final textStyle = widget.style;
    final colorClickableText = widget.colorClickableText;

    const double minWidth = 0;
    final double maxWidth = MediaQuery.of(context).size.width - AgoraSpacings.horizontalPadding * 2;

    final data = widget.data;

    final text = TextSpan(style: textStyle, text: data);
    final TextPainter textPainter = TextPainter(
      text: text,
      textAlign: textAlign,
      textScaler: MediaQuery.textScalerOf(context),
      textDirection: textDirection,
      locale: Localizations.localeOf(context),
      maxLines: widget.trimLength,
    );
    textPainter.layout(maxWidth: maxWidth, minWidth: minWidth);
    final lines = textPainter.computeLineMetrics().length;

    final readMoreButton = Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: _onReadMoreLink,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: AgoraSpacings.x0_5),
          child: Text(
            _readMore ? widget.trimExpandedText : widget.trimCollapsedText,
            style: widget.trimTextStyle.copyWith(color: colorClickableText),
          ),
        ),
      ),
    );

    Widget textSpan;
    switch (widget.trimMode) {
      case AgoraTrimMode.length:
        if (widget.trimLength < data.length) {
          textSpan = Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              RichText(
                textScaler: MediaQuery.of(context).textScaler,
                textAlign: textAlign,
                textDirection: textDirection,
                text: TextSpan(
                  text: _readMore ? data.substring(0, min(data.length, widget.trimLength)) : data,
                  style: textStyle,
                ),
              ),
              readMoreButton,
            ],
          );
        } else {
          textSpan = Text(data, style: textStyle);
        }
        break;
      case AgoraTrimMode.line:
        if (lines > widget.trimLines) {
          textSpan = Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              RichText(
                textScaler: MediaQuery.of(context).textScaler,
                textAlign: textAlign,
                textDirection: textDirection,
                maxLines: _readMore ? widget.trimLines : null,
                text: TextSpan(
                  text: data,
                  style: textStyle,
                ),
              ),
              readMoreButton,
            ],
          );
        } else {
          textSpan = RichText(
            textScaler: MediaQuery.of(context).textScaler,
            textAlign: textAlign,
            textDirection: textDirection,
            text: TextSpan(style: textStyle, text: data),
          );
        }
        break;
    }

    return textSpan;
  }
}
