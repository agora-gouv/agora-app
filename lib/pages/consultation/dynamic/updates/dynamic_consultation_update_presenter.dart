part of 'dynamic_consultation_update_page.dart';

class _Presenter {
  static _ViewModel getViewModelFromState(DynamicConsultationUpdatesState state) {
    return switch (state) {
      DynamicConsultationUpdatesLoadingState() => _LoadingViewModel(),
      DynamicConsultationUpdatesErrorState() => _ErrorViewModel(),
      DynamicConsultationUpdatesSuccessState() => _presentSuccess(state.update),
    };
  }

  static _SuccessViewModel _presentSuccess(DynamicConsultationUpdate consultation) {
    final responsesInfos = consultation.responseInfos;
    final consultationHeaderInfo = consultation.infoHeader;
    final feedbackResult = consultation.feedbackResult;
    final feedbackQuestion = consultation.feedbackQuestion;
    final download = consultation.downloadInfo;
    final participationInfo = consultation.participationInfo;
    final consultationDatesInfos = consultation.consultationDatesInfos;
    return _SuccessViewModel(
      consultationId: consultation.id,
      shareText: consultation.shareText,
      sections: [
        if (consultationDatesInfos != null)
          ConsultationDatesInfosSection(
            label:
                'Du ${consultationDatesInfos.startDate.formatToDayMonth()} au ${consultationDatesInfos.endDate.formatToDayMonth()}',
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
          ),
        ExpandableSection(
          collapsedSections: consultation.collapsedSections.map(DynamicConsultationPresenter.presentSection).toList(),
          expandedSections: consultation.expandedSections.map(DynamicConsultationPresenter.presentSection).toList(),
        ),
        if (download != null) DownloadSection(url: download.url),
        if (participationInfo != null)
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
          ),
        NotificationSection(),
      ],
    );
  }
}
