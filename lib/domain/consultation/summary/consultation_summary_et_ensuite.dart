import 'package:equatable/equatable.dart';

class ConsultationSummaryEtEnsuite extends Equatable {
  final int step;
  final String description;
  final String? explanationsTitle;
  final List<ConsultationSummaryEtEnsuiteExplanation> explanations;
  final ConsultationSummaryEtEnsuiteVideo? video;
  final ConsultationSummaryEtEnsuiteConclusion? conclusion;

  ConsultationSummaryEtEnsuite({
    required this.step,
    required this.description,
    required this.explanationsTitle,
    required this.explanations,
    required this.video,
    required this.conclusion,
  });

  @override
  List<Object?> get props => [
        step,
        description,
        explanationsTitle,
        explanations,
        video,
        conclusion,
      ];
}

class ConsultationSummaryEtEnsuiteExplanation extends Equatable {
  final bool isTogglable;
  final String title;
  final String intro;
  final String imageUrl;
  final String description;

  ConsultationSummaryEtEnsuiteExplanation({
    required this.isTogglable,
    required this.title,
    required this.intro,
    required this.imageUrl,
    required this.description,
  });

  @override
  List<Object> get props => [
        isTogglable,
        title,
        intro,
        imageUrl,
        description,
      ];
}

class ConsultationSummaryEtEnsuiteVideo extends Equatable {
  final String title;
  final String intro;
  final String videoUrl;
  final int videoWidth;
  final int videoHeight;
  final String transcription;

  ConsultationSummaryEtEnsuiteVideo({
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

class ConsultationSummaryEtEnsuiteConclusion extends Equatable {
  final String title;
  final String description;

  ConsultationSummaryEtEnsuiteConclusion({
    required this.title,
    required this.description,
  });

  @override
  List<Object> get props => [
        title,
        description,
      ];
}
