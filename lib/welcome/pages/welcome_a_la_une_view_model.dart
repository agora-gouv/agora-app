import 'package:agora/welcome/bloc/welcome_state.dart';
import 'package:agora/welcome/domain/welcome_a_la_une.dart';
import 'package:equatable/equatable.dart';

class WelcomeALaUneViewModel extends Equatable {
  final AllPurposeStatus status;
  final WelcomeALaUne? welcomeALaUne;

  const WelcomeALaUneViewModel({
    required this.status,
    this.welcomeALaUne,
  });

  @override
  List<Object?> get props => [status, welcomeALaUne];
}
