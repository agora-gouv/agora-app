import 'package:equatable/equatable.dart';

class Thematique extends Equatable {
  final String picto;
  final String label;

  Thematique({required this.picto, required this.label});

  @override
  List<Object?> get props => [picto, label];
}
