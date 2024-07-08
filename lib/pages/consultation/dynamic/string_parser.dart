import 'package:equatable/equatable.dart';

class StringParser {
  static List<StringSegment> splitByEmoji(String input) {
    final regex =
        RegExp(r'(\u00a9|\u00ae|[\u2000-\u3300]|\ud83c[\ud000-\udfff]|\ud83d[\ud000-\udfff]|\ud83e[\ud000-\udfff])');
    final matches = regex.allMatches(input);

    if (matches.isEmpty) {
      return [StringSegment(input, false)];
    }

    final List<StringSegment> result = [];
    int previousEnd = 0;
    for (var match in matches) {
      if (match.start > previousEnd) {
        result.add(StringSegment(input.substring(previousEnd, match.start), false));
      }
      result.add(StringSegment(input.substring(match.start, match.end), true));
      previousEnd = match.end;
    }
    if (previousEnd < input.length) {
      result.add(StringSegment(input.substring(previousEnd), false));
    }
    return result;
  }
}

class StringSegment extends Equatable {
  final String text;
  final bool isEmoji;

  StringSegment(this.text, this.isEmoji);

  @override
  List<Object?> get props => [text, isEmoji];
}
