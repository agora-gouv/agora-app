import 'package:diacritic/diacritic.dart';

class StringUtils {
  static final _specialCharactersRegex = RegExp(r'[^\w\s]+');

  static String replaceDiacriticsAndRemoveSpecialChars(String originText) {
    return removeDiacritics(originText).replaceAll(_specialCharactersRegex, '');
  }
}
