import 'package:agora/common/parser/simple_html_parser.dart';
import 'package:agora/design/custom_view/text/agora_rich_text.dart';
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
    const String toParse = 'Je contiens <b>du bold</b> dans mon HTML';

    final expected = [
      SimpleHtmlData(style: AgoraRichTextItemStyle.regular, text: 'Je contiens '),
      SimpleHtmlData(style: AgoraRichTextItemStyle.bold, text: 'du bold'),
      SimpleHtmlData(style: AgoraRichTextItemStyle.regular, text: ' dans mon HTML'),
    ];

    expect(parseSimpleHtml(toParse), expected);
  });

  test('seulement du italic html', () {
    const String toParse = "Je contiens <i>de l'italic</i> dans mon HTML";

    final expected = [
      SimpleHtmlData(style: AgoraRichTextItemStyle.regular, text: 'Je contiens '),
      SimpleHtmlData(style: AgoraRichTextItemStyle.italic, text: "de l'italic"),
      SimpleHtmlData(style: AgoraRichTextItemStyle.regular, text: ' dans mon HTML'),
    ];

    expect(parseSimpleHtml(toParse), expected);
  });

  test('une balise inconnue', () {
    const String toParse = '<br>Je contiens une balise inconnue <b>du bold</b> dans mon HTML';

    final expected = [
      SimpleHtmlData(
          style: AgoraRichTextItemStyle.regular, text: 'Je contiens une balise inconnue du bold dans mon HTML')
    ];

    expect(parseSimpleHtml(toParse), expected);
  });
}
