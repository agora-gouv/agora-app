import 'package:agora/common/log/log.dart';
import 'package:agora/common/strings/string_utils.dart';
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
  if (data.startsWith('<')) {
    if (data.startsWith('<i>')) {
      return [
        SimpleHtmlData(
          style: AgoraRichTextItemStyle.italic,
          text: data.substring(3, data.length).substringBefore('</i>'),
        ),
        ...parseSimpleHtml(data.substringAfter('</i>', includePattern: false)),
      ];
    } else if (data.startsWith('<b>')) {
      return [
        SimpleHtmlData(
          style: AgoraRichTextItemStyle.bold,
          text: data.substring(3, data.length).substringBefore('</b>'),
        ),
        ...parseSimpleHtml(data.substringAfter('</b>', includePattern: false)),
      ];
    } else {
      Log.warning("Erreur dans le HTML : $data");
      return [SimpleHtmlData(style: AgoraRichTextItemStyle.regular, text: data.replaceAll(RegExp(r'<.*?>'), ""))];
    }
  } else if (data.contains('<')) {
    return [
      SimpleHtmlData(style: AgoraRichTextItemStyle.regular, text: data.substringBefore('<')),
      ...parseSimpleHtml(data.substringAfter('<', includePattern: true)),
    ];
  }
  return [SimpleHtmlData(style: AgoraRichTextItemStyle.regular, text: data)];
}
