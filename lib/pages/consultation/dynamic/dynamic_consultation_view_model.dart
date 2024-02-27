part of 'dynamic_consultation_page.dart';

sealed class _ViewModel extends Equatable {}

class _LoadingViewModel extends _ViewModel {
  @override
  List<Object?> get props => [];
}

class _ErrorViewModel extends _ViewModel {
  @override
  List<Object?> get props => [];
}

class _SuccessViewModel extends _ViewModel {
  final String shareText;
  final List<_ViewModelSection> sections;

  _SuccessViewModel({
    required this.shareText,
    required this.sections,
  });

  @override
  List<Object?> get props => [];
}

sealed class _ViewModelSection extends Equatable {}

class _HeaderSection extends _ViewModelSection {
  final String coverUrl;
  final String title;
  final String thematicLogo;
  final String thematicLabel;

  _HeaderSection({
    required this.coverUrl,
    required this.title,
    required this.thematicLogo,
    required this.thematicLabel,
  });

  @override
  List<Object?> get props => [coverUrl, title, thematicLogo, thematicLabel];
}

class _QuestionsInfoSection extends _ViewModelSection {
  final String endDate;
  final String questionCount;
  final String estimatedTime;
  final int participantCount;
  final int participantCountGoal;
  final double goalProgress;

  _QuestionsInfoSection({
    required this.endDate,
    required this.questionCount,
    required this.estimatedTime,
    required this.participantCount,
    required this.participantCountGoal,
    required this.goalProgress,
  });

  @override
  List<Object?> get props => [
        endDate,
        questionCount,
        estimatedTime,
        participantCount,
        participantCountGoal,
        goalProgress,
      ];
}

class _InfoHeaderSection extends _ViewModelSection {
  final String logo;
  final String description;

  _InfoHeaderSection({
    required this.logo,
    required this.description,
  });

  @override
  List<Object?> get props => [logo, description];
}

class _ResponseInfoSection extends _ViewModelSection {
  final String id;
  final String picto;
  final String description;

  _ResponseInfoSection({
    required this.id,
    required this.picto,
    required this.description,
  });

  @override
  List<Object?> get props => [id, picto, description];
}

class _DownloadSection extends _ViewModelSection {
  final String url;

  _DownloadSection({
    required this.url,
  });

  @override
  List<Object?> get props => [url];
}

class _ParticipantInfoSection extends _ViewModelSection {
  final int participantCount;
  final int participantCountGoal;
  final String shareText;

  _ParticipantInfoSection({
    required this.participantCount,
    required this.participantCountGoal,
    required this.shareText,
  });

  @override
  List<Object?> get props => [participantCount, participantCountGoal, shareText];
}

class _ConsultationFeedbackQuestionSection extends _ViewModelSection {
  final String title;
  final String picto;
  final String description;
  final String id;

  _ConsultationFeedbackQuestionSection({
    required this.title,
    required this.picto,
    required this.description,
    required this.id,
  });

  @override
  List<Object?> get props => [title, picto, description, id];
}

class _ConsultationFeedbackResultsSection extends _ViewModelSection {
  final String id;
  final String title;
  final String picto;
  final String description;
  final bool userResponseIsPositive;
  final int positiveRatio;
  final int negativeRation;
  final int responseCount;

  _ConsultationFeedbackResultsSection({
    required this.id,
    required this.title,
    required this.picto,
    required this.description,
    required this.userResponseIsPositive,
    required this.positiveRatio,
    required this.negativeRation,
    required this.responseCount,
  });

  @override
  List<Object?> get props => [
        id,
        title,
        picto,
        description,
        userResponseIsPositive,
        positiveRatio,
        negativeRation,
        responseCount,
      ];
}

class _ExpandableSection extends _ViewModelSection {
  final List<_ViewModelSection> collapsedSections;
  final List<_ViewModelSection> expandedSections;

  _ExpandableSection({
    required this.collapsedSections,
    required this.expandedSections,
  });

  @override
  List<Object?> get props => [collapsedSections, expandedSections];
}

class _TitleSection extends _ViewModelSection {
  final String label;

  _TitleSection(this.label);

  @override
  List<Object?> get props => [label];
}

class _FocusNumberSection extends _ViewModelSection {
  final String title;
  final String description;

  _FocusNumberSection({
    required this.title,
    required this.description,
  });

  @override
  List<Object?> get props => [title, description];
}

class _QuoteSection extends _ViewModelSection {
  final String description;

  _QuoteSection({
    required this.description,
  });

  @override
  List<Object?> get props => [description];
}

class _RichTextSection extends _ViewModelSection {
  final String description;

  _RichTextSection(this.description);

  @override
  List<Object?> get props => [description];
}

class _FooterSection extends _ViewModelSection {
  final String? title;
  final String description;

  _FooterSection({
    required this.title,
    required this.description,
  });

  @override
  List<Object?> get props => [title, description];
}

class _StartButtonTextSection extends _ViewModelSection {
  final String consultationId;
  final String title;

  _StartButtonTextSection({
    required this.consultationId,
    required this.title,
  });

  @override
  List<Object?> get props => [consultationId, title];
}

class _NotificationSection extends _ViewModelSection {
  @override
  List<Object?> get props => [];
}

class _ImageSection extends _ViewModelSection {
  final String url;
  final String? desctiption;

  _ImageSection({
    required this.desctiption,
    required this.url,
  });

  @override
  List<Object?> get props => [desctiption, url];
}

class _HistorySection extends _ViewModelSection {
  final List<ConsultationHistoryStep> steps;

  _HistorySection(this.steps);

  @override
  List<Object?> get props => [steps];
}

class _VideoSection extends _ViewModelSection {
  final String url;
  final String transcription;
  final int width;
  final int height;
  final String? authorName;
  final String? authorDescription;
  final String? date;

  _VideoSection({
    required this.url,
    required this.transcription,
    required this.width,
    required this.height,
    required this.authorName,
    required this.authorDescription,
    required this.date,
  });

  @override
  List<Object?> get props => [
        transcription,
        url,
        width,
        height,
        authorName,
        authorDescription,
        date,
      ];
}
