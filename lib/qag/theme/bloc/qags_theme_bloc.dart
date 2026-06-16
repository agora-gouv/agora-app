import 'package:agora/common/helper/all_purpose_status.dart';
import 'package:agora/qag/repository/qag_repository.dart';
import 'package:agora/qag/theme/bloc/qags_theme_event.dart';
import 'package:agora/qag/theme/bloc/qags_theme_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class QagsThemeBloc extends Bloc<QagsThemeEvent, QagsThemeState> {
  final QagRepository qagRepository;

  QagsThemeBloc({
    required this.qagRepository,
  }) : super(QagsThemeState.init()) {
    on<FetchQagsThemeEvent>(_handleFetchQagsTheme);
  }

  Future<void> _handleFetchQagsTheme(
    FetchQagsThemeEvent event,
    Emitter<QagsThemeState> emit,
  ) async {
    emit(state.clone(status: AllPurposeStatus.loading));
    final response = await qagRepository.getThemeHebdo();
    if (response is QagThemeHebdoSuccessResponse) {
      emit(
        state.clone(
          status: AllPurposeStatus.success,
          qagThemeHebdo: response.qagThemeHebdo,
        ),
      );
    } else {
      emit(state.clone(status: AllPurposeStatus.error));
    }
  }
}
