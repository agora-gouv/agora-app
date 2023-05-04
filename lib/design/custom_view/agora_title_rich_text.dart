import 'package:agora/design/style/agora_text_styles.dart';
import 'package:flutter/material.dart';

enum AgoraRichTextPoliceStyle { toolbar, section }

enum AgoraRichTextItemStyle { bold, regular }

class AgoraRichTextItem {
  final String text;
  final AgoraRichTextItemStyle style;

  AgoraRichTextItem({
    required this.text,
    required this.style,
  });
}

class AgoraRichText extends StatelessWidget {
  final AgoraRichTextPoliceStyle policeStyle;
  final List<AgoraRichTextItem> items;

  AgoraRichText({
    this.policeStyle = AgoraRichTextPoliceStyle.section,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    return RichText(
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
    );
  }

  TextStyle _buildRegularStyle() {
    switch (policeStyle) {
      case AgoraRichTextPoliceStyle.toolbar:
        return AgoraTextStyles.light24.copyWith(height: 1.2);
      case AgoraRichTextPoliceStyle.section:
        return AgoraTextStyles.light18.copyWith(height: 1.2);
    }
  }

  TextStyle _buildBoldStyle() {
    switch (policeStyle) {
      case AgoraRichTextPoliceStyle.toolbar:
        return AgoraTextStyles.bold24.copyWith(height: 1.2);
      case AgoraRichTextPoliceStyle.section:
        return AgoraTextStyles.bold18.copyWith(height: 1.2);
    }
  }
}
