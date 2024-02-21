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
      _ExpandableSection() => _ExpandableSectionWidget(sectionToDisplay),
      _TitleSection() => _TitleSectionWidget(sectionToDisplay),
      _RichTextSection() => _RichTextSectionWidget(sectionToDisplay),
      _StartButtonTextSection() => _StartButtonWidget(),
      _FooterSection() => _FooterSectionWidget(sectionToDisplay),
      _ImageSection() => Text('TODO'),
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
      child: Text(
        section.label,
        style: AgoraTextStyles.medium18.copyWith(
          color: AgoraColors.primaryBlue,
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
            Image.network(section.coverUrl, excludeFromSemantics: true),
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
          if (section.title != null)
            const SizedBox(height: AgoraSpacings.base),
          AgoraHtml(data: section.description),
        ],
      ),
    );
  }
}
