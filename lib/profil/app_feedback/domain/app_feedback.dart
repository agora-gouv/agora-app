import 'package:equatable/equatable.dart';

class AppFeedback extends Equatable {
  final AppFeedbackType type;
  final String description;

  AppFeedback({
    required this.type,
    required this.description,
  });

  @override
  List<Object?> get props => [type, description];
}

enum AppFeedbackType {
  bug,
  feature,
  comment,
}
