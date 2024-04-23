part of 'dynamic_consultation_page.dart';

sealed class DynamicConsultationViewModel extends Equatable {}

class _LoadingViewModel extends DynamicConsultationViewModel {
  @override
  List<Object?> get props => [];
}

class _ErrorViewModel extends DynamicConsultationViewModel {
  @override
  List<Object?> get props => [];
}

class _SuccessViewModel extends DynamicConsultationViewModel {
  final String shareText;
  final String consultationId;
  final List<DynamicViewModelSection> sections;

  _SuccessViewModel({
    required this.consultationId,
    required this.shareText,
    required this.sections,
  });

  @override
  List<Object?> get props => [shareText, consultationId, sections];
}

sealed class DynamicViewModelSection extends Equatable {}

class HeaderSection extends DynamicViewModelSection {
  final String coverUrl;
  final String title;
  final String thematicLogo;
  final String thematicLabel;

  HeaderSection({
    required this.coverUrl,
    required this.title,
    required this.thematicLogo,
    required this.thematicLabel,
  });

  @override
  List<Object?> get props => [coverUrl, title, thematicLogo, thematicLabel];
}

class HeaderSectionUpdate extends DynamicViewModelSection {
  final String coverUrl;
  final String title;

  HeaderSectionUpdate({
    required this.coverUrl,
    required this.title,
  });

  @override
  List<Object?> get props => [coverUrl, title];
}

class QuestionsInfoSection extends DynamicViewModelSection {
  final String endDate;
  final String questionCount;
  final String estimatedTime;
  final int participantCount;
  final int participantCountGoal;
  final double goalProgress;

  QuestionsInfoSection({
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

class InfoHeaderSection extends DynamicViewModelSection {
  final String logo;
  final String description;

  InfoHeaderSection({
    required this.logo,
    required this.description,
  });

  @override
  List<Object?> get props => [logo, description];
}

class ConsultationDatesInfosSection extends DynamicViewModelSection {
  final String label;

  ConsultationDatesInfosSection({
    required this.label,
  });

  @override
  List<Object?> get props => [label];
}

class ResponseInfoSection extends DynamicViewModelSection {
  final String id;
  final String picto;
  final String description;
  final String buttonLabel;

  ResponseInfoSection({
    required this.id,
    required this.picto,
    required this.description,
    required this.buttonLabel,
  });

  @override
  List<Object?> get props => [id, picto, description, buttonLabel];
}

class DownloadSection extends DynamicViewModelSection {
  final String url;

  DownloadSection({
    required this.url,
  });

  @override
  List<Object?> get props => [url];
}

class ParticipantInfoSection extends DynamicViewModelSection {
  final int participantCount;
  final int participantCountGoal;
  final String shareText;

  ParticipantInfoSection({
    required this.participantCount,
    required this.participantCountGoal,
    required this.shareText,
  });

  @override
  List<Object?> get props => [participantCount, participantCountGoal, shareText];
}

class ConsultationFeedbackQuestionSection extends DynamicViewModelSection {
  final String title;
  final String picto;
  final String description;
  final String id;
  final String consultationId;
  final bool? userResponse;
  final bool isLoading;

  ConsultationFeedbackQuestionSection({
    required this.title,
    required this.picto,
    required this.description,
    required this.id,
    required this.consultationId,
    required this.userResponse,
    this.isLoading = false,
  });

  @override
  List<Object?> get props => [title, picto, description, id, userResponse, isLoading];
}

class ConsultationFeedbackResultsSection extends DynamicViewModelSection {
  final String id;
  final String title;
  final String picto;
  final String description;
  final bool userResponseIsPositive;
  final int positiveRatio;
  final int negativeRation;
  final int responseCount;

  ConsultationFeedbackResultsSection({
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

class ExpandableSection extends DynamicViewModelSection {
  final List<DynamicViewModelSection> headerSections;
  final List<DynamicViewModelSection> collapsedSections;
  final List<DynamicViewModelSection> expandedSections;

  ExpandableSection({
    required this.headerSections,
    required this.collapsedSections,
    required this.expandedSections,
  });

  @override
  List<Object?> get props => [collapsedSections, expandedSections, headerSections];
}

class _TitleSection extends DynamicViewModelSection {
  final String label;

  _TitleSection(this.label);

  @override
  List<Object?> get props => [label];
}

class _FocusNumberSection extends DynamicViewModelSection {
  final String title;
  final String description;

  _FocusNumberSection({
    required this.title,
    required this.description,
  });

  @override
  List<Object?> get props => [title, description];
}

class _QuoteSection extends DynamicViewModelSection {
  final String description;

  _QuoteSection({
    required this.description,
  });

  @override
  List<Object?> get props => [description];
}

class _AccordionSection extends DynamicViewModelSection {
  final String title;
  final List<DynamicViewModelSection> sections;

  _AccordionSection({
    required this.title,
    required this.sections,
  });

  @override
  List<Object?> get props => [title, sections];
}

class _RichTextSection extends DynamicViewModelSection {
  final String description;

  _RichTextSection(this.description);

  @override
  List<Object?> get props => [description];
}

class FooterSection extends DynamicViewModelSection {
  final String? title;
  final String description;

  FooterSection({
    required this.title,
    required this.description,
  });

  @override
  List<Object?> get props => [title, description];
}

class GoalSection extends DynamicViewModelSection {
  final List<ConsultationGoal> goals;

  GoalSection(this.goals);

  @override
  List<Object?> get props => [goals];
}

class StartButtonTextSection extends DynamicViewModelSection {
  final String consultationId;
  final String title;

  StartButtonTextSection({
    required this.consultationId,
    required this.title,
  });

  @override
  List<Object?> get props => [consultationId, title];
}

class NotificationSection extends DynamicViewModelSection {
  @override
  List<Object?> get props => [];
}

class _ImageSection extends DynamicViewModelSection {
  final String url;
  final String? desctiption;

  _ImageSection({
    required this.desctiption,
    required this.url,
  });

  @override
  List<Object?> get props => [desctiption, url];
}

class HistorySection extends DynamicViewModelSection {
  final String consultationId;
  final List<ConsultationHistoryStep> steps;

  HistorySection(this.consultationId, this.steps);

  @override
  List<Object?> get props => [consultationId, steps];
}

class _VideoSection extends DynamicViewModelSection {
  final String consultationId;
  final String url;
  final String transcription;
  final int width;
  final int height;
  final String? authorName;
  final String? authorDescription;
  final String? date;

  _VideoSection({
    required this.consultationId,
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
        consultationId,
        url,
        transcription,
        width,
        height,
        authorName,
        authorDescription,
        date,
      ];
}
