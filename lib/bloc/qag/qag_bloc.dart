import 'package:agora/bloc/qag/qag_event.dart';
import 'package:agora/bloc/qag/qag_state.dart';
import 'package:agora/common/helper/device_info_helper.dart';
import 'package:agora/infrastructure/qag/presenter/qag_presenter.dart';
import 'package:agora/infrastructure/qag/qag_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class QagBloc extends Bloc<FetchQagsEvent, QagState> {
  final QagRepository qagRepository;
  final DeviceInfoHelper deviceIdHelper;

  QagBloc({
    required this.qagRepository,
    required this.deviceIdHelper,
  }) : super(QagInitialLoadingState()) {
    on<FetchQagsEvent>(_handleQag);
  }

  Future<void> _handleQag(
    FetchQagsEvent event,
    Emitter<QagState> emit,
  ) async {
    final deviceId = await deviceIdHelper.getDeviceId();
    if (deviceId == null) {
      emit(QagErrorState());
      return;
    }
    final response = await qagRepository.fetchQags(deviceId: deviceId);
    if (response is GetQagsSucceedResponse) {
      final qagViewModel = QagPresenter.present(response.qagResponses);
      emit(QagFetchedState(qagViewModel));
    } else {
      emit(QagErrorState());
    }
  }
}
