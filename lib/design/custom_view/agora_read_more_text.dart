import 'package:agora/common/strings/qag_strings.dart';
import 'package:agora/design/style/agora_colors.dart';
import 'package:agora/design/style/agora_spacings.dart';
import 'package:agora/design/style/agora_text_styles.dart';
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
  final TextStyle trimTextStyle;
  final TextAlign textAlign;
  final TextDirection textDirection;

  const AgoraReadMoreText(
    this.data, {
    Key? key,
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
  })  : assert(
          (trimMode == AgoraTrimMode.line && trimLines > 0) || (trimMode == AgoraTrimMode.length && trimLength > 0),
        ),
        super(key: key);

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

    const ellipsisText = " ...";
    final data = widget.data;
    final text = TextSpan(style: textStyle, text: data);

    final readMoreButton = TextSpan(
      text: _readMore ? widget.trimExpandedText : widget.trimCollapsedText,
      style: widget.trimTextStyle.copyWith(color: colorClickableText),
      recognizer: TapGestureRecognizer()..onTap = _onReadMoreLink,
    );

    // calculate "Lire la suite" text size
    final TextPainter textPainter = TextPainter(
      text: readMoreButton,
      textAlign: textAlign,
      textDirection: textDirection,
      maxLines: widget.trimLines,
      locale: Localizations.localeOf(context),
    );
    textPainter.layout(minWidth: minWidth, maxWidth: maxWidth);
    final linkSize = textPainter.size;

    // calculate " ..." text size
    textPainter.text = TextSpan(style: textStyle, text: ellipsisText);
    textPainter.layout(minWidth: minWidth, maxWidth: maxWidth);
    final ellipsisSize = textPainter.size;

    // calculate data text size
    textPainter.text = text;
    textPainter.layout(minWidth: minWidth, maxWidth: maxWidth);
    final textSize = textPainter.size;

    int? endIndex;
    if (linkSize.width < maxWidth) {
      final pos = textPainter.getPositionForOffset(
        Offset(
          textSize.width - ellipsisSize.width,
          // textSize.width - ellipsisSize.width - linkSize.width, // need this when "Lire la suite" is at the end of the text (not in new line)
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
          textSpan = TextSpan(style: textStyle, text: data);
        }
        break;
      case AgoraTrimMode.line:
        if (textPainter.didExceedMaxLines) {
          textSpan = TextSpan(
            style: textStyle,
            text: _readMore ? "${data.substring(0, endIndex)}$ellipsisText\n\n" : "$data\n\n",
            children: <TextSpan>[readMoreButton],
          );
        } else {
          textSpan = TextSpan(style: textStyle, text: data);
        }
        break;
    }

    return Semantics(
      label: data,
      child: ExcludeSemantics(
        child: RichText(
          textScaler: MediaQuery.of(context).textScaler,
          textAlign: textAlign,
          textDirection: textDirection,
          text: textSpan,
        ),
      ),
    );
  }
}
