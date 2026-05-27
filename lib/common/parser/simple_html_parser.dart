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

List<SimpleHtmlData> parseSimpleHtml(String data) {
  if (data.isEmpty) return [];
  if (data.startsWith('<i>')) {
    final end = data.indexOf('</i>');
    if (end == -1) {
      return [
        SimpleHtmlData(
          style: AgoraRichTextItemStyle.regular,
          text: data,
        ),
      ];
    }
    return [
      SimpleHtmlData(
        style: AgoraRichTextItemStyle.italic,
        text: data.substring(3, end),
      ),
      ...parseSimpleHtml(data.substring(end + 4)),
    ];
  }
  if (data.startsWith('<b>')) {
    final end = data.indexOf('</b>');
    if (end == -1) {
      return [
        SimpleHtmlData(
          style: AgoraRichTextItemStyle.regular,
          text: data,
        ),
      ];
    }
    return [
      SimpleHtmlData(
        style: AgoraRichTextItemStyle.bold,
        text: data.substring(3, end),
      ),
      ...parseSimpleHtml(data.substring(end + 4)),
    ];
  }
  if (data.startsWith('<p>')) {
    return parseSimpleHtml(data.substring(3));
  }
  if (data.startsWith('</p>')) {
    return [
      SimpleHtmlData(
        style: AgoraRichTextItemStyle.regular,
        text: '\n',
      ),
      ...parseSimpleHtml(data.substring(4)),
    ];
  }
  final nextTag = data.indexOf('<');
  if (nextTag == -1) {
    return [
      SimpleHtmlData(
        style: AgoraRichTextItemStyle.regular,
        text: data,
      ),
    ];
  }
  return [
    SimpleHtmlData(
      style: AgoraRichTextItemStyle.regular,
      text: data.substring(0, nextTag),
    ),
    ...parseSimpleHtml(data.substring(nextTag)),
  ];
}
