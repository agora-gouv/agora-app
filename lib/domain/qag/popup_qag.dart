import 'package:equatable/equatable.dart';

class PopupQag extends Equatable {
  final String title;
  final String description;

  PopupQag({required this.title, required this.description});

  @override
  List<Object?> get props => [title, description];
}
