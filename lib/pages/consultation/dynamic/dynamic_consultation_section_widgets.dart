part of 'dynamic_consultation_page.dart';

class _DynamicSectionWidget extends StatelessWidget {
  final _ViewModelSection section;

  _DynamicSectionWidget(this.section);

  @override
  Widget build(BuildContext context) {
    final sectionToDisplay = section;
    return switch (sectionToDisplay) {
      _HeaderSection() => _HeaderSectionWidget(sectionToDisplay),
      _QuestionsInfoSection() => _QuestionsInfoWidget(sectionToDisplay),
      _ResponseInfoSection() => _ResponseInfoSectionWidget(sectionToDisplay),
      _ExpandableSection() => _ExpandableSectionWidget(sectionToDisplay),
      _TitleSection() => _TitleSectionWidget(sectionToDisplay),
      _RichTextSection() => _RichTextSectionWidget(sectionToDisplay),
      _StartButtonTextSection() => _StartButtonWidget(),
      _FooterSection() => _FooterSectionWidget(sectionToDisplay),
      _FocusNumberSection() => _FocusNumberSectionWidget(sectionToDisplay),
      _QuoteSection() => _QuoteSectionWidget(sectionToDisplay),
      _ImageSection() => _ImageSectionWidget(sectionToDisplay),
      _VideoSection() => _VideoSectionWidget(sectionToDisplay),
      _InfoHeaderSection() => _InfoHeaderSectionWidget(sectionToDisplay),
      _DownloadSection() => _DownloadSectionWidget(sectionToDisplay),
      _ConsultationFeedbackQuestionSection() => _ConsultationFeedbackQuestionSectionWidget(sectionToDisplay),
      _ConsultationFeedbackResultsSection() => _ConsultationFeedbackResultsSectionWidget(sectionToDisplay),
      _NotificationSection() => _NotificationSectionWidget(),
      _HistorySection() => _HistorySectionWidget(sectionToDisplay),
    };
  }
}

class _TitleSectionWidget extends StatelessWidget {
  final _TitleSection section;

  _TitleSectionWidget(this.section);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        left: AgoraSpacings.horizontalPadding,
        right: AgoraSpacings.horizontalPadding,
        top: AgoraSpacings.x2,
      ),
      child: Semantics(
        header: true,
        child: Text(
          section.label,
          style: AgoraTextStyles.medium18.copyWith(
            color: AgoraColors.primaryBlue,
          ),
        ),
      ),
    );
  }
}

class _HeaderSectionWidget extends StatelessWidget {
  final _HeaderSection section;

  _HeaderSectionWidget(this.section);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Stack(
          children: [
            Image.network(
              section.coverUrl,
              excludeFromSemantics: true,
              fit: BoxFit.fitHeight,
              height: 300,
            ),
            Positioned(
              bottom: 0,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: AgoraSpacings.x0_5),
                child: Container(
                  width: MediaQuery.sizeOf(context).width - (AgoraSpacings.base),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.vertical(top: Radius.circular(AgoraCorners.defaultRadius)),
                    gradient: LinearGradient(
                      colors: [Colors.white.withOpacity(0.9), Colors.white],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(
                      left: AgoraSpacings.x0_75,
                      right: AgoraSpacings.x0_75,
                      top: AgoraSpacings.x0_75,
                      bottom: AgoraSpacings.x0_25,
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        ExcludeSemantics(child: Text(section.thematicLogo, style: AgoraTextStyles.regular16)),
                        const SizedBox(width: AgoraSpacings.x0_375),
                        Text(section.thematicLabel, style: AgoraTextStyles.regular16),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AgoraSpacings.horizontalPadding),
          child: Text(section.title, style: AgoraTextStyles.medium20),
        ),
        const SizedBox(height: AgoraSpacings.base),
      ],
    );
  }
}

class _QuestionsInfoWidget extends StatelessWidget {
  final _QuestionsInfoSection section;

