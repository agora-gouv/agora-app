import 'package:diacritic/diacritic.dart';

class StringUtils {
  static final _specialCharactersRegex = RegExp(r'[^\w\s]+');

  static String replaceDiacriticsAndRemoveSpecialChars(String originText) {
    return removeDiacritics(originText).replaceAll(_specialCharactersRegex, '');
  }
}

extension StringExtensionUtils on String {
  String substringBefore(String pattern) {
    return substring(0, indexOf(pattern));
  }

  String substringAfter(String pattern, {bool includePattern = false}) {
    final indexOf2 = indexOf(pattern);
    return substring(includePattern ? indexOf2 : indexOf2 + pattern.length);
  }
}
