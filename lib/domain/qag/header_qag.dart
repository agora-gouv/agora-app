import 'package:equatable/equatable.dart';

class HeaderQag extends Equatable {
  final String id;
  final String title;
  final String message;

  HeaderQag({
    required this.id,
    required this.title,
    required this.message,
  });

  @override
  List<Object?> get props => [id, title, message];
}
