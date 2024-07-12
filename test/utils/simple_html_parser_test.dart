import 'package:agora/design/custom_view/agora_rich_text.dart';
import 'package:agora/common/parser/simple_html_parser.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('sans html', () {
    const String toParse = 'Je ne contient pas de HTML';

    final expected = [
      SimpleHtmlData(style: AgoraRichTextItemStyle.regular, text: toParse),
    ];

    expect(parseSimpleHtml(toParse), expected);
  });

  test('seulement du bold html', () {
    const String toParse = 'Je contient <b>du bold</b> dans mon HTML';

    final expected = [
      SimpleHtmlData(style: AgoraRichTextItemStyle.regular, text: 'Je contient '),
      SimpleHtmlData(style: AgoraRichTextItemStyle.bold, text: 'du bold'),
      SimpleHtmlData(style: AgoraRichTextItemStyle.regular, text: ' dans mon HTML'),
    ];

    expect(parseSimpleHtml(toParse), expected);
  });

  test('seulement du italic html', () {
    const String toParse = 'Je contient <i>du bold</i> dans mon HTML';

    final expected = [
      SimpleHtmlData(style: AgoraRichTextItemStyle.regular, text: 'Je contient '),
      SimpleHtmlData(style: AgoraRichTextItemStyle.italic, text: 'du bold'),
      SimpleHtmlData(style: AgoraRichTextItemStyle.regular, text: ' dans mon HTML'),
    ];

    expect(parseSimpleHtml(toParse), expected);
  });
}
