import 'package:agora/design/style/agora_text_styles.dart';
import 'package:flutter/material.dart';

enum AgoraRichTextPoliceStyle {
  toolbar,
  section,
  police14,
  police22,
  police28,
}

enum AgoraRichTextItemStyle { bold, regular }

class AgoraRichTextItem {
  final String text;
  final AgoraRichTextItemStyle style;

  AgoraRichTextItem({
    required this.text,
    required this.style,
  });
}

class AgoraRichTextSemantic {
  final bool header;
  final bool? focused;

  const AgoraRichTextSemantic({this.header = true, this.focused});
}

class AgoraRichText extends StatelessWidget {
  final AgoraRichTextPoliceStyle policeStyle;
  final List<AgoraRichTextItem> items;
  final AgoraRichTextSemantic semantic;
  final TextAlign textAlign;

  AgoraRichText({
    super.key,
    this.policeStyle = AgoraRichTextPoliceStyle.section,
    required this.items,
    this.semantic = const AgoraRichTextSemantic(),
    this.textAlign = TextAlign.start,
  });

  @override
  Widget build(BuildContext context) {
    return Semantics(
      header: semantic.header,
      focused: semantic.focused,
      label: items.map((richTextItem) => richTextItem.text.replaceAll("\n", " ")).join(),
      child: ExcludeSemantics(
        child: RichText(
          textScaler: MediaQuery.of(context).textScaler,
          text: TextSpan(
            style: _buildRegularStyle(),
            children: items.map((item) {
              switch (item.style) {
                case AgoraRichTextItemStyle.regular:
                  return TextSpan(text: item.text);
                case AgoraRichTextItemStyle.bold:
                  return TextSpan(text: item.text, style: _buildBoldStyle());
              }
            }).toList(),
          ),
          textAlign: textAlign,
        ),
      ),
    );
  }

  TextStyle _buildRegularStyle() {
    switch (policeStyle) {
      case AgoraRichTextPoliceStyle.toolbar:
        return AgoraTextStyles.light24.copyWith(height: 1.2);
      case AgoraRichTextPoliceStyle.section:
        return AgoraTextStyles.light18.copyWith(height: 1.2);
      case AgoraRichTextPoliceStyle.police14:
        return AgoraTextStyles.light14.copyWith(height: 1.2);
      case AgoraRichTextPoliceStyle.police22:
        return AgoraTextStyles.light22.copyWith(height: 1.2);
      case AgoraRichTextPoliceStyle.police28:
        return AgoraTextStyles.light28.copyWith(height: 1.2);
    }
  }

  TextStyle _buildBoldStyle() {
    switch (policeStyle) {
      case AgoraRichTextPoliceStyle.toolbar:
        return AgoraTextStyles.bold24.copyWith(height: 1.2);
      case AgoraRichTextPoliceStyle.section:
        return AgoraTextStyles.bold18.copyWith(height: 1.2);
      case AgoraRichTextPoliceStyle.police14:
        return AgoraTextStyles.bold14.copyWith(height: 1.2);
      case AgoraRichTextPoliceStyle.police22:
        return AgoraTextStyles.bold22.copyWith(height: 1.2);
      case AgoraRichTextPoliceStyle.police28:
        return AgoraTextStyles.bold28.copyWith(height: 1.2);
    }
  }
}
