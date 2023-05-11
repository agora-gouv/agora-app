import 'package:equatable/equatable.dart';

class ThematiqueViewModel extends Equatable {
  final String picto;
  final String label;

  ThematiqueViewModel({required this.picto, required this.label});

  @override
  List<Object> get props => [picto, label];
}
