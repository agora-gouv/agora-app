import 'package:agora/referentiel/departement.dart';
import 'package:agora/referentiel/territoire.dart';
import 'package:equatable/equatable.dart';

class Region<T extends Territoire> extends Equatable implements Territoire {
  @override
  final String label;
  final List<Departement> departements;

  Region({required this.label, required this.departements});

  @override
  TerritoireType get type => TerritoireType.regional;

  @override
  List<Object?> get props => [label, departements];
}
