import 'package:agora/bloc/qag/details/qag_details_view_model.dart';
import 'package:agora/common/extension/date_extension.dart';
import 'package:agora/common/extension/thematique_extension.dart';
import 'package:agora/domain/qag/details/qag_details.dart';

class QagDetailsPresenter {
  static QagDetailsViewModel present(QagDetails qagDetails) {
    final support = qagDetails.support;
    final videoResponse = _presentResponse(qagDetails.response);
    return QagDetailsViewModel(
      id: qagDetails.id,
      thematique: qagDetails.thematique.toThematiqueViewModel(),
      title: qagDetails.title,
      description: qagDetails.description,
      date: qagDetails.date.formatToDayMonth(),
      username: qagDetails.username,
      canShare: qagDetails.canShare,
      canSupport: qagDetails.canSupport,
      canDelete: qagDetails.canDelete,
      isAuthor: qagDetails.isAuthor,
      support: QagDetailsSupportViewModel(
        count: support.count,
        isSupported: support.isSupported,
      ),
      response: videoResponse,
      textResponse: videoResponse == null ? _presentTextResponse(qagDetails.textResponse) : null,
      feedback: _presentFeedbackFromVideoResponse(qagDetails.response) ??
          _presentFeedbackFromTextResponse(qagDetails.textResponse),
    );
  }

  static QagDetailsResponseViewModel? _presentResponse(QagDetailsResponse? response) {
    return response != null
        ? QagDetailsResponseViewModel(
            author: response.author,
            authorDescription: response.authorDescription,
            responseDate: response.responseDate.formatToDayMonth(),
            videoUrl: response.videoUrl,
            videoWidth: response.videoWidth,
            videoHeight: response.videoHeight,
            transcription: response.transcription,
          )
        : null;
  }

  static QagDetailsTextResponseViewModel? _presentTextResponse(QagDetailsTextResponse? response) {
    return response != null
        ? QagDetailsTextResponseViewModel(responseLabel: response.responseLabel, responseText: response.responseText)
        : null;
  }

  static QagDetailsFeedbackViewModel? _presentFeedbackFromVideoResponse(QagDetailsResponse? response) {
    if (response == null) {
      return null;
    } else if (response.feedbackStatus == false) {
      return QagDetailsFeedbackNotAnsweredViewModel(
        feedbackQuestion: response.feedbackQuestion,
        feedbackResults: response.feedbackResults,
      );
    } else if (response.feedbackResults == null) {
      return QagDetailsFeedbackAnsweredNoResultsViewModel(feedbackQuestion: response.feedbackQuestion);
    } else {
      return QagDetailsFeedbackAnsweredResultsViewModel(
        feedbackQuestion: response.feedbackQuestion,
        feedbackResults: response.feedbackResults!,
      );
    }
  }

  static QagDetailsFeedbackViewModel? _presentFeedbackFromTextResponse(QagDetailsTextResponse? response) {
    if (response == null) {
      return null;
    } else if (response.feedbackStatus == false) {
      return QagDetailsFeedbackNotAnsweredViewModel(
        feedbackQuestion: response.feedbackQuestion,
        feedbackResults: response.feedbackResults,
      );
    } else if (response.feedbackResults == null) {
      return QagDetailsFeedbackAnsweredNoResultsViewModel(feedbackQuestion: response.feedbackQuestion);
    } else {
      return QagDetailsFeedbackAnsweredResultsViewModel(
        feedbackQuestion: response.feedbackQuestion,
        feedbackResults: response.feedbackResults!,
      );
    }
  }
}
