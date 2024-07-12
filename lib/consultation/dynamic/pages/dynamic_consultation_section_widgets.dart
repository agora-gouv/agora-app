part of 'dynamic_consultation_page.dart';

class DynamicConsultationSectionWidget extends StatelessWidget {
  final DynamicViewModelSection section;

  DynamicConsultationSectionWidget(this.section);

  @override
  Widget build(BuildContext context) {
    final sectionToDisplay = section;
    final isTalkbackEnabled = MediaQuery.accessibleNavigationOf(context);

    return switch (sectionToDisplay) {
      _TitleSection() => _TitleSectionWidget(sectionToDisplay),
      HeaderSection() => _HeaderSectionWidget(sectionToDisplay),
      QuestionsInfoSection() => _QuestionsInfoWidget(sectionToDisplay),
      ConsultationDatesInfosSection() => _ConsultationDatesInfosSectionWidget(sectionToDisplay),
      ResponseInfoSection() => _ResponseInfoSectionWidget(sectionToDisplay),
      ExpandableSection() => _ExpandableSectionWidget(sectionToDisplay, isTalkbackEnabled: isTalkbackEnabled),
      _RichTextSection() => _RichTextSectionWidget(sectionToDisplay),
      StartButtonTextSection() => _StartButtonWidget(sectionToDisplay),
      FooterSection() => _FooterSectionWidget(sectionToDisplay),
      _FocusNumberSection() => _FocusNumberSectionWidget(sectionToDisplay),
      _QuoteSection() => _QuoteSectionWidget(sectionToDisplay),
      _ImageSection() => _ImageSectionWidget(sectionToDisplay),
      _VideoSection() => _VideoSectionWidget(sectionToDisplay, isTalkbackEnabled: isTalkbackEnabled),
      InfoHeaderSection() => _InfoHeaderSectionWidget(sectionToDisplay),
      DownloadSection() => _DownloadSectionWidget(sectionToDisplay),
      ConsultationFeedbackQuestionSection() => _ConsultationFeedbackQuestionSectionWidget(sectionToDisplay),
      ConsultationFeedbackResultsSection() => _ConsultationFeedbackResultsSectionWidget(sectionToDisplay),
      NotificationSection() => _NotificationSectionWidget(),
      HistorySection() => _HistorySectionWidget(sectionToDisplay),
      ParticipantInfoSection() => _ParticipantInfoSectionWidget(sectionToDisplay),
      _AccordionSection() => _AccordionSectionWidget(sectionToDisplay),
      GoalSection() => _GoalsSectionWidget(sectionToDisplay),
      HeaderSectionUpdate() => HeaderSectionUpdateWidget(sectionToDisplay),
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

class HeaderSectionUpdateWidget extends StatelessWidget {
  final HeaderSectionUpdate section;
  final double horizontalPadding;

  HeaderSectionUpdateWidget(this.section, [this.horizontalPadding = AgoraSpacings.horizontalPadding]);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: horizontalPadding,
        right: horizontalPadding,
        top: AgoraSpacings.base,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(50),
            child: Image.network(
              section.coverUrl,
              excludeFromSemantics: true,
              fit: BoxFit.fitHeight,
              height: 50,
              width: 50,
            ),
          ),
          const SizedBox(width: AgoraSpacings.base),
          Expanded(
            child: Text(
              section.title,
              style: AgoraTextStyles.medium16,
            ),
          ),
        ],
      ),
    );
  }
}

class _HeaderSectionWidget extends StatelessWidget {
  final HeaderSection section;

  _HeaderSectionWidget(this.section);

