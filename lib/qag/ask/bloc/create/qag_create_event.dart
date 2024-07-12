import 'package:equatable/equatable.dart';

class CreateQagEvent extends Equatable {
  final String title;
  final String description;
  final String author;
  final String thematiqueId;

  CreateQagEvent({
    required this.title,
    required this.description,
    required this.author,
    required this.thematiqueId,
  });

  @override
  List<Object> get props => [
        title,
        description,
        author,
        thematiqueId,
      ];
}
