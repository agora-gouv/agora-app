import 'package:agora/bloc/qag/list/qag_list_event.dart';
import 'package:agora/bloc/qag/list/qag_list_state.dart';
import 'package:agora/domain/qag/qas_list_filter.dart';
import 'package:agora/infrastructure/qag/qag_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class QagListBloc extends Bloc<QagListEvent, QagListState> {
  final QagRepository qagRepository;
  final QagListFilter qagFilter;

  QagListBloc({
    required this.qagRepository,
    required this.qagFilter,
  }) : super(QagListInitialState()) {
    on<FetchQagsEvent>(_handleFetchQags);
  }

  Future<void> _handleFetchQags(
    FetchQagsEvent event,
    Emitter<QagListState> emit,
  ) async {
    emit(QagListInitialState());

    final response = await qagRepository.fetchQagList(
      pageNumber: 1,
      thematiqueId: null,
      filter: qagFilter,
    );

    if (response is GetQagListSucceedResponse) {
      emit(
        QagListLoadedState(
          qags: response.qags,
        ),
      );
    } else {
      emit(QagListErrorState());
    }
  }
}
