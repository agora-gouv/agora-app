import 'package:agora/bloc/thematique/thematique_view_model.dart';
import 'package:agora/domain/qag/details/qag_details.dart';
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
  final QagDetailsFeedbackViewModel? feedback;

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
    required this.feedback,
  });

  factory QagDetailsViewModel.copyWithNewFeedback({
    required QagDetailsViewModel viewModel,
    required QagDetailsFeedbackViewModel? feedback,
  }) {
    return QagDetailsViewModel(
      id: viewModel.id,
      thematique: viewModel.thematique,
      title: viewModel.title,
      description: viewModel.description,
      username: viewModel.username,
      date: viewModel.date,
      canShare: viewModel.canShare,
      canSupport: viewModel.canSupport,
      canDelete: viewModel.canDelete,
      isAuthor: viewModel.isAuthor,
      support: viewModel.support,
      response: viewModel.response,
      feedback: feedback,
    );
  }

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
        feedback,
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

  QagDetailsResponseViewModel({
    required this.author,
    required this.authorDescription,
    required this.responseDate,
    required this.videoUrl,
    required this.videoWidth,
    required this.videoHeight,
    required this.transcription,
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
      ];
}

abstract class QagDetailsFeedbackViewModel extends Equatable {}

class QagDetailsFeedbackLoadingViewModel extends QagDetailsFeedbackViewModel {
  @override
  List<Object?> get props => [];
}

class QagDetailsFeedbackErrorViewModel extends QagDetailsFeedbackViewModel {
  @override
  List<Object?> get props => [];
}

class QagDetailsFeedbackNotAnsweredViewModel extends QagDetailsFeedbackViewModel {
  final QagFeedbackResults? feedbackResults;

  QagDetailsFeedbackNotAnsweredViewModel({required this.feedbackResults});

  @override
  List<Object?> get props => [feedbackResults];
}

class QagDetailsFeedbackAnsweredNoResultsViewModel extends QagDetailsFeedbackViewModel {
  @override
  List<Object?> get props => [];
}

class QagDetailsFeedbackAnsweredResultsViewModel extends QagDetailsFeedbackViewModel {
  final QagFeedbackResults feedbackResults;

  QagDetailsFeedbackAnsweredResultsViewModel({
    required this.feedbackResults,
  });

  @override
  List<Object?> get props => [feedbackResults];
}
