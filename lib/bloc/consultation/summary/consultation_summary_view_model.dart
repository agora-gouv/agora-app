import 'package:equatable/equatable.dart';

class ConsultationSummaryViewModel extends Equatable {
  final String title;
  final String participantCount;
  final List<ConsultationSummaryResultsViewModel> results;
  final ConsultationSummaryEtEnsuiteViewModel etEnsuite;
  final ConsultationSummaryPresentationViewModel presentation;

  ConsultationSummaryViewModel({
    required this.title,
    required this.participantCount,
    required this.results,
    required this.etEnsuite,
    required this.presentation,
  });

  @override
  List<Object?> get props => [
        title,
        participantCount,
        results,
        etEnsuite,
        presentation,
      ];
}

sealed class ConsultationSummaryResultsViewModel extends Equatable {
  final String questionTitle;
  final int order;

  ConsultationSummaryResultsViewModel({
    required this.questionTitle,
    required this.order,
  });

  @override
  List<Object> get props => [questionTitle, order];
}

class ConsultationSummaryUniqueChoiceResultsViewModel extends ConsultationSummaryResultsViewModel {
  final int seenRatio;
  final List<ConsultationSummaryResponseViewModel> responses;

  ConsultationSummaryUniqueChoiceResultsViewModel({
    required super.questionTitle,
    required super.order,
    required this.seenRatio,
    required this.responses,
  });

  @override
  List<Object> get props => [questionTitle, order, seenRatio, responses];
}

class ConsultationSummaryMultipleChoicesResultsViewModel extends ConsultationSummaryResultsViewModel {
  final int seenRatio;
  final List<ConsultationSummaryResponseViewModel> responses;

  ConsultationSummaryMultipleChoicesResultsViewModel({
    required super.questionTitle,
    required super.order,
    required this.seenRatio,
    required this.responses,
  });

  @override
  List<Object> get props => [questionTitle, order, seenRatio, responses];
}

class ConsultationSummaryOpenChoiceResultsViewModel extends ConsultationSummaryResultsViewModel {
  ConsultationSummaryOpenChoiceResultsViewModel({
    required super.questionTitle,
    required super.order,
  });
}

class ConsultationSummaryResponseViewModel extends Equatable {
  final String label;
  final int ratio;
  final bool isUserResponse;

  ConsultationSummaryResponseViewModel({
    required this.label,
    required this.ratio,
    required this.isUserResponse,
  });

  @override
  List<Object> get props => [label, ratio, isUserResponse];
}

class ConsultationSummaryEtEnsuiteViewModel extends Equatable {
  final String step;
  final String stepSemanticsLabel;
  final String image;
  final String title;
  final String description;
  final String? explanationsTitle;
  final List<ConsultationSummaryEtEnsuiteExplanationViewModel> explanations;
  final ConsultationSummaryEtEnsuiteVideoViewModel? video;
  final ConsultationSummaryEtEnsuiteConclusionViewModel? conclusion;

  ConsultationSummaryEtEnsuiteViewModel({
    required this.step,
    required this.stepSemanticsLabel,
    required this.image,
    required this.title,
    required this.description,
    required this.explanationsTitle,
    required this.explanations,
    required this.video,
    required this.conclusion,
  });

  @override
  List<Object?> get props => [
        step,
        stepSemanticsLabel,
        image,
        title,
        description,
        explanationsTitle,
        explanations,
        video,
        conclusion,
      ];
}

class ConsultationSummaryEtEnsuiteExplanationViewModel extends Equatable {
  final bool isTogglable;
  final String title;
  final String intro;
  final String? imageUrl;
  final String? imageDescription;
  final String description;

  ConsultationSummaryEtEnsuiteExplanationViewModel({
    required this.isTogglable,
    required this.title,
    required this.intro,
    required this.imageUrl,
    required this.imageDescription,
    required this.description,
  });

  @override
  List<Object?> get props => [
        isTogglable,
        title,
        intro,
        imageUrl,
        description,
        imageDescription,
      ];
}

class ConsultationSummaryEtEnsuiteVideoViewModel extends Equatable {
  final String title;
  final String intro;
  final String videoUrl;
  final int videoWidth;
  final int videoHeight;
  final String transcription;

  ConsultationSummaryEtEnsuiteVideoViewModel({
    required this.title,
    required this.intro,
    required this.videoUrl,
    required this.videoWidth,
    required this.videoHeight,
    required this.transcription,
  });

  @override
  List<Object> get props => [
        title,
        intro,
        videoUrl,
        videoWidth,
        videoHeight,
        transcription,
      ];
}

class ConsultationSummaryEtEnsuiteConclusionViewModel extends Equatable {
  final String title;
  final String description;

  ConsultationSummaryEtEnsuiteConclusionViewModel({
    required this.title,
    required this.description,
  });

  @override
  List<Object> get props => [
        title,
        description,
      ];
}

class ConsultationSummaryPresentationViewModel extends Equatable {
  final String rangeDate;
  final String description;
  final String tipDescription;

  ConsultationSummaryPresentationViewModel({
    required this.rangeDate,
    required this.description,
    required this.tipDescription,
  });

  @override
  List<Object> get props => [
        rangeDate,
        description,
        tipDescription,
      ];
}
