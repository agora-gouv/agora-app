import 'package:agora/bloc/thematique/thematique_view_model.dart';
import 'package:equatable/equatable.dart';

class QagDetailsViewModel extends Equatable {
  final String id;
  final ThematiqueViewModel thematique;
  final String title;
  final String description;
  final String username;
  final String date;
  final bool canShare;
  final bool canSupport;
  final bool canDelete;
  final bool isAuthor;
  final QagDetailsSupportViewModel support;
  final QagDetailsResponseViewModel? response;

  QagDetailsViewModel({
    required this.id,
    required this.thematique,
    required this.title,
    required this.description,
    required this.username,
    required this.date,
    required this.canShare,
    required this.canSupport,
    required this.canDelete,
    required this.isAuthor,
    required this.support,
    required this.response,
  });

  @override
  List<Object?> get props => [
        id,
        thematique,
        title,
        description,
        username,
        date,
        canShare,
        canSupport,
        canDelete,
        isAuthor,
        support,
        response,
      ];
}

class QagDetailsSupportViewModel extends Equatable {
  final int count;
  final bool isSupported;

  QagDetailsSupportViewModel({required this.count, required this.isSupported});

  @override
  List<Object> get props => [
        count,
        isSupported,
      ];
}

class QagDetailsResponseViewModel extends Equatable {
  final String author;
  final String authorDescription;
  final String responseDate;
  final String videoUrl;
  final int videoWidth;
  final int videoHeight;
  final String transcription;
  final QagDetailsFeedbackViewModel feedbackResults;

  QagDetailsResponseViewModel({
    required this.author,
    required this.authorDescription,
    required this.responseDate,
    required this.videoUrl,
    required this.videoWidth,
    required this.videoHeight,
    required this.transcription,
    required this.feedbackResults,
  });

  @override
  List<Object> get props => [
        author,
        authorDescription,
        responseDate,
        videoUrl,
        videoWidth,
        videoHeight,
        transcription,
        feedbackResults,
      ];
}

abstract class QagDetailsFeedbackViewModel extends Equatable {}

class QagDetailsFeedbackResultsNotAnsweredViewModel extends QagDetailsFeedbackViewModel {
  @override
  List<Object?> get props => [];
}

class QagDetailsFeedbackResultsAnsweredNoResultsViewModel extends QagDetailsFeedbackViewModel {
  @override
  List<Object?> get props => [];
}

class QagDetailsFeedbackResultsViewModel extends QagDetailsFeedbackViewModel {
  final int positiveRatio;
  final int negativeRatio;
  final int count;

  QagDetailsFeedbackResultsViewModel({
    required this.positiveRatio,
    required this.negativeRatio,
    required this.count,
  });

  @override
  List<Object?> get props => [positiveRatio, negativeRatio, count];
}
