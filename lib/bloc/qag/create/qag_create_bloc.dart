import 'package:agora/bloc/qag/create/qag_create_event.dart';
import 'package:agora/bloc/qag/create/qag_create_state.dart';
import 'package:agora/common/helper/device_info_helper.dart';
import 'package:agora/infrastructure/qag/qag_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CreateQagBloc extends Bloc<CreateQagEvent, CreateQagState> {
  final QagRepository qagRepository;
  final DeviceInfoHelper deviceInfoHelper;

  CreateQagBloc({
    required this.qagRepository,
    required this.deviceInfoHelper,
  }) : super(CreateQagInitialState()) {
    on<CreateQagEvent>(_handleCreateQag);
  }

  Future<void> _handleCreateQag(
    CreateQagEvent event,
    Emitter<CreateQagState> emit,
  ) async {
    emit(CreateQagLoadingState());
    final deviceId = await deviceInfoHelper.getDeviceId();
    if (deviceId == null) {
      emit(CreateQagErrorState());
      return;
    }
    final response = await qagRepository.createQag(
      deviceId: deviceId,
      title: event.title,
      description: event.description,
      author: event.author,
      thematiqueId: event.thematiqueId,
    );
    if (response is CreateQagSucceedResponse) {
      emit(CreateQagSuccessState());
    } else {
      emit(CreateQagErrorState());
    }
  }
}