  _QuestionsInfoWidget(this.section);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AgoraSpacings.horizontalPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: AgoraSpacings.x2),
          _InformationItem(
            image: "ic_calendar.svg",
            text: section.endDate,
            semanticsPrefix: 'Date limite : ',
          ),
          SizedBox(height: AgoraSpacings.x0_75),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Flexible(
                child: _InformationItem(
                  image: "ic_query.svg",
                  text: section.questionCount,
                  semanticsPrefix: '',
                ),
              ),
              SizedBox(width: AgoraSpacings.x0_75),
              Flexible(
                child: _InformationItem(
                  image: "ic_timer.svg",
                  text: section.estimatedTime,
                  semanticsPrefix: 'Temps de réponse estimé :',
                ),
              ),
            ],
          ),
          SizedBox(height: AgoraSpacings.x0_75),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SvgPicture.asset("assets/ic_person.svg", excludeFromSemantics: true),
              SizedBox(width: AgoraSpacings.x0_5),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('${section.participantCount} participants', style: AgoraTextStyles.light14),
                    SizedBox(height: AgoraSpacings.x0_5),
                    ExcludeSemantics(
                      child: LinearProgressIndicator(
                        minHeight: AgoraSpacings.x0_5,
                        backgroundColor: AgoraColors.orochimaru,
                        valueColor: AlwaysStoppedAnimation<Color>(AgoraColors.mountainLakeAzure),
                        value: section.goalProgress,
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),
                    SizedBox(height: AgoraSpacings.x0_5),
                    Text(
                      'Prochain objectif : ${section.participantCountGoal} !',
                      style: AgoraTextStyles.light14,
                    ),
                    SizedBox(height: AgoraSpacings.x0_5),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _InformationItem extends StatelessWidget {
  final String semanticsPrefix;
  final String image;
  final String text;

  _InformationItem({
    required this.semanticsPrefix,
    required this.image,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: semanticsPrefix,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SvgPicture.asset("assets/$image", excludeFromSemantics: true),
          SizedBox(width: AgoraSpacings.x0_5),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(bottom: AgoraSpacings.textAlignment),
              child: Text(text, style: AgoraTextStyles.light14),
            ),
          ),
        ],
      ),
    );
  }
}

class _ExpandableSectionWidget extends StatefulWidget {
  final _ExpandableSection section;

  _ExpandableSectionWidget(this.section);

  @override
  State<_ExpandableSectionWidget> createState() => _ExpandableSectionWidgetState();
}

class _ExpandableSectionWidgetState extends State<_ExpandableSectionWidget> {
  bool expanded = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (!expanded)
          Stack(
            children: [
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: widget.section.collapsedSections.map((section) => _DynamicSectionWidget(section)).toList(),
              ),
              Positioned(
                bottom: 0,
                child: Container(
                  width: MediaQuery.sizeOf(context).width,
                  height: AgoraSpacings.x2,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.white.withOpacity(0), Colors.white],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                ),
              ),
            ],
          ),
        if (expanded) ...widget.section.expandedSections.map((section) => _DynamicSectionWidget(section)),
        if (!expanded)
          _LireLaSuiteButton(
            onTap: () {
              setState(() {
                expanded = true;
              });
            },
          ),
      ],
    );
  }
}

class _LireLaSuiteButton extends StatelessWidget {
  final void Function() onTap;

  _LireLaSuiteButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomLeft,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: AgoraSpacings.x0_5, horizontal: AgoraSpacings.horizontalPadding),
        child: AgoraButton(
          label: 'Lire la suite',
          style: AgoraButtonStyle.blueBorderButtonStyle,
          onPressed: onTap,
        ),
      ),
    );
  }
}

class _RichTextSectionWidget extends StatelessWidget {
  final _RichTextSection section;

  _RichTextSectionWidget(this.section);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        left: AgoraSpacings.horizontalPadding,
        right: AgoraSpacings.horizontalPadding,
        top: AgoraSpacings.base,
      ),
      child: AgoraHtml(data: section.description),
    );
  }
}

class _StartButtonWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AgoraSpacings.horizontalPadding,
        vertical: AgoraSpacings.x2,
      ),
      child: AgoraButton(
        label: ConsultationStrings.beginButton,
        style: AgoraButtonStyle.primaryButtonStyle,
        onPressed: () {
          TrackerHelper.trackClick(
            clickName: "${AnalyticsEventNames.startConsultation} ${'widget.arguments.consultationId'}",
            widgetName: AnalyticsScreenNames.consultationDetailsPage,
          );
          Navigator.pushNamed(
            context,
            ConsultationQuestionPage.routeName,
            arguments: ConsultationQuestionArguments(
              consultationId: 'viewModel.id',
              consultationTitle: 'viewModel.title',
            ),
          );
        },
      ),
    );
  }
}

class _FooterSectionWidget extends StatelessWidget {
  final _FooterSection section;

  _FooterSectionWidget(this.section);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        left: AgoraSpacings.horizontalPadding,
        right: AgoraSpacings.horizontalPadding,
        top: AgoraSpacings.x3,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (section.title != null)
            Text(
              section.title!,
              style: AgoraTextStyles.medium16.copyWith(color: AgoraColors.primaryBlue),
            ),
          if (section.title != null) const SizedBox(height: AgoraSpacings.base),
          AgoraHtml(data: section.description),
        ],
      ),
    );
  }
}

