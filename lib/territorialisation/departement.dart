import 'package:agora/territorialisation/territoire.dart';
import 'package:equatable/equatable.dart';

class Departement extends Equatable implements Territoire {
  @override
  final String label;

  Departement({required this.label});

  @override
  TerritoireType get type => TerritoireType.departemental;

  @override
  List<Object?> get props => [label];
}
