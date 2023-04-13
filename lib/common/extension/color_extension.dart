extension ColorExtension on String {
  int toColorInt() {
    var hexColor = replaceAll("#", "");
    if (hexColor.length == 6) {
      hexColor = "FF$hexColor";
    }
    return int.parse("0x$hexColor");
  }
}
