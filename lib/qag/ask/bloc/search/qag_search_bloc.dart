import 'package:agora/qag/ask/bloc/search/qag_search_event.dart';
import 'package:agora/qag/ask/bloc/search/qag_search_state.dart';
import 'package:agora/qag/domain/qag_list_extension.dart';
import 'package:agora/qag/repository/qag_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class QagSearchBloc extends Bloc<QagSearchEvent, QagSearchState> {
  final QagRepository qagRepository;

  QagSearchBloc({
    required this.qagRepository,
  }) : super(QagSearchInitialState()) {
    on<FetchQagsInitialEvent>(_handleInitialQagsSearch);
    on<FetchQagsLoadingEvent>(_handleLoadingQagsSearch);
    on<FetchQagsSearchEvent>(_handleFetchQagsSearch);
    on<UpdateQagSearchSupportEvent>(_handleUpdateQagSupport);
  }

  Future<void> _handleInitialQagsSearch(
    FetchQagsInitialEvent event,
    Emitter<QagSearchState> emit,
  ) async {
    emit(QagSearchInitialState());
  }

  Future<void> _handleLoadingQagsSearch(
    FetchQagsLoadingEvent event,
    Emitter<QagSearchState> emit,
  ) async {
    emit(QagSearchLoadingState());
  }

  Future<void> _handleFetchQagsSearch(
    FetchQagsSearchEvent event,
    Emitter<QagSearchState> emit,
  ) async {
    final response = await qagRepository.fetchSearchQags(keywords: event.keywords);
    if (response is GetSearchQagsSucceedResponse) {
      emit(
        QagSearchLoadedState(
          qags: response.searchQags,
        ),
      );
    } else {
      emit(
        QagSearchErrorState(),
      );
    }
  }

  Future<void> _handleUpdateQagSupport(
    UpdateQagSearchSupportEvent event,
    Emitter<QagSearchState> emit,
  ) async {
    if (state is QagSearchLoadedState) {
      final newQagList = (state as QagSearchLoadedState).qags.updateQagSupportOrNull(event.qagSupport);
      if (newQagList != null) {
        emit(QagSearchLoadedState(qags: newQagList));
      }
    }
  }
}
