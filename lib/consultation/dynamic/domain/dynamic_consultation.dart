import 'package:agora/consultation/dynamic/domain/dynamic_consultation_section.dart';
import 'package:equatable/equatable.dart';

class DynamicConsultation extends Equatable {
  final String id;
  final String shareText;
  final String title;
  final String coverUrl;
  final String thematicLogo;
  final String thematicLabel;
  final ConsultationQuestionsInfos? questionsInfos;
  final ConsultationResponseInfos? responseInfos;
  final ConsultationInfoHeader? infoHeader;
  final List<DynamicConsultationSection> headerSections;
  final List<DynamicConsultationSection> collapsedSections;
  final List<DynamicConsultationSection> expandedSections;
  final ConsultationParticipationInfo? participationInfo;
  final ConsultationDownloadInfo? downloadInfo;
  final ConsultationFeedbackQuestion? feedbackQuestion;
  final ConsultationFeedbackResults? feedbackResult;
  final List<ConsultationHistoryStep> history;
  final ConsultationFooter? footer;
  final List<ConsultationGoal>? goals;
  final String territoire;

  DynamicConsultation({
    required this.id,
    required this.title,
    required this.coverUrl,
    required this.shareText,
    required this.thematicLogo,
    required this.thematicLabel,
    required this.questionsInfos,
    required this.responseInfos,
    required this.infoHeader,
    required this.headerSections,
    required this.collapsedSections,
    required this.expandedSections,
    required this.participationInfo,
    required this.downloadInfo,
    required this.feedbackQuestion,
    required this.feedbackResult,
    required this.history,
    required this.footer,
    required this.goals,
    required this.territoire,
  });

  @override
  List<Object?> get props => [
        id,
        coverUrl,
        shareText,
        thematicLogo,
        thematicLabel,
        questionsInfos,
        responseInfos,
        infoHeader,
        collapsedSections,
        expandedSections,
        participationInfo,
        downloadInfo,
        feedbackQuestion,
        feedbackResult,
        history,
        footer,
        headerSections,
        goals,
        territoire,
      ];
}

class ConsultationQuestionsInfos extends Equatable {
  final DateTime endDate;
  final String questionCount;
  final String estimatedTime;
  final int participantCount;
  final int participantCountGoal;

  ConsultationQuestionsInfos({
    required this.endDate,
    required this.questionCount,
    required this.estimatedTime,
    required this.participantCount,
    required this.participantCountGoal,
  });

  @override
  List<Object?> get props => [
        endDate,
        questionCount,
        estimatedTime,
        participantCount,
        participantCountGoal,
      ];
}

class ConsultationDatesInfos extends Equatable {
  final DateTime endDate;
  final DateTime startDate;

  ConsultationDatesInfos({
    required this.endDate,
    required this.startDate,
  });

  @override
  List<Object?> get props => [endDate, startDate];
}

class ConsultationResponseInfos extends Equatable {
  final String id;
  final String picto;
  final String description;
  final String buttonLabel;

  ConsultationResponseInfos({
    required this.id,
    required this.picto,
    required this.description,
    required this.buttonLabel,
  });

  @override
  List<Object?> get props => [id, picto, description, buttonLabel];
}

class ConsultationInfoHeader extends Equatable {
  final String logo;
  final String description;

  ConsultationInfoHeader({
    required this.logo,
    required this.description,
  });

  @override
  List<Object?> get props => [logo, description];
}

class ConsultationParticipationInfo extends Equatable {
  final int participantCount;
  final int participantCountGoal;
  final String shareText;

  ConsultationParticipationInfo({
    required this.participantCount,
    required this.participantCountGoal,
    required this.shareText,
  });

  @override
  List<Object?> get props => [participantCount, participantCountGoal, shareText];
}

class ConsultationDownloadInfo extends Equatable {
  final String url;

  ConsultationDownloadInfo({
    required this.url,
  });

  @override
  List<Object?> get props => [url];
}

class ConsultationFeedbackQuestion extends Equatable {
  final String title;
  final String picto;
  final String description;
  final String id;
  final bool? userResponse;

  ConsultationFeedbackQuestion({
    required this.title,
    required this.picto,
    required this.description,
    required this.id,
    required this.userResponse,
  });

  @override
  List<Object?> get props => [title, picto, description, id, userResponse];
}

class ConsultationFeedbackResults extends Equatable {
  final String id;
  final String title;
  final String picto;
  final String description;
  final bool userResponseIsPositive;
  final int positiveRatio;
  final int negativeRatio;
  final int responseCount;

  ConsultationFeedbackResults({
    required this.id,
    required this.title,
    required this.picto,
    required this.description,
    required this.userResponseIsPositive,
    required this.positiveRatio,
    required this.negativeRatio,
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
        negativeRatio,
        responseCount,
      ];
}

class ConsultationFooter extends Equatable {
  final String? title;
  final String description;

  ConsultationFooter({
    required this.title,
    required this.description,
  });

  @override
  List<Object?> get props => [title, description];
}

class ConsultationGoal extends Equatable {
  final String picto;
  final String description;

  ConsultationGoal({
    required this.picto,
    required this.description,
  });

  @override
  List<Object?> get props => [picto, description];
}

class ConsultationHistoryStep extends Equatable {
  final String? updateId;
  final ConsultationHistoryStepType type;
  final ConsultationHistoryStepStatus status;
  final String title;
  final DateTime? date;
  final String? actionText;

  ConsultationHistoryStep({
    required this.updateId,
    required this.type,
    required this.status,
    required this.title,
    required this.date,
    required this.actionText,
  });

  @override
  List<Object?> get props => [
        updateId,
        type,
        status,
        title,
        date,
        actionText,
      ];
}

enum ConsultationHistoryStepType {
  results,
  update;
}

enum ConsultationHistoryStepStatus {
  done,
  current,
  incoming;
}

class DynamicConsultationUpdate extends Equatable {
  final String id;
  final String title;
  final String coverUrl;
  final String shareText;
  final String thematicLogo;
  final String thematicLabel;
  final ConsultationDatesInfos? consultationDatesInfos;
  final ConsultationResponseInfos? responseInfos;
  final ConsultationInfoHeader? infoHeader;
  final List<DynamicConsultationSection> headerSections;
  final List<DynamicConsultationSection> previewSections;
  final List<DynamicConsultationSection> expandedSections;
  final ConsultationParticipationInfo? participationInfo;
  final ConsultationDownloadInfo? downloadInfo;
  final ConsultationFeedbackQuestion? feedbackQuestion;
  final ConsultationFeedbackResults? feedbackResult;
  final ConsultationFooter? footer;
  final List<ConsultationGoal>? goals;

  DynamicConsultationUpdate({
    required this.id,
    required this.title,
    required this.coverUrl,
    required this.thematicLogo,
    required this.thematicLabel,
    required this.shareText,
    required this.responseInfos,
    required this.infoHeader,
    required this.headerSections,
    required this.previewSections,
    required this.expandedSections,
    required this.participationInfo,
    required this.downloadInfo,
    required this.feedbackQuestion,
    required this.feedbackResult,
    required this.footer,
    required this.consultationDatesInfos,
    required this.goals,
  });

  @override
  List<Object?> get props => [
        id,
        shareText,
        responseInfos,
        infoHeader,
        thematicLabel,
        thematicLogo,
        previewSections,
        expandedSections,
        participationInfo,
        downloadInfo,
        feedbackQuestion,
        feedbackResult,
        consultationDatesInfos,
        footer,
        headerSections,
        goals,
      ];
}