class _ResponseInfoSectionWidget extends StatelessWidget {
  final _ResponseInfoSection section;

  _ResponseInfoSectionWidget(this.section);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        left: AgoraSpacings.horizontalPadding,
        right: AgoraSpacings.horizontalPadding,
        top: AgoraSpacings.base,
      ),
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(AgoraCorners.rounded12),
          border: Border.all(color: AgoraColors.consultationResponseInfoBorder),
          color: AgoraColors.consultationResponseInfo,
        ),
        child: Padding(
          padding: const EdgeInsets.all(AgoraSpacings.base),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Text(section.picto, style: AgoraTextStyles.light24),
                  const SizedBox(width: AgoraSpacings.base),
                  Expanded(child: AgoraHtml(data: section.description)),
                ],
              ),
              const SizedBox(height: AgoraSpacings.base),
              Center(
                child: AgoraButton(
                  label: 'Voir toutes les réponses',
                  style: AgoraButtonStyle.blueBorderButtonStyle,
                  onPressed: () {
                    // TODO : rediriger vers les réponses
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _InfoHeaderSectionWidget extends StatelessWidget {
  final _InfoHeaderSection section;

  _InfoHeaderSectionWidget(this.section);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        left: AgoraSpacings.horizontalPadding,
        right: AgoraSpacings.horizontalPadding,
        top: AgoraSpacings.base,
      ),
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(AgoraCorners.rounded12),
          border: Border.all(color: AgoraColors.consultationResponseInfoBorder),
          color: AgoraColors.consultationResponseInfo,
        ),
        child: Padding(
          padding: const EdgeInsets.all(AgoraSpacings.base),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: [
              Text(section.logo, style: AgoraTextStyles.light24),
              const SizedBox(width: AgoraSpacings.base),
              Expanded(child: AgoraHtml(data: section.description)),
            ],
          ),
        ),
      ),
    );
  }
}

class _FocusNumberSectionWidget extends StatelessWidget {
  final _FocusNumberSection section;

