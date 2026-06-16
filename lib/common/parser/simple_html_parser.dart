import 'package:agora/design/custom_view/text/agora_rich_text.dart';
import 'package:equatable/equatable.dart';

class SimpleHtmlData extends Equatable {
  final AgoraRichTextItemStyle style;
  final String text;

  SimpleHtmlData({
    required this.style,
    required this.text,
  });

  @override
  List<Object?> get props => [style, text];
}

List<SimpleHtmlData> parseSimpleHtml(
  String data, {
  AgoraRichTextItemStyle currentStyle = AgoraRichTextItemStyle.regular,
}) {
  if (data.isEmpty) return [];

  if (data.startsWith('<i>')) {
    return parseSimpleHtml(
      data.substring(3),
      currentStyle: currentStyle == AgoraRichTextItemStyle.bold
          ? AgoraRichTextItemStyle.boldItalic
          : AgoraRichTextItemStyle.italic,
    );
  }

  if (data.startsWith('</i>')) {
    return parseSimpleHtml(
      data.substring(4),
      currentStyle: currentStyle == AgoraRichTextItemStyle.boldItalic
          ? AgoraRichTextItemStyle.bold
          : AgoraRichTextItemStyle.regular,
    );
  }

  if (data.startsWith('<b>')) {
    return parseSimpleHtml(
      data.substring(3),
      currentStyle: currentStyle == AgoraRichTextItemStyle.italic
          ? AgoraRichTextItemStyle.boldItalic
          : AgoraRichTextItemStyle.bold,
    );
  }

  if (data.startsWith('</b>')) {
    return parseSimpleHtml(
      data.substring(4),
      currentStyle: currentStyle == AgoraRichTextItemStyle.boldItalic
          ? AgoraRichTextItemStyle.italic
          : AgoraRichTextItemStyle.regular,
    );
  }

  if (data.startsWith('<p>')) {
    return parseSimpleHtml(
      data.substring(3),
      currentStyle: currentStyle,
    );
  }

  if (data.startsWith('</p>')) {
    return [
      SimpleHtmlData(
        style: AgoraRichTextItemStyle.regular,
        text: '\n',
      ),
      ...parseSimpleHtml(
        data.substring(4),
        currentStyle: currentStyle,
      ),
    ];
  }

  final nextTag = data.indexOf('<');

  if (nextTag == -1) {
    return [
      SimpleHtmlData(
        style: currentStyle,
        text: data,
      ),
    ];
  }

  return [
    if (nextTag > 0)
      SimpleHtmlData(
        style: currentStyle,
        text: data.substring(0, nextTag),
      ),
    ...parseSimpleHtml(
      data.substring(nextTag),
      currentStyle: currentStyle,
    ),
  ];
}
