import 'package:agora/common/extension/date_extension.dart';
import 'package:agora/consultation/dynamic/domain/dynamic_consultation.dart';
import 'package:agora/consultation/dynamic/domain/dynamic_consultation_section.dart';

ConsultationQuestionsInfos? toQuestionsInfo(dynamic data) {
  if (data is Map<String, dynamic>) {
    return ConsultationQuestionsInfos(
      endDate: (data["endDate"] as String).parseToDateTime(),
      questionCount: data["questionCount"] as String,
      estimatedTime: data["estimatedTime"] as String,
      participantCount: data["participantCount"] as int,
      participantCountGoal: data["participantCountGoal"] as int,
    );
  } else {
    return null;
  }
}

ConsultationResponseInfos? toResponseInfo(dynamic data, String id) {
  if (data is Map<String, dynamic>) {
    return ConsultationResponseInfos(
      id: id,
      picto: data["picto"] as String,
      description: data["description"] as String,
      buttonLabel: data["actionText"] as String,
    );
  } else {
    return null;
  }
}

ConsultationInfoHeader? toInfoHeader(dynamic data) {
  if (data is Map<String, dynamic>) {
    return ConsultationInfoHeader(
      logo: data["picto"] as String,
      description: data["description"] as String,
    );
  } else {
    return null;
  }
}

ConsultationFooter? toFooter(dynamic data) {
  if (data is Map<String, dynamic>) {
    return ConsultationFooter(
      title: data["title"] as String?,
      description: data["description"] as String,
    );
  } else {
    return null;
  }
}

List<ConsultationGoal>? toGoals(dynamic data) {
  if (data is List) {
    return data
        .map(
          (goal) => ConsultationGoal(
            picto: goal["picto"] as String,
            description: goal["description"] as String,
          ),
        )
        .toList();
  } else {
    return null;
  }
}

ConsultationParticipationInfo? toParticipationInfo(dynamic data, String shareText) {
  if (data is Map<String, dynamic>) {
    return ConsultationParticipationInfo(
      shareText: shareText,
      participantCountGoal: data["participantCountGoal"] as int,
      participantCount: data["participantCount"] as int,
    );
  } else {
    return null;
  }
}

ConsultationDatesInfos? toConsultationDateInfo(dynamic data) {
  if (data is Map<String, dynamic>) {
    return ConsultationDatesInfos(
      endDate: (data["endDate"] as String).parseToDateTime(),
      startDate: (data["startDate"] as String).parseToDateTime(),
    );
  } else {
    return null;
  }
}

ConsultationFeedbackQuestion? toFeedbackQuestion(dynamic data) {
  if (data is Map<String, dynamic>) {
    return ConsultationFeedbackQuestion(
      id: data["updateId"] as String,
      title: data["title"] as String,
      picto: data["picto"] as String,
      description: data["description"] as String,
      userResponse: (data["results"] as Map<String, dynamic>?)?["userResponse"] as bool?,
    );
  } else {
    return null;
  }
}

ConsultationFeedbackResults? toFeedbackResults(dynamic data) {
  if (data is Map<String, dynamic>) {
    return ConsultationFeedbackResults(
      id: data["updateId"] as String,
      title: data["title"] as String,
      picto: data["picto"] as String,
      description: data["description"] as String,
      userResponseIsPositive: data["userResponse"] as bool,
      positiveRatio: data["positiveRatio"] as int,
      negativeRatio: data["negativeRatio"] as int,
      responseCount: data["responseCount"] as int,
    );
  } else {
    return null;
  }
}

List<ConsultationHistoryStep> toHistory(dynamic data, String id) {
  if (data is List) {
    return data.map((e) => toHistoryStep(e, id)).nonNulls.toList();
  } else {
    return [];
  }
}

ConsultationHistoryStep? toHistoryStep(dynamic data, String id) {
  if (data is Map<String, dynamic>) {
    final type = switch (data["type"] as String) {
      "results" => ConsultationHistoryStepType.results,
      _ => ConsultationHistoryStepType.update,
    };
    return ConsultationHistoryStep(
      updateId: data["updateId"] as String?,
      title: data["title"] as String,
      type: type,
      status: switch (data["status"] as String) {
        "done" => ConsultationHistoryStepStatus.done,
        "current" => ConsultationHistoryStepStatus.current,
        _ => ConsultationHistoryStepStatus.incoming,
      },
      date: (data["date"] as String?)?.parseToDateTime(),
      actionText: data["actionText"] as String?,
    );
  } else {
    return null;
  }
}

DynamicConsultationSection? toSection(dynamic data) {
  if (data is Map<String, dynamic>) {
    final type = data["type"] as String;
    return switch (type) {
      "title" => toTitleSection(data),
      "richText" => toRichTextSection(data),
      "image" => toImage(data),
      "video" => toVideo(data),
      "focusNumber" => toFocusNumber(data),
      "quote" => toQuoteSection(data),
      "accordion" => toAccordionSection(data),
      _ => null,
    };
  } else {
    return null;
  }
}

DynamicConsultationAccordionSection toAccordionSection(Map<String, dynamic> data) {
  return DynamicConsultationAccordionSection(
    data["title"] as String,
    (data["sections"] as List<dynamic>).map((section) => toSection(section)).nonNulls.toList(),
  );
}

DynamicConsultationSectionVideo toVideo(Map<String, dynamic> data) {
  final authorInfo = data["authorInfo"];
  return DynamicConsultationSectionVideo(
    url: data["url"] as String,
    width: data["videoWidth"] as int,
    height: data["videoHeight"] as int,
    authorName: authorInfo?["name"] as String?,
    authorDescription: authorInfo?["message"] as String?,
    date: (authorInfo?["date"] as String?)?.parseToDateTime(),
    transcription: data["transcription"] as String,
  );
}

DynamicConsultationSectionImage toImage(Map<String, dynamic> data) {
  return DynamicConsultationSectionImage(
    desctiption: data["contentDescription"] as String?,
    url: data["url"] as String,
  );
}

DynamicConsultationSectionFocusNumber toFocusNumber(Map<String, dynamic> data) {
  return DynamicConsultationSectionFocusNumber(
    desctiption: data["description"] as String,
    title: data["title"] as String,
  );
}

DynamicConsultationSectionTitle toTitleSection(Map<String, dynamic> data) {
  return DynamicConsultationSectionTitle(data["title"] as String);
}

DynamicConsultationSectionRichText toRichTextSection(Map<String, dynamic> data) {
  return DynamicConsultationSectionRichText(data["description"] as String);
}

DynamicConsultationSectionQuote toQuoteSection(Map<String, dynamic> data) {
  return DynamicConsultationSectionQuote(data["description"] as String);
}
