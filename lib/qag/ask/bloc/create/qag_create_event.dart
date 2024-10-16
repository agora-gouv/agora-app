import 'package:equatable/equatable.dart';

abstract class AskQagEvent extends Equatable {
  const AskQagEvent();
}

class CreateQagEvent extends AskQagEvent {
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