  @override
  Widget build(BuildContext context) {
    return Semantics(
      container: true,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Stack(
            children: [
              AspectRatio(
                aspectRatio: 375 / 162,
                child: Image.network(
                  section.coverUrl,
                  excludeFromSemantics: true,
                  fit: BoxFit.fitWidth,
                  width: MediaQuery.sizeOf(context).width,
                ),
              ),
              Positioned(
                bottom: -1,
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
                          Expanded(child: Text(section.thematicLabel, style: AgoraTextStyles.regular16)),
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
      ),
    );
  }
}

class _QuestionsInfoWidget extends StatelessWidget {
  final QuestionsInfoSection section;

  _QuestionsInfoWidget(this.section);

  @override
  Widget build(BuildContext context) {
    return Semantics(
      container: true,
      child: Padding(
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
      ),
    );
  }
}

class _ConsultationDatesInfosSectionWidget extends StatelessWidget {
  final ConsultationDatesInfosSection section;

  _ConsultationDatesInfosSectionWidget(this.section);

  @override
  Widget build(BuildContext context) {
    return Semantics(
      container: true,
      child: Padding(
        padding: const EdgeInsets.only(
          left: AgoraSpacings.horizontalPadding,
          right: AgoraSpacings.horizontalPadding,
          top: AgoraSpacings.x2,
          bottom: AgoraSpacings.x0_75,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            Semantics(
              header: true,
              child: Text(
                'Lancement de la consultation',
                style: AgoraTextStyles.medium22.copyWith(
                  color: AgoraColors.primaryBlue,
                ),
              ),
            ),
            _InformationItem(
              image: "ic_calendar.svg",
              text: section.label,
              semanticsPrefix: 'Dates de la consultation : ',
              style: AgoraTextStyles.lightItalic16,
            ),
          ],
        ),
      ),
    );
  }
}

class _InformationItem extends StatelessWidget {
  final String semanticsPrefix;
  final String image;
  final String text;
  final TextStyle style;

  _InformationItem({
    required this.semanticsPrefix,
    required this.image,
    required this.text,
    this.style = AgoraTextStyles.light14,
  });

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: semanticsPrefix,
      container: true,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SvgPicture.asset("assets/$image", excludeFromSemantics: true),
          SizedBox(width: AgoraSpacings.x0_5),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(bottom: AgoraSpacings.textAlignment),
              child: Text(text, style: style),
            ),
          ),
        ],
      ),
    );
  }
}

class _GoalsSectionWidget extends StatelessWidget {
  final GoalSection section;

  _GoalsSectionWidget(this.section);

  @override
  Widget build(BuildContext context) {
    return Semantics(
      container: true,
      child: Padding(
        padding: const EdgeInsets.only(
          left: AgoraSpacings.horizontalPadding,
          right: AgoraSpacings.horizontalPadding,
          top: AgoraSpacings.x3,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: section.goals.map((goal) => _GoalRow(goal)).toList(),
        ),
      ),
    );
  }
}

class _GoalRow extends StatelessWidget {
  final ConsultationGoal goal;

  _GoalRow(this.goal);

  @override
  Widget build(BuildContext context) {
    return Semantics(
      container: true,
      child: Padding(
        padding: const EdgeInsets.only(bottom: AgoraSpacings.base),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: [
            ExcludeSemantics(child: Text(goal.picto, style: AgoraTextStyles.regular26)),
            const SizedBox(width: AgoraSpacings.base),
            Expanded(child: AgoraHtml(data: goal.description)),
          ],
        ),
      ),
    );
  }
}

class _AccordionSectionWidget extends StatelessWidget {
  final _AccordionSection section;

  _AccordionSectionWidget(this.section);

  @override
  Widget build(BuildContext context) {
    return Semantics(
      container: true,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: AgoraSpacings.x0_5),
        child: AgoraCollapseView(
          title: section.title,
          collapseContent: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: section.sections.map((subSection) => DynamicConsultationSectionWidget(subSection)).toList(),
          ),
        ),
      ),
    );
  }
}

class _ExpandableSectionWidget extends StatefulWidget {
  final ExpandableSection section;
  final bool isTalkbackEnabled;

  _ExpandableSectionWidget(this.section, {required this.isTalkbackEnabled});

  @override
  State<_ExpandableSectionWidget> createState() => _ExpandableSectionWidgetState();
}

class _ExpandableSectionWidgetState extends State<_ExpandableSectionWidget> {
  bool _isExpanded = false;
  bool _arePreviewAndExpandedFilled = true;

  @override
  void initState() {
    _isExpanded = false || widget.isTalkbackEnabled;
    _arePreviewAndExpandedFilled =
        widget.section.previewSections.isNotEmpty && widget.section.expandedSections.isNotEmpty;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ...widget.section.headerSections.map((section) => DynamicConsultationSectionWidget(section)),
        if (!_isExpanded && _arePreviewAndExpandedFilled)
          Stack(
            children: [
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children:
                    widget.section.previewSections.map((section) => DynamicConsultationSectionWidget(section)).toList(),
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
        if (_isExpanded || (widget.section.previewSections.isEmpty && widget.section.expandedSections.isNotEmpty))
          ...widget.section.expandedSections.map((section) => DynamicConsultationSectionWidget(section)),
        if (!_isExpanded && _arePreviewAndExpandedFilled)
          ShowMoreButton(
            onTap: () {
              setState(() {
                _isExpanded = true;
              });
            },
          ),
      ],
    );
  }
}

