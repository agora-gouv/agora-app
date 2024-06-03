import 'package:equatable/equatable.dart';

class WelcomeALaUne extends Equatable {
  final String description;
  final String actionText;
  final String routeName;
  final String? routeArgument;

  const WelcomeALaUne({
    required this.description,
    required this.actionText,
    required this.routeName,
    this.routeArgument,
  });

  @override
  List<Object?> get props => [description, actionText, routeName, routeArgument];
}
