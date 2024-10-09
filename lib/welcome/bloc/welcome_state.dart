import 'package:agora/welcome/domain/welcome_a_la_une.dart';
import 'package:equatable/equatable.dart';

enum AllPurposeStatus {
  notLoaded,
  error,
  loading,
  success;
}

class WelcomeState extends Equatable {
  final AllPurposeStatus status;
  final WelcomeALaUne? welcomeALaUne;

  WelcomeState({required this.status, this.welcomeALaUne});

  WelcomeState.init()
      : status = AllPurposeStatus.loading,
        welcomeALaUne = null;

  @override
  List<Object?> get props => [status, welcomeALaUne];
}
