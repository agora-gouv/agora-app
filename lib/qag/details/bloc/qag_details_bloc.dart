import 'package:agora/qag/details/bloc/qag_details_event.dart';
import 'package:agora/qag/details/bloc/qag_details_state.dart';
import 'package:agora/qag/details/bloc/qag_details_view_model.dart';
import 'package:agora/qag/repository/presenter/qag_details_presenter.dart';
import 'package:agora/qag/repository/qag_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class QagDetailsBloc extends Bloc<QagDetailsEvent, QagDetailsState> {
  final QagRepository qagRepository;
  final Duration feedbackLoadingDuration;

  QagDetailsBloc({required this.qagRepository, this.feedbackLoadingDuration = const Duration(seconds: 2)})
      : super(QagDetailsInitialLoadingState()) {
    on<FetchQagDetailsEvent>(_handleQagDetails);
    on<SendFeedbackQagDetailsEvent>(_handleQagFeedback);
    on<EditFeedbackQagDetailsEvent>(_handleEditFeedback);
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
    SendFeedbackQagDetailsEvent event,
    Emitter<QagDetailsState> emit,
  ) async {
    if (state is QagDetailsFetchedState) {
      final fetchedState = state as QagDetailsFetchedState;

      if (fetchedState.viewModel.feedback != null) {
        if (fetchedState.viewModel.feedback is QagDetailsFeedbackNotAnsweredViewModel) {
          if (_emitImmediateStateIfSendSameFeedback(
            event,
            emit,
            fetchedState.viewModel,
            fetchedState.viewModel.feedback as QagDetailsFeedbackNotAnsweredViewModel,
          )) {
            return;
          }

          emit(
            QagDetailsFetchedState(
              QagDetailsViewModel.copyWithNewFeedback(
                viewModel: fetchedState.viewModel,
                feedback: QagDetailsFeedbackLoadingViewModel(
                  feedbackQuestion: fetchedState.viewModel.feedback!.feedbackQuestion,
                  isHelpfulClicked: event.isHelpful,
                ),
              ),
            ),
          );

          final response = await qagRepository.giveQagResponseFeedback(
            qagId: event.qagId,
            isHelpful: event.isHelpful,
          );

          await Future.delayed(feedbackLoadingDuration);

          if (response is QagFeedbackSuccessBodyResponse) {
            emit(
              QagDetailsFetchedState(
                QagDetailsViewModel.copyWithNewFeedback(
                  viewModel: fetchedState.viewModel,
                  feedback: QagDetailsFeedbackAnsweredNoResultsViewModel(
                    feedbackQuestion: fetchedState.viewModel.feedback!.feedbackQuestion,
                    userResponse: event.isHelpful,
                  ),
                ),
              ),
            );
          } else if (response is QagFeedbackSuccessBodyWithRatioResponse) {
            emit(
              QagDetailsFetchedState(
                QagDetailsViewModel.copyWithNewFeedback(
                  viewModel: fetchedState.viewModel,
                  feedback: QagDetailsFeedbackAnsweredResultsViewModel(
                    feedbackQuestion: fetchedState.viewModel.feedback!.feedbackQuestion,
                    userResponse: event.isHelpful,
                    feedbackResults: response.feedbackBody,
                  ),
                ),
              ),
            );
          } else {
            emit(
              QagDetailsFetchedState(
                QagDetailsViewModel.copyWithNewFeedback(
                  viewModel: fetchedState.viewModel,
                  feedback: QagDetailsFeedbackErrorViewModel(
                    feedbackQuestion: fetchedState.viewModel.feedback!.feedbackQuestion,
                  ),
                ),
              ),
            );
          }
        }
      }
    }
  }

  bool _emitImmediateStateIfSendSameFeedback(
    SendFeedbackQagDetailsEvent event,
    Emitter<QagDetailsState> emit,
    QagDetailsViewModel qagDetailsViewModel,
    QagDetailsFeedbackNotAnsweredViewModel previousFeedbackViewModel,
  ) {
    if (previousFeedbackViewModel.previousUserResponse == event.isHelpful) {
      if (previousFeedbackViewModel.previousFeedbackResults != null) {
        emit(
          QagDetailsFetchedState(
            QagDetailsViewModel.copyWithNewFeedback(
              viewModel: qagDetailsViewModel,
              feedback: QagDetailsFeedbackAnsweredResultsViewModel(
                feedbackQuestion: previousFeedbackViewModel.feedbackQuestion,
                userResponse: event.isHelpful,
                feedbackResults: previousFeedbackViewModel.previousFeedbackResults!,
              ),
            ),
          ),
        );
      } else {
        emit(
          QagDetailsFetchedState(
            QagDetailsViewModel.copyWithNewFeedback(
              viewModel: qagDetailsViewModel,
              feedback: QagDetailsFeedbackAnsweredNoResultsViewModel(
                feedbackQuestion: previousFeedbackViewModel.feedbackQuestion,
                userResponse: event.isHelpful,
              ),
            ),
          ),
        );
      }
      return true;
    }
    return false;
  }

  Future<void> _handleEditFeedback(
    EditFeedbackQagDetailsEvent event,
    Emitter<QagDetailsState> emit,
  ) async {
    if (state is QagDetailsFetchedState) {
      final fetchedState = state as QagDetailsFetchedState;
      if (fetchedState.viewModel.feedback != null) {
        switch (fetchedState.viewModel.feedback) {
          case final QagDetailsFeedbackAnsweredNoResultsViewModel answeredNoResults:
            emit(
              QagDetailsFetchedState(
                QagDetailsViewModel.copyWithNewFeedback(
                  viewModel: fetchedState.viewModel,
                  feedback: QagDetailsFeedbackNotAnsweredViewModel(
                    feedbackQuestion: answeredNoResults.feedbackQuestion,
                    previousUserResponse: answeredNoResults.userResponse,
                    previousFeedbackResults: null,
                  ),
                ),
              ),
            );
            break;
          case final QagDetailsFeedbackAnsweredResultsViewModel answeredResults:
            emit(
              QagDetailsFetchedState(
                QagDetailsViewModel.copyWithNewFeedback(
                  viewModel: fetchedState.viewModel,
                  feedback: QagDetailsFeedbackNotAnsweredViewModel(
                    feedbackQuestion: answeredResults.feedbackQuestion,
                    previousUserResponse: answeredResults.userResponse,
                    previousFeedbackResults: answeredResults.feedbackResults,
                  ),
                ),
              ),
            );
            break;
          default:
            break;
        }
      }
    }
  }
}
