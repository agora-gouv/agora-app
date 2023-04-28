import 'package:equatable/equatable.dart';

class ThematiqueWithId extends Equatable {
  final String id;
  final String picto;
  final String label;
  final String color;

  ThematiqueWithId({required this.id, required this.picto, required this.label, required this.color});

  @override
  List<Object?> get props => [id, picto, label, color];
}