class ShowMoreButton extends StatelessWidget {
  final void Function() onTap;
  final String label;
  final double horizontalPadding;

  ShowMoreButton({
    required this.onTap,
    this.label = 'Lire la suite',
    this.horizontalPadding = AgoraSpacings.horizontalPadding,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomLeft,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: AgoraSpacings.x0_5, horizontal: horizontalPadding),
        child: AgoraButton(
          label: label,
          buttonStyle: AgoraButtonStyle.blueBorder,
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
    return Semantics(
      container: true,
      child: Padding(
        padding: const EdgeInsets.only(
          left: AgoraSpacings.horizontalPadding,
          right: AgoraSpacings.horizontalPadding,
          top: AgoraSpacings.base,
        ),
        child: AgoraHtml(data: section.description),
      ),
    );
  }
}

class _StartButtonWidget extends StatelessWidget {
  final StartButtonTextSection section;

  _StartButtonWidget(this.section);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AgoraSpacings.horizontalPadding,
        vertical: AgoraSpacings.x2,
      ),
      child: SizedBox(
        width: double.infinity,
        child: FloatingActionButton.extended(
          focusColor: AgoraColors.neutral400,
          backgroundColor: AgoraColors.primaryBlue,
          label: Text(
            ConsultationStrings.beginButton,
            semanticsLabel: ConsultationStrings.beginButtonDescription,
            style: AgoraTextStyles.primaryFloatingButton,
          ),
          onPressed: () {
            TrackerHelper.trackClick(
              clickName: "${AnalyticsEventNames.startConsultation} ${section.consultationId}",
              widgetName: AnalyticsScreenNames.consultationDetailsPage,
            );
            Navigator.pushNamed(
              context,
              ConsultationQuestionPage.routeName,
              arguments: ConsultationQuestionArguments(
                consultationId: section.consultationId,
                consultationTitle: section.title,
              ),
            ).then((value) => Navigator.of(context).pop());
          },
        ),
      ),
    );
  }
}

class _FooterSectionWidget extends StatelessWidget {
  final FooterSection section;

  _FooterSectionWidget(this.section);

  @override
  Widget build(BuildContext context) {
    return Semantics(
      container: true,
      child: Padding(
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
      ),
    );
  }
}

class _ResponseInfoSectionWidget extends StatelessWidget {
  final ResponseInfoSection section;

  _ResponseInfoSectionWidget(this.section);

