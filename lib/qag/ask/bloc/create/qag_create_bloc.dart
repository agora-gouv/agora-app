import 'package:agora/qag/ask/bloc/create/qag_create_event.dart';
import 'package:agora/qag/ask/bloc/create/qag_create_state.dart';
import 'package:agora/qag/repository/qag_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CreateQagBloc extends Bloc<AskQagEvent, CreateQagState> {
  final QagRepository qagRepository;

  CreateQagBloc({required this.qagRepository}) : super(CreateQagInitialState()) {
    on<CreateQagEvent>(_handleCreateQag);
  }

  Future<void> _handleCreateQag(
    CreateQagEvent event,
    Emitter<CreateQagState> emit,
  ) async {
    emit(CreateQagLoadingState());
    final response = await qagRepository.createQag(
      title: event.title,
      description: event.description,
      author: event.author,
      thematiqueId: event.thematiqueId,
    );
    if (response is CreateQagSucceedResponse) {
      emit(CreateQagSuccessState(qagId: response.qagId));
    } else if (response is CreateQagFailedUnauthorizedResponse) {
      emit(CreateQagErrorUnauthorizedState());
    } else {
      emit(CreateQagErrorState());
    }
  }
}
