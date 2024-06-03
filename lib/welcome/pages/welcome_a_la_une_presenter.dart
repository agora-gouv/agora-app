import 'package:agora/welcome/bloc/welcome_state.dart';
import 'package:agora/welcome/pages/welcome_a_la_une_view_model.dart';

class WelcomeALaUnePresenter {
  static WelcomeALaUneViewModel getViewModelFromState(WelcomeState state) {
    return WelcomeALaUneViewModel(
      status: state.status,
      welcomeALaUne: state.welcomeALaUne,
    );
  }
}
