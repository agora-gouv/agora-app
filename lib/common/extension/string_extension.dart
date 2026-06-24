extension StringExtension on String {
  String format(String to) => replaceFirst("%s", to);

  String format2(String to1, String to2) => replaceFirst("%1s", to1).replaceFirst("%2s", to2);

  String format3(String to1, String to2, String to3) =>
      replaceFirst("%1s", to1).replaceFirst("%2s", to2).replaceFirst("%3s", to3);

  String removeDiacritics() {
    var str = this;
    const withDia = 'ÀÁÂÃÄÅàáâãäåÒÓÔÕÕÖØòóôõöøÈÉÊËèéêëðÇçÐÌÍÎÏìíîïÙÚÛÜùúûüÑñŠšŸÿýŽž';
    const withoutDia = 'AAAAAAaaaaaaOOOOOOOooooooEEEEeeeeeCcDIIIIiiiiUUUUuuuuNnSsYyyZz';

    for (int i = 0; i < withDia.length; i++) {
      str = str.replaceAll(withDia[i], withoutDia[i]);
    }

    return str;
  }

  String removePunctuationMark() {
    var str = this;
    const punctuationMark = '-\' ';

    for (int i = 0; i < punctuationMark.length; i++) {
      str = str.replaceAll(punctuationMark[i], "");
    }

    return str;
  }

  String removeHtmlTags() => replaceAll(RegExp(r'<[^>]*>'), "");
}

extension NullableStringExtensions on String? {
  bool isNullOrBlank() => this == null || this!.trim().isEmpty;

  bool isNotBlank() => this == null ? false : this!.trim().isNotEmpty;
}

extension NotNullableStringExtension on String {
  bool isNotBlank() => trim().isNotEmpty;
}
