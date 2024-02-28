part of 'consultation_repository.dart';

ConsultationQuestionsInfos? _toQuestionsInfo(dynamic data) {
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

ConsultationResponseInfos? _toResponseInfo(dynamic data, String id) {
  if (data is Map<String, dynamic>) {
    return ConsultationResponseInfos(
      id: id,
      picto: data["picto"] as String,
      description: data["description"] as String,
    );
  } else {
    return null;
  }
}

ConsultationInfoHeader? _toInfoHeader(dynamic data) {
  if (data is Map<String, dynamic>) {
    return ConsultationInfoHeader(
      logo: data["picto"] as String,
      description: data["description"] as String,
    );
  } else {
    return null;
  }
}

ConsultationFooter? _toFooter(dynamic data) {
  if (data is Map<String, dynamic>) {
    return ConsultationFooter(
      title: data["title"] as String?,
      description: data["description"] as String,
    );
  } else {
    return null;
  }
}

ConsultationParticipationInfo? _toParticipationInfo(dynamic data, String shareText) {
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

ConsultationDatesInfos? _toConsultationDateInfo(dynamic data) {
  if (data is Map<String, dynamic>) {
    return ConsultationDatesInfos(
      endDate: (data["endDate"] as String).parseToDateTime(),
      startDate: (data["startDate"] as String).parseToDateTime(),
    );
  } else {
    return null;
  }
}

ConsultationFeedbackQuestion? _toFeedbackQuestion(dynamic data) {
  if (data is Map<String, dynamic>) {
    return ConsultationFeedbackQuestion(
      id: data["updateId"] as String,
      title: data["title"] as String,
      picto: data["picto"] as String,
      description: data["description"] as String,
    );
  } else {
    return null;
  }
}

ConsultationFeedbackResults? _toFeedbackResults(dynamic data) {
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

List<ConsultationHistoryStep>? _toHistory(dynamic data, String id) {
  if (data == null) return null;
  if (data is List) {
    return data.map((e) => _toHistoryStep(e, id)).nonNulls.toList();
  } else {
    return null;
  }
}

ConsultationHistoryStep? _toHistoryStep(dynamic data, String id) {
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

DynamicConsultationSection? _toSection(dynamic data) {
  if (data is Map<String, dynamic>) {
    final type = data["type"] as String;
    return switch (type) {
      "title" => _toTitleSection(data),
      "richText" => _toRichTextSection(data),
      "image" => _toImage(data),
      "video" => _toVideo(data),
      "focusNumber" => _toFocusNumber(data),
      "quote" => _toQuoteSection(data),
      _ => null,
    };
  } else {
    return null;
  }
}

DynamicConsultationSectionVideo _toVideo(Map<String, dynamic> data) {
  return DynamicConsultationSectionVideo(
    url: data["url"] as String,
    width: data["videoWidth"] as int,
    height: data["videoHeight"] as int,
    authorName: data["authorInfo"]["name"] as String,
    authorDescription: data["authorInfo"]["message"] as String,
    date: (data["authorInfo"]["date"] as String?)?.parseToDateTime(),
    transcription: data["transcription"] as String,
  );
}

DynamicConsultationSectionImage _toImage(Map<String, dynamic> data) {
  return DynamicConsultationSectionImage(
    desctiption: data["contentDescription"] as String?,
    url: data["url"] as String,
  );
}

DynamicConsultationSectionFocusNumber _toFocusNumber(Map<String, dynamic> data) {
  return DynamicConsultationSectionFocusNumber(
    desctiption: data["description"] as String,
    title: data["title"] as String,
  );
}

DynamicConsultationSectionTitle _toTitleSection(Map<String, dynamic> data) {
  return DynamicConsultationSectionTitle(data["title"] as String);
}

DynamicConsultationSectionRichText _toRichTextSection(Map<String, dynamic> data) {
  return DynamicConsultationSectionRichText(data["description"] as String);
}

DynamicConsultationSectionQuote _toQuoteSection(Map<String, dynamic> data) {
  return DynamicConsultationSectionQuote(data["description"] as String);
}
