import 'package:agora/referentiel/territoire.dart';
import 'package:equatable/equatable.dart';

class Departement extends Equatable implements Territoire {
  @override
  final String label;
  final String codePostal;

  Departement({required this.label, required this.codePostal});

  String get displayLabel => "$codePostal - $label";

  @override
  TerritoireType get type => TerritoireType.departemental;

  @override
  List<Object?> get props => [label, codePostal];
}