  @override
  Widget build(BuildContext context) {
    return Semantics(
      container: true,
      child: Padding(
        padding: const EdgeInsets.only(
          left: AgoraSpacings.horizontalPadding,
          right: AgoraSpacings.horizontalPadding,
          top: AgoraSpacings.x2_5,
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
                    ExcludeSemantics(child: Text(section.picto, style: AgoraTextStyles.light24)),
                    const SizedBox(width: AgoraSpacings.base),
                    Expanded(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          AgoraHtml(data: section.description),
                          const SizedBox(height: AgoraSpacings.base),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: AgoraButton(
                              label: section.buttonLabel,
                              buttonStyle: AgoraButtonStyle.blueBorder,
                              onPressed: () {
                                Navigator.pushNamed(
                                  context,
                                  DynamicConsultationResultsPage.routeName,
                                  arguments: section.id,
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _InfoHeaderSectionWidget extends StatelessWidget {
  final InfoHeaderSection section;

  _InfoHeaderSectionWidget(this.section);

  @override
  Widget build(BuildContext context) {
    return Semantics(
      container: true,
      child: Padding(
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
                ExcludeSemantics(child: Text(section.logo, style: AgoraTextStyles.light24)),
                const SizedBox(width: AgoraSpacings.base),
                Expanded(child: AgoraHtml(data: section.description)),
              ],
            ),
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
    return Semantics(
      container: true,
      child: Padding(
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
                      policeStyle: AgoraRichTextPoliceStyle.police14Interligne140,
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
      ),
    );
  }
}

class _QuoteSectionWidget extends StatelessWidget {
  final _QuoteSection section;

  _QuoteSectionWidget(this.section);

  @override
  Widget build(BuildContext context) {
    return Semantics(
      container: true,
      child: Padding(
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
                  policeStyle: AgoraRichTextPoliceStyle.police14Interligne140,
                  items: [
                    ...parseSimpleHtml(section.description)
                        .map((data) => AgoraRichTextItem(text: data.text, style: data.style)),
                  ],
                ),
              ),
            ],
          ),
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
    return Semantics(
      container: true,
      child: Padding(
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
      ),
    );
  }
}

class _VideoSectionWidget extends StatelessWidget {
  final _VideoSection section;
  final bool isTalkbackEnabled;

  _VideoSectionWidget(this.section, {required this.isTalkbackEnabled});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        left: AgoraSpacings.horizontalPadding,
        right: AgoraSpacings.horizontalPadding,
        top: AgoraSpacings.x2_5,
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
                eventName: "${AnalyticsEventNames.video} ${section.consultationId}",
                widgetName: AnalyticsScreenNames.consultationUpdatePage,
              );
            },
            isTalkbackEnabled: isTalkbackEnabled,
          ),
          const SizedBox(height: AgoraSpacings.base),
          Semantics(
            container: true,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (section.authorName != null)
                  Semantics(
                    header: true,
                    child: RichText(
                      textScaler: MediaQuery.textScalerOf(context),
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
                if (section.authorDescription != null) ...[
                  const SizedBox(height: AgoraSpacings.x0_5),
                  Padding(
                    padding: const EdgeInsets.only(left: AgoraSpacings.horizontalPadding),
                    child: Text(
                      section.authorDescription!,
                      style: AgoraTextStyles.mediumItalic14.copyWith(color: AgoraColors.primaryGreyOpacity80),
                    ),
                  ),
                ],
                if (section.date != null) ...[
                  SizedBox(height: AgoraSpacings.x0_5),
                  RichText(
                    textScaler: MediaQuery.textScalerOf(context),
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
                ],
              ],
            ),
          ),
          SizedBox(height: AgoraSpacings.base),
          Semantics(
            header: true,
            container: true,
            child: Text(QagStrings.transcription, style: AgoraTextStyles.medium18),
          ),
          SizedBox(height: AgoraSpacings.x0_5),
          Semantics(
            container: true,
            child: AgoraReadMoreV2Text(
              section.transcription,
              style: AgoraTextStyles.light16,
              isTalkbackEnabled: isTalkbackEnabled,
            ),
          ),
        ],
      ),
    );
  }
}

class _DownloadSectionWidget extends StatelessWidget {
  final DownloadSection section;

  _DownloadSectionWidget(this.section);

