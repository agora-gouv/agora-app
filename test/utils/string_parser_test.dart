import 'package:agora/pages/consultation/dynamic/string_parser.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('avec emoji', () {
    // GIVEN
    const String toParse = 'Je contiens un émoji 😃';

    // WHEN
    final result = StringParser.splitByEmoji(toParse);

    // THEN
    final expected = [
      StringSegment("Je contiens un émoji ", false),
      StringSegment("😃", true),
    ];
    expect(result.length, expected.length);
    for (int i = 0; i < expected.length; i++) {
      expect(result[i].text, expected[i].text);
      expect(result[i].isEmoji, expected[i].isEmoji);
    }
  });

  test('sans emoji', () {
    // GIVEN
    const String toParse = "Je contiens pas d'émoji";

    // WHEN
    final result = StringParser.splitByEmoji(toParse);

    // THEN
    final expected = [
      StringSegment("Je contiens pas d'émoji", false),
    ];
    expect(result.length, expected.length);
    for (int i = 0; i < expected.length; i++) {
      expect(result[i].text, expected[i].text);
      expect(result[i].isEmoji, expected[i].isEmoji);
    }
  });

  test("avec plein d'émojis", () {
    // GIVEN
    const String toParse = "💪Je contiens 👮beaucoup d'émojis 🤔";

    // WHEN
    final result = StringParser.splitByEmoji(toParse);

    // THEN
    final expected = [
      StringSegment("💪", true),
      StringSegment("Je contiens ", false),
      StringSegment("👮", true),
      StringSegment("beaucoup d'émojis ", false),
      StringSegment("🤔", true),
    ];
    expect(result.length, expected.length);
    for (int i = 0; i < expected.length; i++) {
      expect(result[i].text, expected[i].text);
      expect(result[i].isEmoji, expected[i].isEmoji);
    }
  });
}
