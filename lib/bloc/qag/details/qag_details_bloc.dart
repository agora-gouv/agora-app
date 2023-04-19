import 'package:agora/bloc/qag/details/qag_details_event.dart';
import 'package:agora/bloc/qag/details/qag_details_state.dart';
import 'package:agora/common/helper/device_id_helper.dart';
import 'package:agora/infrastructure/qag/presenter/qag_details_presenter.dart';
import 'package:agora/infrastructure/qag/qag_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class QagDetailsBloc extends Bloc<FetchQagDetailsEvent, QagDetailsState> {
  final QagRepository qagRepository;
  final DeviceIdHelper deviceIdHelper;

  QagDetailsBloc({
    required this.qagRepository,
    required this.deviceIdHelper,
  }) : super(QagDetailsInitialLoadingState()) {
    on<FetchQagDetailsEvent>(_handleQagDetails);
  }

  Future<void> _handleQagDetails(
    FetchQagDetailsEvent event,
    Emitter<QagDetailsState> emit,
  ) async {
    final deviceId = await deviceIdHelper.get();
    if (deviceId == null) {
      emit(QagDetailsErrorState());
      return;
    }
    final response = await qagRepository.fetchQagDetails(
      qagId: event.qagId,
      deviceId: deviceId,
    );
    if (response is GetQagDetailsSucceedResponse) {
      final qagDetailsViewModel = QagDetailsPresenter.present(response.qagDetails);
      emit(QagDetailsFetchedState(qagDetailsViewModel));
    } else {
      emit(QagDetailsErrorState());
    }
  }
}
