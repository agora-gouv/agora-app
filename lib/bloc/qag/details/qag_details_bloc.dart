import 'package:agora/bloc/qag/details/qag_details_event.dart';
import 'package:agora/bloc/qag/details/qag_details_state.dart';
import 'package:agora/bloc/qag/details/qag_details_view_model.dart';
import 'package:agora/infrastructure/qag/presenter/qag_details_presenter.dart';
import 'package:agora/infrastructure/qag/qag_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class QagDetailsBloc extends Bloc<QagDetailsEvent, QagDetailsState> {
  final QagRepository qagRepository;

  QagDetailsBloc({required this.qagRepository}) : super(QagDetailsInitialLoadingState()) {
    on<FetchQagDetailsEvent>(_handleQagDetails);
    on<SendFeedbackEvent>(_handleQagFeedback);
  }

  Future<void> _handleQagDetails(
    FetchQagDetailsEvent event,
    Emitter<QagDetailsState> emit,
  ) async {
    final response = await qagRepository.fetchQagDetails(qagId: event.qagId);
    if (response is GetQagDetailsSucceedResponse) {
      final qagDetailsViewModel = QagDetailsPresenter.present(response.qagDetails);
      emit(QagDetailsFetchedState(qagDetailsViewModel));
    } else if (response is GetQagDetailsModerateFailedResponse) {
      emit(QagDetailsModerateErrorState());
    } else {
      emit(QagDetailsErrorState());
    }
  }

  Future<void> _handleQagFeedback(
    SendFeedbackEvent event,
    Emitter<QagDetailsState> emit,
  ) async {
    if (state is QagDetailsFetchedState) {
      final fetchedState = state as QagDetailsFetchedState;

      if (fetchedState.viewModel.feedback != null) {
        if (fetchedState.viewModel.feedback is QagDetailsFeedbackNotAnsweredViewModel) {
          emit(
            QagDetailsFetchedState(
              QagDetailsViewModel.copyWithNewFeedback(
                viewModel: fetchedState.viewModel,
                feedback: QagDetailsFeedbackLoadingViewModel(),
              ),
            ),
          );

          final response = await qagRepository.giveQagResponseFeedback(
            qagId: event.qagId,
            isHelpful: event.isHelpful,
          );

          if (response is QagFeedbackSuccessResponse) {
            final oldFeedbackViewModel = fetchedState.viewModel.feedback as QagDetailsFeedbackNotAnsweredViewModel;
            final newFeedbackViewModel = oldFeedbackViewModel.feedbackResults != null
                ? QagDetailsFeedbackAnsweredResultsViewModel(feedbackResults: oldFeedbackViewModel.feedbackResults!)
                : QagDetailsFeedbackAnsweredNoResultsViewModel();

            emit(
              QagDetailsFetchedState(
                QagDetailsViewModel.copyWithNewFeedback(
                  viewModel: fetchedState.viewModel,
                  feedback: newFeedbackViewModel,
                ),
              ),
            );
            // emit(QagFeedbackSuccessState());
          } else {
            emit(
              QagDetailsFetchedState(
                QagDetailsViewModel.copyWithNewFeedback(
                  viewModel: fetchedState.viewModel,
                  feedback: QagDetailsFeedbackErrorViewModel(),
                ),
              ),
            );
            // emit(QagFeedbackErrorState());
          }
        }
      }
    }
  }
}
