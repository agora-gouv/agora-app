import 'package:agora/design/style/agora_spacings.dart';
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

abstract class AgoraRichTextItem {}

class AgoraRichTextSpaceItem extends AgoraRichTextItem {}

class AgoraRichTextTextItem extends AgoraRichTextItem {
  final String text;
  final AgoraRichTextItemStyle style;

  AgoraRichTextTextItem({
    required this.text,
    required this.style,
  });
}

class AgoraRichText extends StatelessWidget {
  final AgoraRichTextPoliceStyle policeStyle;
  final List<AgoraRichTextItem> items;

  AgoraRichText({
    super.key,
    this.policeStyle = AgoraRichTextPoliceStyle.section,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    return RichText(
      textScaleFactor: MediaQuery.of(context).textScaleFactor,
      text: TextSpan(
        style: _buildRegularStyle(),
        children: items.map((item) {
          if (item is AgoraRichTextTextItem) {
            switch (item.style) {
              case AgoraRichTextItemStyle.regular:
                return TextSpan(text: item.text);
              case AgoraRichTextItemStyle.bold:
                return TextSpan(text: item.text, style: _buildBoldStyle());
            }
          } else {
            return WidgetSpan(child: SizedBox(width: AgoraSpacings.x0_25));
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
