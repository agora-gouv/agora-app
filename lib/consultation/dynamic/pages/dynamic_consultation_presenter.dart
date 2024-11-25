part of 'dynamic_consultation_page.dart';

class DynamicConsultationPresenter {
  static DynamicConsultationViewModel getViewModelFromState(DynamicConsultationState state) {
    return switch (state) {
      DynamicConsultationLoadingState() => _LoadingViewModel(),
      DynamicConsultationErrorState() => _ErrorViewModel(),
      DynamicConsultationSuccessState() => _presentSuccess(state.consultation, state.referentiel),
    };
  }

  static _SuccessViewModel _presentSuccess(DynamicConsultation consultation, List<Territoire> referentiel) {
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
      consultationId: consultation.id,
      sections: [
        _HeaderSection(
          coverUrl: consultation.coverUrl,
          thematicLabel: consultation.thematicLabel,
          thematicLogo: consultation.thematicLogo,
          title: consultation.title,
          territoire: getTerritoireFromReferentiel(referentiel, consultation.territoire),
        ),
        if (consultation.isOnGoing() && questionsInfos != null)
          _QuestionsInfoSection(
            endDate: ConsultationStrings.endDate.format(questionsInfos.endDate.formatToDayLongMonth()),
            questionCount: questionsInfos.questionCount,
            estimatedTime: questionsInfos.estimatedTime,
            participantCount: questionsInfos.participantCount,
            participantCountGoal: questionsInfos.participantCountGoal,
            goalProgress: min(1, questionsInfos.participantCount / questionsInfos.participantCountGoal),
          ),
        if (consultationHeaderInfo != null)
          InfoHeaderSection(
            description: consultationHeaderInfo.description,
            logo: consultationHeaderInfo.logo,
          ),
        if (responsesInfos != null)
          ResponseInfoSection(
            id: responsesInfos.id,
            picto: responsesInfos.picto,
            description: responsesInfos.description,
            buttonLabel: responsesInfos.buttonLabel,
          ),
        ExpandableSection(
          headerSections:
              consultation.headerSections.map((section) => presentSection(consultation.id, section)).toList(),
          previewSections:
              consultation.collapsedSections.map((section) => presentSection(consultation.id, section)).toList(),
          expandedSections:
              consultation.expandedSections.map((section) => presentSection(consultation.id, section)).toList(),
        ),
        if (download != null) DownloadSection(url: download.url),
        if (consultation.isOnGoing())
          ParticipantInfoSection(
            participantCountGoal: participationInfo.participantCountGoal,
            participantCount: participationInfo.participantCount,
            shareText: participationInfo.shareText,
          ),
        if (consultation.footer != null)
          FooterSection(
            title: consultation.footer!.title,
            description: consultation.footer!.description,
          ),
        if (consultation.goals != null) GoalSection(consultation.goals!),
        if (feedbackResult != null)
          ConsultationFeedbackResultsSection(
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
          ConsultationFeedbackQuestionSection(
            title: feedbackQuestion.title,
            picto: feedbackQuestion.picto,
            description: feedbackQuestion.description,
            id: feedbackQuestion.id,
            consultationId: consultation.id,
            userResponse: feedbackQuestion.userResponse,
          ),
        if (consultation.isOnGoing())
          StartButtonTextSection(consultationId: consultation.id, title: consultation.title),
        if (!consultation.isOnGoing()) HistorySection(consultation.id, history),
        if (!consultation.isOnGoing()) NotificationSection(),
      ],
    );
  }

  static DynamicViewModelSection presentSection(String consultationId, DynamicConsultationSection section) {
    return switch (section) {
      DynamicConsultationSectionTitle() => _TitleSection(section.label),
      DynamicConsultationSectionRichText() => _RichTextSection(section.desctiption),
      DynamicConsultationSectionImage() => _ImageSection(desctiption: section.desctiption, url: section.url),
      DynamicConsultationSectionVideo() => _VideoSection(
          consultationId: consultationId,
          url: section.url,
          transcription: section.transcription,
          width: section.width,
          height: section.height,
          authorName: section.authorName,
          authorDescription: section.authorDescription,
          date: section.date?.formatToDayMonthYear(),
        ),
      DynamicConsultationSectionFocusNumber() =>
        _FocusNumberSection(title: section.title, description: section.desctiption),
      DynamicConsultationSectionAccordion() => _TitleSection('TODO ${section.runtimeType}'),
      DynamicConsultationSectionQuote() => _QuoteSection(description: section.desctiption),
      DynamicConsultationAccordionSection() => _AccordionSection(
          title: section.title,
          sections: section.expandedSections.map((subSection) => presentSection(consultationId, subSection)).toList(),
        ),
    };
  }
}