  @override
  Widget build(BuildContext context) {
    return Semantics(
      container: true,
      child: Padding(
        padding: const EdgeInsets.only(
          left: AgoraSpacings.horizontalPadding,
          right: AgoraSpacings.horizontalPadding,
          top: AgoraSpacings.x2_5,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: [
            ExcludeSemantics(child: Text('📘', style: AgoraTextStyles.light26)),
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
                    'Pour aller plus loin, retrouvez l’analyse détaillée de l’ensemble des réponses à cette consultation.',
                    style: AgoraTextStyles.light16,
                  ),
                  const SizedBox(height: AgoraSpacings.base),
                  Align(
                    alignment: Alignment.topLeft,
                    child: Semantics(
                      container: true,
                      child: AgoraButton(
                        label: 'Télécharger',
                        semanticLabel: 'Télécharger la synthèse complète',
                        buttonStyle: AgoraButtonStyle.blueBorder,
                        onPressed: () {
                          LaunchUrlHelper.launchUrlFromAgora(
                            url: section.url,
                            launchMode: LaunchMode.externalApplication,
                          );
                        },
                      ),
                    ),
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

class _ConsultationFeedbackQuestionSectionWidget extends StatelessWidget {
  final ConsultationFeedbackQuestionSection section;

  _ConsultationFeedbackQuestionSectionWidget(this.section);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        return DynamicConsultationFeedbackBloc(
          RepositoryManager.getConsultationRepository(),
        );
      },
      child: _ConsultationFeedbackQuestionSectionContentWidget(section),
    );
  }
}

class _ConsultationFeedbackQuestionSectionContentWidget extends StatefulWidget {
  final ConsultationFeedbackQuestionSection section;

  _ConsultationFeedbackQuestionSectionContentWidget(this.section);

  @override
  State<_ConsultationFeedbackQuestionSectionContentWidget> createState() =>
      _ConsultationFeedbackQuestionSectionWidgetState();
}

class _ConsultationFeedbackQuestionSectionWidgetState extends State<_ConsultationFeedbackQuestionSectionContentWidget> {
  bool? answer;
  bool? isLoading;

  @override
  void initState() {
    super.initState();
    answer = widget.section.userResponse;
    isLoading = false;
  }

  @override
  Widget build(BuildContext context) {
    return Semantics(
      container: true,
      child: Padding(
        padding: const EdgeInsets.only(
          left: AgoraSpacings.horizontalPadding,
          right: AgoraSpacings.horizontalPadding,
          top: AgoraSpacings.x2_5,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: [
            ExcludeSemantics(child: Text(widget.section.picto, style: AgoraTextStyles.light26)),
            const SizedBox(width: AgoraSpacings.base),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Semantics(
                    header: true,
                    child: Text(
                      widget.section.title,
                      style: AgoraTextStyles.medium16.copyWith(
                        color: AgoraColors.primaryBlue,
                      ),
                    ),
                  ),
                  const SizedBox(height: AgoraSpacings.x0_25),
                  if (answer == null)
                    AgoraHtml(data: widget.section.description)
                  else
                    Text(
                      'Merci pour votre avis\u{00A0}!',
                      style: AgoraTextStyles.light16,
                    ),
                  const SizedBox(height: AgoraSpacings.base),
                  if (answer == null)
                    Row(
                      children: [
                        AgoraRoundedButton(
                          icon: "ic_thumb_white.svg",
                          label: QagStrings.yes,
                          contentPadding: AgoraRoundedButtonPadding.short,
                          onPressed: () {
                            context.read<DynamicConsultationFeedbackBloc>().add(
                                  SendConsultationUpdateFeedbackEvent(
                                    consultationId: widget.section.consultationId,
                                    updateId: widget.section.id,
                                    isPositive: true,
                                  ),
                                );
                            setState(() {
                              isLoading = true;
                              answer = true;
                            });
                            Future.delayed(const Duration(seconds: 2)).then(
                              (_) => setState(() {
                                isLoading = false;
                              }),
                            );
                          },
                        ),
                        SizedBox(width: AgoraSpacings.base),
                        AgoraRoundedButton(
                          icon: "ic_thumb_down_white.svg",
                          label: QagStrings.no,
                          contentPadding: AgoraRoundedButtonPadding.short,
                          onPressed: () {
                            context.read<DynamicConsultationFeedbackBloc>().add(
                                  SendConsultationUpdateFeedbackEvent(
                                    consultationId: widget.section.consultationId,
                                    updateId: widget.section.id,
                                    isPositive: false,
                                  ),
                                );
                            setState(() {
                              isLoading = true;
                              answer = false;
                            });
                            Future.delayed(const Duration(seconds: 2)).then(
                              (_) => setState(() {
                                isLoading = false;
                              }),
                            );
                          },
                        ),
                      ],
                    )
                  else if (isLoading == true)
                    Align(
                      alignment: Alignment.centerLeft,
                      child: AnimatedContainer(
                        duration: Duration(seconds: 2),
                        child: Lottie.asset(
                          'assets/animations/check.json',
                          width: 48,
                          height: 48,
                        ),
                      ),
                    )
                  else if (answer != null) ...[
                    Align(
                      alignment: Alignment.centerLeft,
                      child: AgoraButton(
                        label: 'Modifier votre réponse',
                        buttonStyle: AgoraButtonStyle.blueBorder,
                        onPressed: () {
                          context.read<DynamicConsultationFeedbackBloc>().add(
                                DeleteConsultationUpdateFeedbackEvent(
                                  consultationId: widget.section.consultationId,
                                  updateId: widget.section.id,
                                ),
                              );
                          setState(() {
                            answer = null;
                          });
                        },
                      ),
                    ),
                    const SizedBox(height: AgoraSpacings.x0_5),
                    Text(
                      'Pour rappel, vous avez répondu "${answer == true ? 'Oui' : 'Non'}".',
                      style: AgoraTextStyles.light14,
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ConsultationFeedbackResultsSectionWidget extends StatelessWidget {
  final ConsultationFeedbackResultsSection section;

  _ConsultationFeedbackResultsSectionWidget(this.section);

  @override
  Widget build(BuildContext context) {
    return Semantics(
      container: true,
      child: Padding(
        padding: const EdgeInsets.only(
          left: AgoraSpacings.horizontalPadding,
          right: AgoraSpacings.horizontalPadding,
          top: AgoraSpacings.x2_5,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: [
            ExcludeSemantics(child: Text(section.picto, style: AgoraTextStyles.light26)),
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
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _NotificationSectionWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Semantics(
      container: true,
      child: Padding(
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
      ),
    );
  }
}

class _HistorySectionWidget extends StatelessWidget {
  final HistorySection section;

  _HistorySectionWidget(this.section);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        top: AgoraSpacings.x2_5,
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
                  'Suivi de la consultation',
                  style: AgoraTextStyles.medium18.copyWith(
                    color: AgoraColors.primaryBlue,
                  ),
                ),
              ),
              const SizedBox(height: AgoraSpacings.x2),
              ...section.steps.mapIndexed(
                (i, e) => _HistoryElementWidget(e, i == section.steps.length - 1, section.consultationId),
              ),
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
  final String consultationId;

  _HistoryElementWidget(this.step, this.isLast, this.consultationId);

  @override
  Widget build(BuildContext context) {
    return Semantics(
      container: true,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            if (step.type == ConsultationHistoryStepType.results) {
              Navigator.pushNamed(
                context,
                DynamicConsultationResultsPage.routeName,
                arguments: consultationId,
              );
            } else {
              Navigator.pushNamed(
                context,
                DynamicConsultationUpdatePage.routeName,
                arguments: DynamicConsultationUpdateArguments(
                  updateId: step.updateId!,
                  consultationId: consultationId,
                ),
              );
            }
          },
          child: IntrinsicHeight(
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
                          offset: Offset(0, 3),
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
                      if (step.actionText != null)
                        Text(step.actionText!, style: AgoraTextStyles.regular16UnderlineBlue),
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
          ),
        ),
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
      color: status == ConsultationHistoryStepStatus.current ? AgoraColors.primaryBlue : Colors.transparent,
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
                : AgoraColors.primaryBlue,
            size: 16,
          ),
        ),
      ),
    );
  }
}

class _ParticipantInfoSectionWidget extends StatelessWidget {
  final ParticipantInfoSection section;

  _ParticipantInfoSectionWidget(this.section);

  @override
  Widget build(BuildContext context) {
    return Semantics(
      container: true,
      child: Padding(
        padding: const EdgeInsets.only(
          left: AgoraSpacings.horizontalPadding,
          right: AgoraSpacings.horizontalPadding,
          top: AgoraSpacings.base,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: [
            Text('💬', style: AgoraTextStyles.light26),
            const SizedBox(width: AgoraSpacings.base),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Semantics(
                    header: true,
                    child: Text(
                      'Partagez cette consultation',
                      style: AgoraTextStyles.medium16.copyWith(
                        color: AgoraColors.primaryBlue,
                      ),
                    ),
                  ),
                  const SizedBox(height: AgoraSpacings.x0_25),
                  Text(
                    'Plus les citoyens seront nombreux à répondre, plus cette consultation aura de l’impact. Invitez vos proches à participer\u{00A0}!',
                    style: AgoraTextStyles.light16,
                  ),
                  const SizedBox(height: AgoraSpacings.base),
                  Text('${section.participantCount} participants', style: AgoraTextStyles.regular14),
                  const SizedBox(height: AgoraSpacings.x0_5),
                  ExcludeSemantics(
                    child: LinearProgressIndicator(
                      minHeight: AgoraSpacings.x0_5,
                      backgroundColor: AgoraColors.orochimaru,
                      valueColor: AlwaysStoppedAnimation<Color>(AgoraColors.mountainLakeAzure),
                      value: section.participantCount / section.participantCountGoal,
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                  const SizedBox(height: AgoraSpacings.x0_5),
                  Text(
                    ConsultationStrings.participantCountGoal.format(section.participantCountGoal.toString()),
                    style: AgoraTextStyles.regular14,
                  ),
                  const SizedBox(height: AgoraSpacings.base),
                  Align(
                    alignment: Alignment.topLeft,
                    child: AgoraButton(
                      label: 'Partager',
                      semanticLabel: 'Partager cette consultation',
                      buttonStyle: AgoraButtonStyle.blueBorder,
                      onPressed: () {
                        ShareHelper.sharePreformatted(context: context, data: section.shareText);
                      },
                    ),
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
