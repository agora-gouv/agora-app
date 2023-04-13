extension StringExtension on String {
  String format(String to) {
    return replaceFirst("%s", to);
  }

  String format2(String to1, String to2) {
    return replaceFirst("%1s", to1).replaceFirst("%2s", to2);
  }
}
