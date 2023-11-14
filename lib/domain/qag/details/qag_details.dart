import 'package:agora/domain/thematique/thematique.dart';
import 'package:equatable/equatable.dart';

class QagDetails extends Equatable {
  final String id;
  final Thematique thematique;
  final String title;
  final String description;
  final DateTime date;
  final String username;
  final bool canShare;
  final bool canSupport;
  final bool canDelete;
  final bool isAuthor;
  final QagDetailsSupport support;
  final QagDetailsResponse? response;
  final QagDetailsTextResponse? textResponse;

  QagDetails({
    required this.id,
    required this.thematique,
    required this.title,
    required this.description,
    required this.date,
    required this.username,
    required this.canShare,
    required this.canSupport,
    required this.canDelete,
    required this.isAuthor,
    required this.support,
    required this.response,
    required this.textResponse,
  });

  factory QagDetails.copyWithNewResponse({
    required QagDetails qagDetails,
    required QagDetailsResponse? response,
  }) {
    return QagDetails(
      id: qagDetails.id,
      thematique: qagDetails.thematique,
      title: qagDetails.title,
      description: qagDetails.description,
      date: qagDetails.date,
      username: qagDetails.username,
      canShare: qagDetails.canShare,
      canSupport: qagDetails.canSupport,
      canDelete: qagDetails.canDelete,
      isAuthor: qagDetails.isAuthor,
      support: qagDetails.support,
      response: response,
      textResponse: qagDetails.textResponse,
    );
  }

  @override
  List<Object?> get props => [
        id,
        thematique,
        title,
        description,
        date,
        username,
        canShare,
        canSupport,
        canDelete,
        isAuthor,
        support,
        response,
        textResponse,
      ];
}

class QagDetailsSupport extends Equatable {
  final int count;
  final bool isSupported;

  QagDetailsSupport({required this.count, required this.isSupported});

  @override
  List<Object> get props => [
        count,
        isSupported,
      ];
}

class QagDetailsResponse extends Equatable {
  final String author;
  final String authorDescription;
  final DateTime responseDate;
  final String videoUrl;
  final int videoWidth;
  final int videoHeight;
  final String transcription;
  final String feedbackQuestion;
  final bool feedbackStatus;
  final QagFeedbackResults? feedbackResults;

  QagDetailsResponse({
    required this.author,
    required this.authorDescription,
    required this.responseDate,
    required this.videoUrl,
    required this.videoWidth,
    required this.videoHeight,
    required this.transcription,
    required this.feedbackQuestion,
    required this.feedbackStatus,
    required this.feedbackResults,
  });

  factory QagDetailsResponse.copyWithNewFeedback({
    required QagDetailsResponse response,
    required bool feedbackStatus,
    required QagFeedbackResults? feedbackResults,
  }) {
    return QagDetailsResponse(
      author: response.author,
      authorDescription: response.authorDescription,
      responseDate: response.responseDate,
      videoUrl: response.videoUrl,
      videoWidth: response.videoWidth,
      videoHeight: response.videoHeight,
      transcription: response.transcription,
      feedbackQuestion: response.feedbackQuestion,
      feedbackStatus: feedbackStatus,
      feedbackResults: feedbackResults,
    );
  }

  @override
  List<Object?> get props => [
        author,
        authorDescription,
        responseDate,
        videoUrl,
        videoWidth,
        videoHeight,
        transcription,
        feedbackQuestion,
        feedbackStatus,
        feedbackResults,
      ];
}

class QagDetailsTextResponse extends Equatable {
  final String responseLabel;
  final String responseText;
  final String feedbackQuestion;
  final bool feedbackStatus;
  final QagFeedbackResults? feedbackResults;

  QagDetailsTextResponse({
    required this.responseLabel,
    required this.responseText,
    required this.feedbackQuestion,
    required this.feedbackStatus,
    required this.feedbackResults,
  });

  @override
  List<Object?> get props => [
        responseLabel,
        responseText,
        feedbackQuestion,
        feedbackStatus,
        feedbackResults,
      ];
}

class QagFeedbackResults extends Equatable {
  final int positiveRatio;
  final int negativeRatio;
  final int count;

  QagFeedbackResults({
    required this.positiveRatio,
    required this.negativeRatio,
    required this.count,
  });

  @override
  List<Object?> get props => [positiveRatio, negativeRatio, count];
}
