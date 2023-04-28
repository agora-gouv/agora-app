import 'package:equatable/equatable.dart';

class ThematiqueViewModel extends Equatable {
  final String picto;
  final String label;
  final int color;

  ThematiqueViewModel({required this.picto, required this.label, required this.color});

  @override
  List<Object> get props => [picto, label, color];
}
