import 'package:diacritic/diacritic.dart';

class StringUtils {
  static const String authorAndDate = "De %1s - le %2s";

  static final _specialCharactersRegex = RegExp(r'[^\w\s]+');

  static String replaceDiacriticsAndRemoveSpecialChars(String originText) {
    return removeDiacritics(originText).replaceAll(_specialCharactersRegex, '');
  }
}

extension StringExtensionUtils on String {
  String substringBefore(Pattern pattern) {
    return substring(0, indexOf(pattern));
  }

  String substringAfter(Pattern pattern, {bool includePattern = false}) {
    final indexOf2 = indexOf(pattern);
    return substring(includePattern ? indexOf2 : indexOf2 + pattern.toString().length);
  }
}
