import 'package:equatable/equatable.dart';

class Thematique extends Equatable {
  final String picto;
  final String label;
  final String color;

  Thematique({required this.picto, required this.label, required this.color});

  @override
  List<Object?> get props => [picto, label, color];
}
