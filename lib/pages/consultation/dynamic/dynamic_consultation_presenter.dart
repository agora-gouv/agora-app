part of 'dynamic_consultation_page.dart';

class _Presenter {
  static _ViewModel getViewModelFromState(DynamicConsultationState state) {
    return switch (state) {
      DynamicConsultationLoadingState() => _LoadingViewModel(),
      DynamicConsultationErrorState() => _ErrorViewModel(),
      DynamicConsultationSuccessState() => _presentSuccess(state.consultation),
    };
  }

  static _SuccessViewModel _presentSuccess(DynamicConsultation consultation) {
    final questionsInfos = consultation.questionsInfos;
    final responsesInfos = consultation.responseInfos;
    final consultationHeaderInfo = consultation.infoHeader;
    final feedbackResult = consultation.feedbackResult;
    final feedbackQuestion = consultation.feedbackQuestion;
    final download = consultation.downloadInfo;
    final history = consultation.history;
    final participationInfo = consultation.participationInfo;
    return _SuccessViewModel(
      shareText: consultation.shareText,
      sections: [
        _HeaderSection(
          coverUrl: consultation.coverUrl,
          thematicLabel: consultation.thematicLabel,
          thematicLogo: consultation.thematicLogo,
          title: consultation.title,
        ),
        if (questionsInfos != null)
          _QuestionsInfoSection(
            endDate: ConsultationStrings.endDate.format(questionsInfos.endDate.formatToDayMonth()),
            questionCount: questionsInfos.questionCount,
            estimatedTime: questionsInfos.estimatedTime,
            participantCount: questionsInfos.participantCount,
            participantCountGoal: questionsInfos.participantCountGoal,
            goalProgress: min(1, questionsInfos.participantCount / questionsInfos.participantCountGoal),
          ),
        if (consultationHeaderInfo != null)
          _InfoHeaderSection(
            description: consultationHeaderInfo.description,
            logo: consultationHeaderInfo.logo,
          ),
        if (responsesInfos != null)
          _ResponseInfoSection(
            picto: responsesInfos.picto,
            description: responsesInfos.description,
          ),
        _ExpandableSection(
          collapsedSections: consultation.collapsedSections.map(_presentSection).toList(),
          expandedSections: consultation.expandedSections.map(_presentSection).toList(),
        ),
        if (feedbackResult != null)
          _ConsultationFeedbackResultsSection(
            id: feedbackResult.id,
            title: feedbackResult.title,
            picto: feedbackResult.picto,
            description: feedbackResult.description,
            userResponseIsPositive: feedbackResult.userResponseIsPositive,
            positiveRatio: feedbackResult.positiveRatio,
            negativeRation: feedbackResult.negativeRatio,
            responseCount: feedbackResult.responseCount,
          ),
        if (feedbackQuestion != null)
          _ConsultationFeedbackQuestionSection(
            title: feedbackQuestion.title,
            picto: feedbackQuestion.picto,
            description: feedbackQuestion.description,
            id: feedbackQuestion.id,
          ),
        if (download != null) _DownloadSection(url: download.url),
        if (participationInfo != null)
          _ParticipantInfoSection(
            participantCountGoal: participationInfo.participantCountGoal,
            participantCount: participationInfo.participantCount,
            shareText: participationInfo.shareText,
          ),
        if (consultation.footer != null)
          _FooterSection(
            title: consultation.footer!.title,
            description: consultation.footer!.description,
          ),
        if (history == null) _StartButtonTextSection(consultationId: consultation.id, title: consultation.title),
        if (history != null) _HistorySection(history),
        if (history != null) _NotificationSection(),
      ],
    );
  }

  static _ViewModelSection _presentSection(DynamicConsultationSection section) {
    return switch (section) {
      DynamicConsultationSectionTitle() => _TitleSection(section.label),
      DynamicConsultationSectionRichText() => _RichTextSection(section.desctiption),
      DynamicConsultationSectionImage() => _ImageSection(desctiption: section.desctiption, url: section.url),
      DynamicConsultationSectionVideo() => _VideoSection(
          url: section.url,
          transcription: section.transcription,
          width: section.width,
          height: section.height,
          authorName: section.authorName,
          authorDescription: section.authorDescription,
          date: section.date?.formatToDayMonth(),
        ),
      DynamicConsultationSectionFocusNumber() =>
        _FocusNumberSection(title: section.title, description: section.desctiption),
      DynamicConsultationSectionAccordion() => _TitleSection('TODO ${section.runtimeType}'),
      DynamicConsultationSectionQuote() => _QuoteSection(description: section.desctiption),
    };
  }
}
