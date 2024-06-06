import 'package:agora/welcome/bloc/welcome_event.dart';
import 'package:agora/welcome/bloc/welcome_state.dart';
import 'package:agora/welcome/repository/welcome_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class WelcomeBloc extends Bloc<WelcomeEvent, WelcomeState> {
  final WelcomeRepository welcomeRepository;

  WelcomeBloc({
    required this.welcomeRepository,
  }) : super(WelcomeState.init()) {
    on<GetWelcomeALaUneEvent>(_handleGetWelcomeALaUneEvent);
  }

  Future<void> _handleGetWelcomeALaUneEvent(
    GetWelcomeALaUneEvent event,
    Emitter<WelcomeState> emit,
  ) async {
    final welcomeALaUne = await welcomeRepository.getWelcomeALaUne();
    if (welcomeALaUne != null) {
      emit(WelcomeState(status: AllPurposeStatus.success, welcomeALaUne: welcomeALaUne));
    } else {
      emit(WelcomeState(status: AllPurposeStatus.error, welcomeALaUne: null));
    }
  }
}