  _FocusNumberSectionWidget(this.section);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        left: AgoraSpacings.horizontalPadding,
        right: AgoraSpacings.horizontalPadding,
        top: AgoraSpacings.base,
      ),
      child: IntrinsicHeight(
        child: Row(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(width: 2, height: 40, color: AgoraColors.blue525),
            const SizedBox(width: AgoraSpacings.base),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(section.title, style: AgoraTextStyles.regular50),
                  const SizedBox(width: AgoraSpacings.base),
                  AgoraRichText(
                    policeStyle: AgoraRichTextPoliceStyle.police14,
                    items: [
                      ...parseSimpleHtml(section.description)
                          .map((data) => AgoraRichTextItem(text: data.text, style: data.style)),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _QuoteSectionWidget extends StatelessWidget {
  final _QuoteSection section;

  _QuoteSectionWidget(this.section);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        left: AgoraSpacings.horizontalPadding,
        right: AgoraSpacings.horizontalPadding,
        top: AgoraSpacings.base,
      ),
      child: IntrinsicHeight(
        child: Row(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(width: 2, height: 40, color: AgoraColors.blue525),
            const SizedBox(width: AgoraSpacings.base),
            Expanded(
              child: AgoraRichText(
                policeStyle: AgoraRichTextPoliceStyle.police14,
                items: [
                  ...parseSimpleHtml(section.description)
                      .map((data) => AgoraRichTextItem(text: data.text, style: data.style)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ImageSectionWidget extends StatelessWidget {
  final _ImageSection section;

  _ImageSectionWidget(this.section);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        left: AgoraSpacings.horizontalPadding,
        right: AgoraSpacings.horizontalPadding,
        top: AgoraSpacings.base,
      ),
      child: Image.network(
        section.url,
        excludeFromSemantics: section.desctiption == null,
        semanticLabel: section.desctiption,
      ),
    );
  }
}

class _VideoSectionWidget extends StatelessWidget {
  final _VideoSection section;

  _VideoSectionWidget(this.section);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        left: AgoraSpacings.horizontalPadding,
        right: AgoraSpacings.horizontalPadding,
        top: AgoraSpacings.base,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AgoraVideoView(
            videoUrl: section.url,
            videoWidth: section.width,
            videoHeight: section.height,
            onVideoStartMoreThan5Sec: () {
              TrackerHelper.trackEvent(
                eventName: "${AnalyticsEventNames.video} 'consultationId'",
                widgetName: AnalyticsScreenNames.consultationSummaryEtEnsuitePage,
              );
            },
            isTalkbackActivated: MediaQuery.accessibleNavigationOf(context),
          ),
          const SizedBox(height: AgoraSpacings.base),
          Semantics(
            header: true,
            child: RichText(
              textScaler: MediaQuery.of(context).textScaler,
              text: TextSpan(
                style: AgoraTextStyles.light16.copyWith(color: AgoraColors.primaryGreyOpacity80),
                children: [
                  TextSpan(text: QagStrings.by),
                  WidgetSpan(child: SizedBox(width: AgoraSpacings.x0_25)),
                  TextSpan(
                    text: section.authorName,
                    style: AgoraTextStyles.medium16.copyWith(color: AgoraColors.primaryGreyOpacity90),
                  ),
                ],
              ),
            ),
          ),
          if (section.authorDescription != null) const SizedBox(height: AgoraSpacings.x0_5),
          if (section.authorDescription != null) AgoraHtml(data: section.authorDescription!),
          if (section.date != null) SizedBox(height: AgoraSpacings.x0_5),
          if (section.date != null)
            RichText(
              textScaler: MediaQuery.of(context).textScaler,
              text: TextSpan(
                style: AgoraTextStyles.light16.copyWith(color: AgoraColors.primaryGreyOpacity80),
                children: [
                  TextSpan(text: QagStrings.at),
                  WidgetSpan(child: SizedBox(width: AgoraSpacings.x0_25)),
                  TextSpan(
                    text: section.date,
                    style: AgoraTextStyles.mediumItalic16.copyWith(color: AgoraColors.primaryGreyOpacity80),
                  ),
                ],
              ),
            ),
          SizedBox(height: AgoraSpacings.base),
          Semantics(header: true, child: Text(QagStrings.transcription, style: AgoraTextStyles.medium18)),
          SizedBox(height: AgoraSpacings.x0_5),
          Text(section.transcription, style: AgoraTextStyles.light14),
        ],
      ),
    );
  }
}

class _DownloadSectionWidget extends StatelessWidget {
  final _DownloadSection section;

  _DownloadSectionWidget(this.section);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        left: AgoraSpacings.horizontalPadding,
        right: AgoraSpacings.horizontalPadding,
        top: AgoraSpacings.base,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: [
          Text('📘', style: AgoraTextStyles.light26),
          const SizedBox(width: AgoraSpacings.base),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: [
                Semantics(
                  header: true,
                  child: Text(
                    'Téléchargez la synthèse complète',
                    style: AgoraTextStyles.medium16.copyWith(
                      color: AgoraColors.primaryBlue,
                    ),
                  ),
                ),
                const SizedBox(height: AgoraSpacings.x0_25),
                Text(
                  'Retrouvez les réponses détaillées et toutes les analyses en PDF',
                  style: AgoraTextStyles.light16,
                ),
                const SizedBox(height: AgoraSpacings.base),
                Align(
                  alignment: Alignment.topLeft,
                  child: AgoraButton(
                    label: 'Télécharger',
                    semanticLabel: 'Télécharger la synthèse complète',
                    style: AgoraButtonStyle.blueBorderButtonStyle,
                    onPressed: () {
                      LaunchUrlHelper.launchUrlFromAgora(
                        url: section.url,
                        launchMode: LaunchMode.externalApplication,
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ConsultationFeedbackQuestionSectionWidget extends StatelessWidget {
  final _ConsultationFeedbackQuestionSection section;

  _ConsultationFeedbackQuestionSectionWidget(this.section);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        left: AgoraSpacings.horizontalPadding,
        right: AgoraSpacings.horizontalPadding,
        top: AgoraSpacings.base,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: [
          Text(section.picto, style: AgoraTextStyles.light26),
          const SizedBox(width: AgoraSpacings.base),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: [
                Semantics(
                  header: true,
                  child: Text(
                    section.title,
                    style: AgoraTextStyles.medium16.copyWith(
                      color: AgoraColors.primaryBlue,
                    ),
                  ),
                ),
                const SizedBox(height: AgoraSpacings.x0_25),
                AgoraHtml(data: section.description),
                const SizedBox(height: AgoraSpacings.base),
                Row(
                  children: [
                    AgoraRoundedButton(
                      icon: "ic_thumb_white.svg",
                      label: QagStrings.utils,
                      contentPadding: AgoraRoundedButtonPadding.short,
                      onPressed: () {
                        // TODO
                      },
                    ),
                    SizedBox(width: AgoraSpacings.base),
                    AgoraRoundedButton(
                      icon: "ic_thumb_down_white.svg",
                      label: QagStrings.notUtils,
                      contentPadding: AgoraRoundedButtonPadding.short,
                      onPressed: () {
                        // TODO
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ConsultationFeedbackResultsSectionWidget extends StatelessWidget {
  final _ConsultationFeedbackResultsSection section;

  _ConsultationFeedbackResultsSectionWidget(this.section);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        left: AgoraSpacings.horizontalPadding,
        right: AgoraSpacings.horizontalPadding,
        top: AgoraSpacings.base,
      ),
      child: Text(QagStrings.feedback),
    );
  }
}

class _NotificationSectionWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        left: AgoraSpacings.horizontalPadding,
        right: AgoraSpacings.horizontalPadding,
        top: AgoraSpacings.x2,
        bottom: AgoraSpacings.x2,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SvgPicture.asset(
            "assets/ic_bell.svg",
            colorFilter: ColorFilter.mode(AgoraColors.primaryBlue, BlendMode.srcIn),
            excludeFromSemantics: true,
          ),
          SizedBox(width: AgoraSpacings.x0_75),
          Expanded(
            child: Text(
              ConsultationStrings.notificationInformation,
              style: AgoraTextStyles.light14,
            ),
          ),
        ],
      ),
    );
  }
}

class _HistorySectionWidget extends StatelessWidget {
  final _HistorySection section;

  _HistorySectionWidget(this.section);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        top: AgoraSpacings.base,
      ),
      child: DecoratedBox(
        decoration: BoxDecoration(color: AgoraColors.consultationResponseInfo),
        child: Padding(
          padding: const EdgeInsets.only(
            left: AgoraSpacings.horizontalPadding,
            right: AgoraSpacings.horizontalPadding,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: AgoraSpacings.base),
              Semantics(
                header: true,
                child: Text(
                  'Historique',
                  style: AgoraTextStyles.medium16.copyWith(
                    color: AgoraColors.primaryBlue,
                  ),
                ),
              ),
              const SizedBox(height: AgoraSpacings.x2),
              ...section.steps.mapIndexed((i, e) => _HistoryElementWidget(e, i == section.steps.length - 1)),
            ],
          ),
        ),
      ),
    );
  }
}

class _HistoryElementWidget extends StatelessWidget {
  final ConsultationHistoryStep step;
  final bool isLast;

  _HistoryElementWidget(this.step, this.isLast);

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(
            width: 30,
            height: 30,
            child: Stack(
              children: [
                if (!isLast)
                  Transform.translate(
                    offset: Offset(0, 2),
                    child: Center(child: Container(width: 2, color: AgoraColors.consultationResponseInfoBorder)),
                  ),
                _HistoryIndicator(step.status),
              ],
            ),
          ),
          const SizedBox(width: AgoraSpacings.base),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(step.title, style: AgoraTextStyles.medium18),
                Text(
                  step.date?.formatToDayMonthYear() ?? 'Prochainement',
                  style: AgoraTextStyles.regular16.copyWith(fontStyle: FontStyle.italic),
                ),
                if (step.actionText != null) Text(step.actionText!, style: AgoraTextStyles.regular16UnderlineBlue),
                const SizedBox(height: AgoraSpacings.x2),
              ],
            ),
          ),
          step.actionText != null
              ? SvgPicture.asset("assets/ic_next.svg", excludeFromSemantics: true)
              : SizedBox(height: 48, width: 48),
          const SizedBox(width: AgoraSpacings.base),
        ],
      ),
    );
  }
}

class _HistoryIndicator extends StatelessWidget {
  final ConsultationHistoryStepStatus status;

  _HistoryIndicator(this.status);

  @override
  Widget build(BuildContext context) {
    return DottedBorder(
      strokeWidth: 2,
      dashPattern: [2, 2],
      borderType: BorderType.Circle,
      color: status == ConsultationHistoryStepStatus.current ? AgoraColors.blue525 : Colors.transparent,
      child: Padding(
        padding: const EdgeInsets.all(1),
        child: Container(
          width: 24,
          height: 24,
          decoration: BoxDecoration(
            border: Border.all(color: AgoraColors.blue525, width: 2),
            borderRadius: AgoraCorners.borderRound,
            color: status == ConsultationHistoryStepStatus.done
                ? AgoraColors.blue525
                : AgoraColors.consultationResponseInfo,
          ),
          child: Icon(
            status == ConsultationHistoryStepStatus.incoming ? Icons.more_horiz : Icons.check,
            color: status == ConsultationHistoryStepStatus.done
                ? AgoraColors.consultationResponseInfo
                : AgoraColors.blue525,
            size: 16,
          ),
        ),
      ),
    );
  }
}
