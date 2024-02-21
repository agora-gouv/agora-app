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
    return _SuccessViewModel(
      shareText: consultation.shareText,
      sections: [
        _HeaderSection(
          coverUrl: consultation.coverUrl,
          thematicLabel: consultation.thematicLabel,
          thematicLogo: consultation.thematicLogo,
        ),
        if (questionsInfos != null)
          _QuestionsInfoSection(
            endDate: ConsultationStrings.endDate.format(questionsInfos.endDate.formatToDayMonth()),
            questionCount: questionsInfos.questionCount,
            estimatedTime: questionsInfos.estimatedTime,
            participantCount: questionsInfos.participantCount,
            participantCountGoal: questionsInfos.participantCountGoal,
            goalProgress:
                (100 * min(100, questionsInfos.participantCount / questionsInfos.participantCountGoal)).round(),
          ),
        _ExpandableSection(
          collapsedSections: consultation.collapsedSections.map(_presentSection).toList(),
          expandedSections: consultation.expandedSections.map(_presentSection).toList(),
        ),
        if (consultation.history == null)
          _StartButtonTextSection(),
      ],
    );
  }

  static _ViewModelSection _presentSection(DynamicConsultationSection section) {
    return _TitleSection('TODO ${section.runtimeType}');
  }
}
