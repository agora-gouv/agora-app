import 'package:agora/domain/consultation/dynamic/dynamic_consultation_section.dart';
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
  final List<DynamicConsultationSection> collapsedSections;
  final List<DynamicConsultationSection> expandedSections;
  final ConsultationParticipationInfo? participationInfo;
  final ConsultationDownloadInfo? downloadInfo;
  final ConsultationFeedbackQuestion? feedbackQuestion;
  final ConsultationFeedbackResults? feedbackResult;
  final List<ConsultationHistoryStep>? history;
  final ConsultationFooter? footer;

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
    required this.collapsedSections,
    required this.expandedSections,
    required this.participationInfo,
    required this.downloadInfo,
    required this.feedbackQuestion,
    required this.feedbackResult,
    required this.history,
    required this.footer,
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

class ConsultationResponseInfos extends Equatable {
  final String id;
  final String picto;
  final String description;

  ConsultationResponseInfos({
    required this.id,
    required this.picto,
    required this.description,
  });

  @override
  List<Object?> get props => [id, picto, description];
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

  ConsultationFeedbackQuestion({
    required this.title,
    required this.picto,
    required this.description,
    required this.id,
  });

  @override
  List<Object?> get props => [title, picto, description, id];
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
