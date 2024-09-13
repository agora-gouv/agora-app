import 'package:agora/territorialisation/territoire.dart';
import 'package:equatable/equatable.dart';

class Pays<T extends Territoire> extends Equatable implements Territoire {
  @override
  final String label;

  Pays({required this.label});

  @override
  TerritoireType get type => TerritoireType.national;

  @override
  List<Object?> get props => [label];
}
