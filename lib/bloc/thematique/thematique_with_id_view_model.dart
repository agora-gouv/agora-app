import 'package:equatable/equatable.dart';

class ThematiqueWithIdViewModel extends Equatable {
  final String? id;
  final String picto;
  final String label;

  ThematiqueWithIdViewModel({required this.id, required this.picto, required this.label});

  @override
  List<Object?> get props => [id, picto, label];
}
