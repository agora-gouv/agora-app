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
        if (responsesInfos != null)
          _ResponseInfoSection(
            picto: responsesInfos.picto,
            description: responsesInfos.description,
          ),
        _ExpandableSection(
          collapsedSections: consultation.collapsedSections.map(_presentSection).toList(),
          expandedSections: consultation.expandedSections.map(_presentSection).toList(),
        ),
        if (consultation.footer != null)
          _FooterSection(
            title: consultation.footer!.title,
            description: consultation.footer!.description,
          ),
        if (consultation.history == null) _StartButtonTextSection(),
      ],
    );
  }

  static _ViewModelSection _presentSection(DynamicConsultationSection section) {
    return switch (section) {
      DynamicConsultationSectionTitle() => _TitleSection(section.label),
      DynamicConsultationSectionRichText() => _RichTextSection(section.desctiption),
      DynamicConsultationSectionImage() => _TitleSection('TODO ${section.runtimeType}'),
      DynamicConsultationSectionVideo() => _TitleSection('TODO ${section.runtimeType}'),
      DynamicConsultationSectionFocusNumber() => _FocusNumberSection(title: section.title, description: section.desctiption),
      DynamicConsultationSectionAccordion() => _TitleSection('TODO ${section.runtimeType}'),
      DynamicConsultationSectionQuote() => _QuoteSection(description: section.desctiption),
    };
  }
}
