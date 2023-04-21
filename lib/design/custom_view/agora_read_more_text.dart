import 'package:agora/common/strings/qag_strings.dart';
import 'package:agora/design/agora_colors.dart';
import 'package:agora/design/agora_spacings.dart';
import 'package:agora/design/agora_text_styles.dart';
import 'package:flutter/gestures.dart';
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
  final TextAlign textAlign;
  final TextDirection textDirection;

  const AgoraReadMoreText(
    this.data, {
    Key? key,
    this.trimExpandedText = QagStrings.readMore,
    this.trimCollapsedText = QagStrings.readLess,
    this.colorClickableText = AgoraColors.blueFrance,
    this.trimLength = 240,
    this.trimLines = 8,
    this.trimMode = AgoraTrimMode.line,
    this.style = AgoraTextStyles.light14,
    this.textAlign = TextAlign.start,
    this.textDirection = TextDirection.ltr,
  }) : super(key: key);

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

    final TextSpan readMoreButton = TextSpan(
      text: _readMore ? widget.trimExpandedText : widget.trimCollapsedText,
      style: textStyle.copyWith(color: colorClickableText),
      recognizer: TapGestureRecognizer()..onTap = _onReadMoreLink,
    );

    final double minWidth = MediaQuery.of(context).size.width - AgoraSpacings.horizontalPadding;
    final double maxWidth = MediaQuery.of(context).size.width;

    final data = widget.data;
    final text = TextSpan(style: textStyle, text: data);

    final TextPainter textPainter = TextPainter(
      text: readMoreButton,
      textAlign: textAlign,
      textDirection: textDirection,
      maxLines: widget.trimLines,
      locale: Localizations.localeOf(context),
    );
    textPainter.layout(minWidth: minWidth, maxWidth: maxWidth);
    final linkSize = textPainter.size;

    textPainter.text = text;
    textPainter.layout(minWidth: minWidth, maxWidth: maxWidth);
    final textSize = textPainter.size;

    int? endIndex;
    if (linkSize.width < maxWidth) {
      final pos = textPainter.getPositionForOffset(
        Offset(
          textSize.width - linkSize.width,
          textSize.height,
        ),
      );
      endIndex = textPainter.getOffsetBefore(pos.offset);
    } else {
      final pos = textPainter.getPositionForOffset(textSize.bottomLeft(Offset.zero));
      endIndex = pos.offset;
    }

    TextSpan textSpan;
    switch (widget.trimMode) {
      case AgoraTrimMode.length:
        if (widget.trimLength < data.length) {
          textSpan = TextSpan(
            style: textStyle,
            text: _readMore ? data.substring(0, widget.trimLength) : data,
            children: [readMoreButton],
          );
        } else {
          textSpan = TextSpan(
            style: textStyle,
            text: data,
          );
        }
        break;
      case AgoraTrimMode.line:
        if (textPainter.didExceedMaxLines) {
          textSpan = TextSpan(
            style: textStyle,
            text: _readMore ? "${data.substring(0, endIndex)} ...\n\n" : "$data\n\n",
            children: <TextSpan>[readMoreButton],
          );
        } else {
          textSpan = TextSpan(style: textStyle, text: data);
        }
        break;
    }

    return RichText(textAlign: textAlign, textDirection: textDirection, text: textSpan);
  }
}
