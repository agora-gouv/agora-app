abstract class Territoire {
  final String label;

  Territoire({required this.label});

  TerritoireType get type;
}

enum TerritoireType {
  national,
  regional,
  departemental,
}
