import 'package:equatable/equatable.dart';

class PopupQagViewModel extends Equatable {
  final String title;
  final String description;

  PopupQagViewModel({required this.title, required this.description});

  @override
  List<Object?> get props => [title, description];
}
