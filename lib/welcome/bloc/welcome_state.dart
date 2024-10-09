import 'package:agora/common/helper/all_purpose_status.dart';
import 'package:agora/welcome/domain/welcome_a_la_une.dart';
import 'package:equatable/equatable.dart';

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
